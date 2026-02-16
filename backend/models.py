from sqlalchemy import Column, Integer, String, Float, DateTime, Boolean, ForeignKey, Text, Enum, Numeric, JSON, Table
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from datetime import datetime
import enum

Base = declarative_base()

# Tabela de associação para muitos-para-muitos (Carrinho - Produto)
carrinho_produtos = Table(
    'carrinho_produtos',
    Base.metadata,
    Column('carrinho_id', Integer, ForeignKey('carrinhos.id'), primary_key=True),
    Column('produto_id', Integer, ForeignKey('produtos.id'), primary_key=True),
    Column('quantidade', Integer, default=1),
    Column('preco_unitario', Numeric(10, 2))
)

# ===================== ENUMS =====================

class StatusPagamento(str, enum.Enum):
    pendente = "pendente"
    processando = "processando"
    concluido = "concluido"
    cancelado = "cancelado"
    falhou = "falhou"

class TipoReconhecimento(str, enum.Enum):
    rosto = "rosto"
    qrcode = "qrcode"
    documento = "documento"
    iris = "iris"

class StatusTransacao(str, enum.Enum):
    pendente = "pendente"
    sucesso = "sucesso"
    falha = "falha"

# ===================== MODELOS PRINCIPAIS =====================

class Usuario(Base):
    __tablename__ = "usuarios"
    
    id = Column(Integer, primary_key=True, index=True)
    nome = Column(String(150), nullable=False)
    email = Column(String(120), unique=True, nullable=False, index=True)
    cpf = Column(String(11), unique=True, nullable=False, index=True)
    telefone = Column(String(11))
    senha_hash = Column(String(255), nullable=False)
    data_nascimento = Column(String(10))  # YYYY-MM-DD
    genero = Column(String(10))
    endereco = Column(Text)
    numero_endereco = Column(String(10))
    complemento = Column(String(100))
    cep = Column(String(8))
    cidade = Column(String(100))
    estado = Column(String(2))
    
    # Verificações
    email_verificado = Column(Boolean, default=False)
    telefone_verificado = Column(Boolean, default=False)
    documento_verificado = Column(Boolean, default=False)
    rosto_verificado = Column(Boolean, default=False)
    
    # Histórico
    criado_em = Column(DateTime, default=datetime.utcnow, index=True)
    atualizado_em = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    ultimo_login = Column(DateTime)
    ativo = Column(Boolean, default=True, index=True)
    
    # Foto de perfil
    foto_perfil_url = Column(String(255))
    
    # Relacionamentos
    transacoes = relationship("Transacao", back_populates="usuario", cascade="all, delete-orphan")
    reconhecimentos = relationship("Reconhecimento", back_populates="usuario", cascade="all, delete-orphan")
    carrinhos = relationship("Carrinho", back_populates="usuario", cascade="all, delete-orphan")
    enderecosEntrega = relationship("EnderecoEntrega", back_populates="usuario", cascade="all, delete-orphan")
    metodosPagamento = relationship("MetodoPagamento", back_populates="usuario", cascade="all, delete-orphan")


class Produto(Base):
    __tablename__ = "produtos"
    
    id = Column(Integer, primary_key=True, index=True)
    nome = Column(String(150), nullable=False, index=True)
    descricao = Column(Text)
    categoria = Column(String(50), index=True)
    subcategoria = Column(String(50))
    preco = Column(Numeric(10, 2), nullable=False)
    preco_desconto = Column(Numeric(10, 2))
    estoque = Column(Integer, default=0)
    estoque_minimo = Column(Integer, default=10)
    
    # Imagens e detalhes
    imagem_principal_url = Column(String(255))
    imagens_adicionais = Column(JSON)  # Lista de URLs
    peso = Column(Float)  # em kg
    dimensoes = Column(String(50))  # LxAxP
    sku = Column(String(50), unique=True, index=True)
    codigo_barras = Column(String(50), unique=True, index=True)
    
    # Dados de vendas
    rating_medio = Column(Float, default=0)
    numero_avaliacoes = Column(Integer, default=0)
    numero_vendas = Column(Integer, default=0)
    
    # Status
    ativo = Column(Boolean, default=True, index=True)
    criado_em = Column(DateTime, default=datetime.utcnow)
    atualizado_em = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relacionamentos
    itensCarrinho = relationship("ItemCarrinho", back_populates="produto", cascade="all, delete-orphan")
    itensTransacao = relationship("ItemTransacao", back_populates="produto")
    avaliacoes = relationship("Avaliacao", back_populates="produto", cascade="all, delete-orphan")


class Carrinho(Base):
    __tablename__ = "carrinhos"
    
    id = Column(Integer, primary_key=True, index=True)
    usuario_id = Column(Integer, ForeignKey("usuarios.id"), nullable=False, index=True)
    criado_em = Column(DateTime, default=datetime.utcnow)
    atualizado_em = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    abandono_em = Column(DateTime)  # Para rastrear carrinhos abandonados
    
    # Relacionamentos
    usuario = relationship("Usuario", back_populates="carrinhos")
    itens = relationship("ItemCarrinho", back_populates="carrinho", cascade="all, delete-orphan")


class ItemCarrinho(Base):
    __tablename__ = "itens_carrinho"
    
    id = Column(Integer, primary_key=True, index=True)
    carrinho_id = Column(Integer, ForeignKey("carrinhos.id"), nullable=False, index=True)
    produto_id = Column(Integer, ForeignKey("produtos.id"), nullable=False, index=True)
    quantidade = Column(Integer, default=1)
    preco_unitario = Column(Numeric(10, 2), nullable=False)
    preco_total = Column(Numeric(10, 2), nullable=False)
    adicionado_em = Column(DateTime, default=datetime.utcnow)
    
    # Relacionamentos
    carrinho = relationship("Carrinho", back_populates="itens")
    produto = relationship("Produto", back_populates="itensCarrinho")


class Transacao(Base):
    __tablename__ = "transacoes"
    
    id = Column(Integer, primary_key=True, index=True)
    usuario_id = Column(Integer, ForeignKey("usuarios.id"), nullable=False, index=True)
    numero_pedido = Column(String(20), unique=True, nullable=False, index=True)
    
    # Valores
    subtotal = Column(Numeric(10, 2), nullable=False)
    desconto = Column(Numeric(10, 2), default=0)
    taxa_entrega = Column(Numeric(10, 2), default=0)
    taxa_servico = Column(Numeric(10, 2), default=0)
    valor_total = Column(Numeric(10, 2), nullable=False)
    
    # Status e pagamento
    status_pagamento = Column(Enum(StatusPagamento), default=StatusPagamento.pendente, index=True)
    status_transacao = Column(Enum(StatusTransacao), default=StatusTransacao.pendente, index=True)
    metodo_pagamento = Column(String(50))  # qrcode, cartao, pix, dinheiro, boleto
    
    # Dados de entrega
    endereco_entrega_id = Column(Integer, ForeignKey("enderecos_entrega.id"))
    status_entrega = Column(String(50), default="aguardando")  # aguardando, enviado, entregue, cancelado
    data_entrega_estimada = Column(DateTime)
    numero_rastreamento = Column(String(50), index=True)
    
    # Timestamps
    criado_em = Column(DateTime, default=datetime.utcnow, index=True)
    atualizado_em = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    confirmado_em = Column(DateTime)
    cancelado_em = Column(DateTime)
    concluido_em = Column(DateTime)
    
    # Notas e observações
    observacoes = Column(Text)
    motivo_cancelamento = Column(String(255))
    
    # Relacionamentos
    usuario = relationship("Usuario", back_populates="transacoes")
    itens = relationship("ItemTransacao", back_populates="transacao", cascade="all, delete-orphan")
    endereco = relationship("EnderecoEntrega")
    pagamento = relationship("Pagamento", uselist=False, back_populates="transacao", cascade="all, delete-orphan")


class ItemTransacao(Base):
    __tablename__ = "itens_transacao"
    
    id = Column(Integer, primary_key=True, index=True)
    transacao_id = Column(Integer, ForeignKey("transacoes.id"), nullable=False, index=True)
    produto_id = Column(Integer, ForeignKey("produtos.id"), nullable=False)
    quantidade = Column(Integer, nullable=False)
    preco_unitario = Column(Numeric(10, 2), nullable=False)
    preco_total = Column(Numeric(10, 2), nullable=False)
    
    # Relacionamentos
    transacao = relationship("Transacao", back_populates="itens")
    produto = relationship("Produto", back_populates="itensTransacao")


class Pagamento(Base):
    __tablename__ = "pagamentos"
    
    id = Column(Integer, primary_key=True, index=True)
    transacao_id = Column(Integer, ForeignKey("transacoes.id"), nullable=False, unique=True, index=True)
    
    # Detalhes do pagamento
    valor_pago = Column(Numeric(10, 2), nullable=False)
    metodo = Column(String(50), nullable=False)  # qrcode, cartao, pix, dinheiro
    
    # Para QR Code / PIX
    codigo_qr = Column(String(255))
    qr_code_url = Column(String(255))
    chave_pix = Column(String(50))
    
    # Para Cartão
    ultimos_digitos_cartao = Column(String(4))
    bandeira_cartao = Column(String(20))
    
    # Status e confirmação
    status = Column(Enum(StatusPagamento), default=StatusPagamento.pendente, index=True)
    confirmado = Column(Boolean, default=False)
    confirmado_em = Column(DateTime)
    id_transacao_gateway = Column(String(100), index=True)  # ID da transação no gateway
    
    # Timestamps
    criado_em = Column(DateTime, default=datetime.utcnow)
    atualizado_em = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    tentativas = Column(Integer, default=0)
    proxima_tentativa = Column(DateTime)
    
    # Relacionamento
    transacao = relationship("Transacao", back_populates="pagamento")


class Reconhecimento(Base):
    __tablename__ = "reconhecimentos"
    
    id = Column(Integer, primary_key=True, index=True)
    usuario_id = Column(Integer, ForeignKey("usuarios.id"), nullable=False, index=True)
    
    # Tipo e resultado
    tipo = Column(Enum(TipoReconhecimento), nullable=False)
    resultado = Column(Enum(StatusTransacao), default=StatusTransacao.pendente, index=True)
    confianca = Column(Float, default=0)  # 0-1 (0-100%)
    
    # Detalhes técnicos
    imagem_url = Column(String(255))
    imagem_processada_url = Column(String(255))
    modelo_versao = Column(String(50))
    tempo_processamento_ms = Column(Integer)
    
    # Dados do resultado
    detalhes_resultado = Column(JSON)  # Dados adicionais do reconhecimento
    
    # Contexto da transação
    transacao_id = Column(Integer, ForeignKey("transacoes.id"))
    
    # Timestamps
    criado_em = Column(DateTime, default=datetime.utcnow, index=True)
    atualizado_em = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relacionamento
    usuario = relationship("Usuario", back_populates="reconhecimentos")


class MetodoPagamento(Base):
    __tablename__ = "metodos_pagamento"
    
    id = Column(Integer, primary_key=True, index=True)
    usuario_id = Column(Integer, ForeignKey("usuarios.id"), nullable=False, index=True)
    
    # Tipo de método
    tipo = Column(String(50), nullable=False)  # cartao, pix, conta_bancaria
    
    # Para Cartão
    ultimos_digitos = Column(String(4))
    bandeira = Column(String(20))
    nome_titular = Column(String(150))
    mes_validade = Column(String(2))
    ano_validade = Column(String(4))
    token_cartao = Column(String(255))  # Token criptografado (não armazene dados reais)
    
    # Para PIX
    chave_pix = Column(String(150))
    tipo_chave = Column(String(20))  # cpf, email, telefone, aleatoria
    
    # Para Conta Bancária
    banco = Column(String(50))
    agencia = Column(String(10))
    numero_conta = Column(String(20))
    tipo_conta = Column(String(20))  # corrente, poupanca
    
    # Status
    padrao = Column(Boolean, default=False)
    ativo = Column(Boolean, default=True)
    criado_em = Column(DateTime, default=datetime.utcnow)
    atualizado_em = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relacionamento
    usuario = relationship("Usuario", back_populates="metodosPagamento")


class EnderecoEntrega(Base):
    __tablename__ = "enderecos_entrega"
    
    id = Column(Integer, primary_key=True, index=True)
    usuario_id = Column(Integer, ForeignKey("usuarios.id"), nullable=False, index=True)
    
    # Endereço
    logradouro = Column(String(150), nullable=False)
    numero = Column(String(10), nullable=False)
    complemento = Column(String(100))
    bairro = Column(String(100), nullable=False)
    cep = Column(String(8), nullable=False)
    cidade = Column(String(100), nullable=False)
    estado = Column(String(2), nullable=False)
    
    # Identificação
    apelido = Column(String(50))  # "Casa", "Trabalho", etc
    padrao = Column(Boolean, default=False)
    ativo = Column(Boolean, default=True)
    
    criado_em = Column(DateTime, default=datetime.utcnow)
    atualizado_em = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relacionamento
    usuario = relationship("Usuario", back_populates="enderecosEntrega")


class Avaliacao(Base):
    __tablename__ = "avaliacoes"
    
    id = Column(Integer, primary_key=True, index=True)
    transacao_id = Column(Integer, ForeignKey("transacoes.id"), nullable=False, index=True)
    produto_id = Column(Integer, ForeignKey("produtos.id"), nullable=False, index=True)
    usuario_id = Column(Integer, ForeignKey("usuarios.id"), nullable=False, index=True)
    
    # Avaliação
    nota = Column(Integer, nullable=False)  # 1-5 estrelas
    titulo = Column(String(150))
    texto = Column(Text)
    
    # Aspectos
    qualidade_produto = Column(Integer)  # 1-5
    descricao_acurada = Column(Integer)  # 1-5
    tempo_entrega = Column(Integer)  # 1-5
    
    criado_em = Column(DateTime, default=datetime.utcnow, index=True)
    atualizado_em = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relacionamento
    produto = relationship("Produto", back_populates="avaliacoes")


class Log(Base):
    __tablename__ = "logs"
    
    id = Column(Integer, primary_key=True, index=True)
    usuario_id = Column(Integer, ForeignKey("usuarios.id"), index=True)
    tipo_acao = Column(String(50), nullable=False, index=True)  # login, logout, compra, cancelamento, etc
    descricao = Column(Text)
    endereco_ip = Column(String(45))
    user_agent = Column(String(255))
    criado_em = Column(DateTime, default=datetime.utcnow, index=True)
