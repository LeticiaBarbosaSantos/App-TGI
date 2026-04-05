from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from models import Usuario, Transacao, Produto, Reconhecimento
from database import get_db
from pydantic import BaseModel
from datetime import datetime
import qrcode
import io
import base64
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

class CarrinhoItemCreate(BaseModel):
    produto_id: int
    quantidade: int = 1


def get_or_create_carrinho(usuario_id: int, db: Session):
    carrinho = db.query(Carrinho).filter(Carrinho.usuario_id == usuario_id).first()
    if carrinho is None:
        carrinho = Carrinho(usuario_id=usuario_id)
        db.add(carrinho)
        db.commit()
        db.refresh(carrinho)
    return carrinho

@app.get("/carrinhos/{usuario_id}")
def listar_carrinho(usuario_id: int, db: Session = Depends(get_db)):
    """Listar itens do carrinho de um usuário"""
    usuario = db.query(Usuario).filter(Usuario.id == usuario_id).first()
    if not usuario:
        raise HTTPException(status_code=404, detail="Usuário não encontrado")

    carrinho = get_or_create_carrinho(usuario_id, db)
    itens = []
    total = 0.0
    for item in carrinho.itens:
        preco_total = float(item.preco_total)
        total += preco_total
        itens.append({
            "produto_id": item.produto_id,
            "nome": item.produto.nome,
            "quantidade": item.quantidade,
            "preco_unitario": float(item.preco_unitario),
            "preco_total": preco_total,
        })

    return {
        "usuario_id": usuario_id,
        "carrinho_id": carrinho.id,
        "total": total,
        "itens": itens,
    }

@app.post("/carrinho/{usuario_id}/itens")
def adicionar_item_carrinho(usuario_id: int, item: CarrinhoItemCreate, db: Session = Depends(get_db)):
    """Adicionar um item ao carrinho"""
    usuario = db.query(Usuario).filter(Usuario.id == usuario_id).first()
    if not usuario:
        raise HTTPException(status_code=404, detail="Usuário não encontrado")

    produto = db.query(Produto).filter(Produto.id == item.produto_id).first()
    if not produto:
        raise HTTPException(status_code=404, detail="Produto não encontrado")

    carrinho = get_or_create_carrinho(usuario_id, db)
    item_existente = db.query(ItemCarrinho).filter(
        ItemCarrinho.carrinho_id == carrinho.id,
        ItemCarrinho.produto_id == produto.id
    ).first()

    if item_existente:
        item_existente.quantidade += item.quantidade
        item_existente.preco_total = float(item_existente.preco_unitario) * item_existente.quantidade
    else:
        item_existente = ItemCarrinho(
            carrinho_id=carrinho.id,
            produto_id=produto.id,
            quantidade=item.quantidade,
            preco_unitario=produto.preco,
            preco_total=produto.preco * item.quantidade,
        )
        db.add(item_existente)

    db.commit()
    db.refresh(item_existente)

    return {
        "produto_id": item_existente.produto_id,
        "nome": produto.nome,
        "quantidade": item_existente.quantidade,
        "preco_unitario": float(item_existente.preco_unitario),
        "preco_total": float(item_existente.preco_total),
    }

@app.delete("/carrinho/{usuario_id}/itens/{produto_id}")
def remover_item_carrinho(usuario_id: int, produto_id: int, db: Session = Depends(get_db)):
    """Remover um item do carrinho"""
    carrinho = get_or_create_carrinho(usuario_id, db)
    item = db.query(ItemCarrinho).filter(
        ItemCarrinho.carrinho_id == carrinho.id,
        ItemCarrinho.produto_id == produto_id
    ).first()

    if not item:
        raise HTTPException(status_code=404, detail="Item não encontrado no carrinho")

    db.delete(item)
    db.commit()

    return {"removido": True, "produto_id": produto_id}

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

# ==================== ROTAS DE QR CODE ====================

def gerar_qr_code(usuario_id: int) -> str:
    """
    Gera um QR code em base64 contendo o usuario_id
    Retorna string base64 da imagem PNG
    """
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=2,
    )
    qr.add_data(f"usuario_{usuario_id}")
    qr.make(fit=True)
    
    img = qr.make_image(fill_color="black", back_color="white")
    
    # Salva em memória
    img_io = io.BytesIO()
    img.save(img_io, "PNG")
    img_io.seek(0)
    
    # Converte para base64
    img_base64 = base64.b64encode(img_io.getvalue()).decode()
    return f"data:image/png;base64,{img_base64}"

@app.get("/qrcode/usuario/{usuario_id}")
def obter_qr_code_usuario(usuario_id: int, db: Session = Depends(get_db)):
    """
    Obter o QR code de um usuário
    """
    usuario = db.query(Usuario).filter(Usuario.id == usuario_id).first()
    if not usuario:
        raise HTTPException(status_code=404, detail="Usuário não encontrado")
    
    if not usuario.qr_code_url:
        # Gera QR code se não existir
        usuario.qr_code_data = f"usuario_{usuario_id}"
        usuario.qr_code_url = gerar_qr_code(usuario_id)
        db.commit()
    
    return {
        "usuario_id": usuario_id,
        "qr_code_data": usuario.qr_code_data,
        "qr_code_base64": usuario.qr_code_url,
    }

@app.post("/qrcode/validar")
def validar_qr_code(qr_data: str, db: Session = Depends(get_db)):
    """
    Validar um QR code escaneado
    Exemplo: qr_data = "usuario_1"
    """
    usuario = db.query(Usuario).filter(Usuario.qr_code_data == qr_data).first()
    if not usuario:
        raise HTTPException(status_code=404, detail="QR code inválido")
    
    return {
        "usuario_id": usuario.id,
        "nome": usuario.nome,
        "email": usuario.email,
        "identificado": True,
    }

# ==================== HEALTH CHECK ====================

@app.get("/health")
def health_check():
    """Verificar se API está online"""
    return {"status": "ok"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
