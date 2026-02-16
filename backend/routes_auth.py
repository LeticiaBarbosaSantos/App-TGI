from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy import func
from models import Usuario, Log
from database import get_db
from pydantic import BaseModel, EmailStr
from datetime import datetime, timedelta
import bcrypt
import jwt
from typing import Optional
import os

router = APIRouter(prefix="/auth", tags=["Autenticação"])

# Configurações de segurança
SECRET_KEY = os.getenv("SECRET_KEY", "sua-chave-super-secreta-aqui-mude-em-producao")
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_HOURS = 24

# ==================== SCHEMAS ====================

class UsuarioRegistro(BaseModel):
    nome: str
    email: EmailStr
    cpf: str
    senha: str
    telefone: Optional[str] = None
    data_nascimento: Optional[str] = None

class UsuarioLogin(BaseModel):
    email: str
    senha: str

class TokenResponse(BaseModel):
    access_token: str
    token_type: str
    usuario_id: int
    nome: str
    email: str

class UsuarioResponse(BaseModel):
    id: int
    nome: str
    email: str
    cpf: str
    telefone: Optional[str]
    data_nascimento: Optional[str]
    endereco: Optional[str]
    numero_endereco: Optional[str]
    cep: Optional[str]
    cidade: Optional[str]
    estado: Optional[str]
    email_verificado: bool
    rosto_verificado: bool
    documento_verificado: bool
    criado_em: datetime
    
    class Config:
        from_attributes = True

# ==================== FUNÇÕES AUXILIARES ====================

def hash_senha(senha: str) -> str:
    """Hash da senha com bcrypt"""
    return bcrypt.hashpw(senha.encode(), bcrypt.gensalt()).decode()

def verificar_senha(senha_plana: str, senha_hash: str) -> bool:
    """Verifica se a senha corresponde ao hash"""
    return bcrypt.checkpw(senha_plana.encode(), senha_hash.encode())

def criar_token_jwt(usuario_id: int, email: str) -> str:
    """Cria um token JWT"""
    payload = {
        "usuario_id": usuario_id,
        "email": email,
        "exp": datetime.utcnow() + timedelta(hours=ACCESS_TOKEN_EXPIRE_HOURS)
    }
    return jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)

def verificar_token(token: str) -> dict:
    """Verifica e decodifica o token JWT"""
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        return payload
    except jwt.InvalidTokenError:
        raise HTTPException(status_code=401, detail="Token inválido")

def registrar_log(db: Session, usuario_id: Optional[int], tipo_acao: str, 
                  descricao: str = "", endereco_ip: str = ""):
    """Registra uma ação no log"""
    log = Log(
        usuario_id=usuario_id,
        tipo_acao=tipo_acao,
        descricao=descricao,
        endereco_ip=endereco_ip
    )
    db.add(log)
    db.commit()

# ==================== ROTAS DE AUTENTICAÇÃO ====================

@router.post("/registro", response_model=UsuarioResponse)
def registrar_usuario(usuario: UsuarioRegistro, db: Session = Depends(get_db)):
    """
    Registrar novo usuário
    
    - **nome**: Nome completo
    - **email**: Email válido (usado para login)
    - **cpf**: CPF único (11 dígitos)
    - **senha**: Mínimo 6 caracteres
    """
    
    # Verificar se email já existe
    email_existente = db.query(Usuario).filter(Usuario.email == usuario.email).first()
    if email_existente:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email já cadastrado"
        )
    
    # Verificar se CPF já existe
    cpf_existente = db.query(Usuario).filter(Usuario.cpf == usuario.cpf).first()
    if cpf_existente:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="CPF já cadastrado"
        )
    
    # Validar comprimento da senha
    if len(usuario.senha) < 6:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Senha deve ter no mínimo 6 caracteres"
        )
    
    # Criar novo usuário
    novo_usuario = Usuario(
        nome=usuario.nome,
        email=usuario.email,
        cpf=usuario.cpf,
        senha_hash=hash_senha(usuario.senha),
        telefone=usuario.telefone,
        data_nascimento=usuario.data_nascimento
    )
    
    db.add(novo_usuario)
    db.commit()
    db.refresh(novo_usuario)
    
    # Registrar no log
    registrar_log(db, novo_usuario.id, "cadastro", "Novo usuário registrado")
    
    return novo_usuario

@router.post("/login", response_model=TokenResponse)
def login_usuario(credenciais: UsuarioLogin, db: Session = Depends(get_db)):
    """
    Fazer login com email e senha
    
    Retorna um token JWT válido por 24 horas
    """
    
    # Buscar usuário por email
    usuario = db.query(Usuario).filter(Usuario.email == credenciais.email).first()
    
    if not usuario:
        registrar_log(db, None, "login_falhou", f"Email não encontrado: {credenciais.email}")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Email ou senha incorretos"
        )
    
    # Verificar se usuário está ativo
    if not usuario.ativo:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Usuário desativado"
        )
    
    # Verificar senha
    if not verificar_senha(credenciais.senha, usuario.senha_hash):
        registrar_log(db, usuario.id, "login_falhou", "Senha incorreta")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Email ou senha incorretos"
        )
    
    # Atualizar último login
    usuario.ultimo_login = datetime.utcnow()
    db.commit()
    
    # Registrar login bem-sucedido
    registrar_log(db, usuario.id, "login", "Login realizado com sucesso")
    
    # Gerar token
    token = criar_token_jwt(usuario.id, usuario.email)
    
    return {
        "access_token": token,
        "token_type": "bearer",
        "usuario_id": usuario.id,
        "nome": usuario.nome,
        "email": usuario.email
    }

@router.get("/perfil/{usuario_id}", response_model=UsuarioResponse)
def obter_perfil(usuario_id: int, db: Session = Depends(get_db)):
    """
    Obter perfil do usuário (público, sem dados sensíveis)
    """
    usuario = db.query(Usuario).filter(Usuario.id == usuario_id).first()
    
    if not usuario:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Usuário não encontrado"
        )
    
    return usuario

@router.put("/perfil/{usuario_id}", response_model=UsuarioResponse)
def atualizar_perfil(
    usuario_id: int,
    updates: dict,
    db: Session = Depends(get_db)
):
    """
    Atualizar perfil do usuário
    
    Campos atualizáveis: nome, telefone, endereco, numero_endereco, cep, cidade, estado
    """
    usuario = db.query(Usuario).filter(Usuario.id == usuario_id).first()
    
    if not usuario:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Usuário não encontrado"
        )
    
    # Campos permitidos para atualização
    campos_permitidos = {
        "nome", "telefone", "endereco", "numero_endereco",
        "complemento", "cep", "cidade", "estado", "data_nascimento", "genero"
    }
    
    for campo, valor in updates.items():
        if campo in campos_permitidos:
            setattr(usuario, campo, valor)
    
    usuario.atualizado_em = datetime.utcnow()
    db.commit()
    db.refresh(usuario)
    
    registrar_log(db, usuario.id, "perfil_atualizado", "Perfil atualizado")
    
    return usuario

@router.post("/verificar-email/{usuario_id}")
def verificar_email(usuario_id: int, db: Session = Depends(get_db)):
    """
    Marcar email como verificado
    (Em produção, você teria um fluxo com código de confirmação)
    """
    usuario = db.query(Usuario).filter(Usuario.id == usuario_id).first()
    
    if not usuario:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Usuário não encontrado"
        )
    
    usuario.email_verificado = True
    db.commit()
    
    registrar_log(db, usuario.id, "email_verificado", "Email verificado")
    
    return {"mensagem": "Email verificado com sucesso"}

@router.post("/verificar-rosto/{usuario_id}")
def verificar_rosto(usuario_id: int, db: Session = Depends(get_db)):
    """
    Marcar rosto como verificado (após reconhecimento bem-sucedido)
    """
    usuario = db.query(Usuario).filter(Usuario.id == usuario_id).first()
    
    if not usuario:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Usuário não encontrado"
        )
    
    usuario.rosto_verificado = True
    db.commit()
    
    registrar_log(db, usuario.id, "rosto_verificado", "Rosto verificado")
    
    return {"mensagem": "Rosto verificado com sucesso"}

@router.post("/verificar-documento/{usuario_id}")
def verificar_documento(usuario_id: int, db: Session = Depends(get_db)):
    """
    Marcar documento como verificado
    """
    usuario = db.query(Usuario).filter(Usuario.id == usuario_id).first()
    
    if not usuario:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Usuário não encontrado"
        )
    
    usuario.documento_verificado = True
    db.commit()
    
    registrar_log(db, usuario.id, "documento_verificado", "Documento verificado")
    
    return {"mensagem": "Documento verificado com sucesso"}

@router.post("/alterar-senha/{usuario_id}")
def alterar_senha(usuario_id: int, senha_atual: str, senha_nova: str, db: Session = Depends(get_db)):
    """
    Alterar senha do usuário
    """
    usuario = db.query(Usuario).filter(Usuario.id == usuario_id).first()
    
    if not usuario:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Usuário não encontrado"
        )
    
    # Verificar senha atual
    if not verificar_senha(senha_atual, usuario.senha_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Senha atual incorreta"
        )
    
    # Validar nova senha
    if len(senha_nova) < 6:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Nova senha deve ter no mínimo 6 caracteres"
        )
    
    # Atualizar senha
    usuario.senha_hash = hash_senha(senha_nova)
    db.commit()
    
    registrar_log(db, usuario.id, "senha_alterada", "Senha alterada")
    
    return {"mensagem": "Senha alterada com sucesso"}

@router.delete("/desativar-conta/{usuario_id}")
def desativar_conta(usuario_id: int, db: Session = Depends(get_db)):
    """
    Desativar conta do usuário (soft delete)
    """
    usuario = db.query(Usuario).filter(Usuario.id == usuario_id).first()
    
    if not usuario:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Usuário não encontrado"
        )
    
    usuario.ativo = False
    db.commit()
    
    registrar_log(db, usuario.id, "conta_desativada", "Conta desativada")
    
    return {"mensagem": "Conta desativada com sucesso"}
