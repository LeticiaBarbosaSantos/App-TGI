from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from models import Usuario, Transacao, Produto, Reconhecimento
from database import get_db
from pydantic import BaseModel
from datetime import datetime
# import cv2
# import numpy as np
from typing import Optional
from routes_auth import router as auth_router

app = FastAPI(title="SmartPay API")

# Incluir rotas de autenticação
app.include_router(auth_router)

# Configurar CORS para Flutter
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Schemas Pydantic
class UsuarioCreate(BaseModel):
    nome: str
    email: str
    cpf: str
    senha: str
    telefone: Optional[str] = None

class UsuarioResponse(BaseModel):
    id: int
    nome: str
    email: str
    telefone: Optional[str]
    
    class Config:
        from_attributes = True

class ProdutoResponse(BaseModel):
    id: int
    nome: str
    preco: float
    estoque: int
    
    class Config:
        from_attributes = True

class TransacaoCreate(BaseModel):
    usuario_id: int
    valor: float
    metodo_pagamento: str

# ==================== ROTAS DE USUÁRIOS ====================

@app.post("/usuarios/registrar", response_model=UsuarioResponse)
def registrar_usuario(usuario: UsuarioCreate, db: Session = Depends(get_db)):
    """Registrar novo usuário"""
    db_usuario = Usuario(
        nome=usuario.nome,
        email=usuario.email,
        cpf=usuario.cpf,
        senha=usuario.senha,  # Em produção: hash a senha!
        telefone=usuario.telefone
    )
    db.add(db_usuario)
    db.commit()
    db.refresh(db_usuario)
    return db_usuario

@app.get("/usuarios/{usuario_id}", response_model=UsuarioResponse)
def obter_usuario(usuario_id: int, db: Session = Depends(get_db)):
    """Obter dados do usuário"""
    usuario = db.query(Usuario).filter(Usuario.id == usuario_id).first()
    if not usuario:
        raise HTTPException(status_code=404, detail="Usuário não encontrado")
    return usuario

# ==================== ROTAS DE PRODUTOS ====================

@app.get("/produtos", response_model=list[ProdutoResponse])
def listar_produtos(db: Session = Depends(get_db)):
    """Listar todos os produtos"""
    return db.query(Produto).all()

@app.get("/produtos/{produto_id}", response_model=ProdutoResponse)
def obter_produto(produto_id: int, db: Session = Depends(get_db)):
    """Obter detalhes de um produto"""
    produto = db.query(Produto).filter(Produto.id == produto_id).first()
    if not produto:
        raise HTTPException(status_code=404, detail="Produto não encontrado")
    return produto

# ==================== ROTAS DE TRANSAÇÕES ====================

@app.post("/transacoes/criar")
def criar_transacao(transacao: TransacaoCreate, db: Session = Depends(get_db)):
    """Criar nova transação"""
    # Verificar se usuário existe
    usuario = db.query(Usuario).filter(Usuario.id == transacao.usuario_id).first()
    if not usuario:
        raise HTTPException(status_code=404, detail="Usuário não encontrado")
    
    db_transacao = Transacao(
        usuario_id=transacao.usuario_id,
        valor=transacao.valor,
        metodo_pagamento=transacao.metodo_pagamento,
        status="pendente"
    )
    db.add(db_transacao)
    db.commit()
    db.refresh(db_transacao)
    
    return {
        "id": db_transacao.id,
        "status": db_transacao.status,
        "valor": db_transacao.valor
    }

@app.put("/transacoes/{transacao_id}/confirmar")
def confirmar_transacao(transacao_id: int, db: Session = Depends(get_db)):
    """Confirmar transação após reconhecimento bem-sucedido"""
    transacao = db.query(Transacao).filter(Transacao.id == transacao_id).first()
    if not transacao:
        raise HTTPException(status_code=404, detail="Transação não encontrada")
    
    transacao.status = "concluido"
    transacao.concluido_em = datetime.utcnow()
    db.commit()
    
    return {"status": "sucesso", "transacao_id": transacao.id}

@app.get("/transacoes/usuario/{usuario_id}")
def listar_transacoes_usuario(usuario_id: int, db: Session = Depends(get_db)):
    """Listar histórico de transações do usuário"""
    transacoes = db.query(Transacao).filter(
        Transacao.usuario_id == usuario_id
    ).order_by(Transacao.criado_em.desc()).all()
    
    return [
        {
            "id": t.id,
            "valor": t.valor,
            "status": t.status,
            "metodo": t.metodo_pagamento,
            "data": t.criado_em
        }
        for t in transacoes
    ]

# ==================== ROTAS DE RECONHECIMENTO ====================

@app.post("/reconhecimento/processar")
async def processar_reconhecimento(usuario_id: int, tipo: str, db: Session = Depends(get_db)):
    """
    Processar reconhecimento de imagem/QR code
    tipo: 'rosto', 'qrcode', 'documento'
    """
    # Aqui você integraria seu modelo de ML
    # Este é um exemplo simplificado
    
    reconhecimento = Reconhecimento(
        usuario_id=usuario_id,
        tipo=tipo,
        confianca=0.95,  # Valor do seu modelo ML
        resultado="sucesso"
    )
    db.add(reconhecimento)
    db.commit()
    
    return {
        "resultado": "sucesso",
        "confianca": 0.95,
        "tipo": tipo
    }

# ==================== HEALTH CHECK ====================

@app.get("/health")
def health_check():
    """Verificar se API está online"""
    return {"status": "ok"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
