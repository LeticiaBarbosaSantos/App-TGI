# 🗄️ BANCO DE DADOS FINAL - SmartPay

## Tabelas Principais (12 no total)

```
┌─────────────────────────────────────────────────────────────┐
│                      SMART PAY DATABASE                      │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────┐         ┌──────────────┐                 │
│  │  USUARIOS    │◄───────┤  TRANSACOES  │                 │
│  ├──────────────┤         ├──────────────┤                 │
│  │ id (PK)      │         │ id (PK)      │                 │
│  │ nome         │         │ usuario_id   │                 │
│  │ email (U)    │         │ numero_pedido│                 │
│  │ cpf (U)      │         │ subtotal     │                 │
│  │ telefone     │         │ valor_total  │                 │
│  │ senha_hash   │         │ status_pag   │                 │
│  │ data_nasc    │         │ metodo_pag   │                 │
│  │ endereco     │         │ criado_em    │                 │
│  │ verificacoes │         │ confirmado   │                 │
│  │ foto_perfil  │         │ cancelado    │                 │
│  └──────────────┘         └──────────────┘                 │
│         │                         │                         │
│         ├───────────┬─────────────┤                         │
│         │           │             │                         │
│    ┌────▼──┐  ┌─────▼───┐  ┌────▼─────┐                   │
│    │CARRINHO│  │ENDEREÇOS│  │PAGAMENTO │                   │
│    ├────────┤  ├─────────┤  ├──────────┤                   │
│    │ id(PK) │  │ id(PK)  │  │ id(PK)   │                   │
│    │usuario │  │usuario  │  │transacao │                   │
│    │itens[] │  │endereco │  │valor_pago│                   │
│    │criado  │  │padrao   │  │metodo    │                   │
│    └────┬───┘  │bairro   │  │qr_code   │                   │
│         │      │cep      │  │status    │                   │
│    ┌────▼──────┤cidade   │  │tentativas│                   │
│    │            └─────────┘  └──────────┘                   │
│    │                                                        │
│┌───▼────────────┐      ┌──────────────┐                   │
││ITENS_CARRINHO  │      │  PRODUTOS    │                   │
│├────────────────┤      ├──────────────┤                   │
││ id (PK)        │      │ id (PK)      │                   │
││ carrinho_id    │◄─────┤ nome         │                   │
││ produto_id     ├──────► sku (U)      │                   │
││ quantidade     │      │ preco        │                   │
││ preco_unitario │      │ estoque      │                   │
││ preco_total    │      │ categoria    │                   │
│└────────────────┘      │ imagens      │                   │
│                        │ rating       │                   │
│                        │ criado_em    │                   │
│                        └──────┬───────┘                   │
│                               │                           │
│                        ┌──────▼──────┐                   │
│                        │ AVALIACOES  │                   │
│                        ├─────────────┤                   │
│                        │ id (PK)     │                   │
│                        │ produto_id  │                   │
│                        │ usuario_id  │                   │
│                        │ nota (1-5)  │                   │
│                        │ titulo      │                   │
│                        │ texto       │                   │
│                        │ criado_em   │                   │
│                        └─────────────┘                   │
│                                                          │
│  ┌──────────────┐    ┌──────────────────┐               │
│  │RECONHECIMENTO│    │METODOS_PAGAMENTO │               │
│  ├──────────────┤    ├──────────────────┤               │
│  │ id (PK)      │    │ id (PK)          │               │
│  │ usuario_id   │    │ usuario_id       │               │
│  │ tipo         │    │ tipo             │               │
│  │ resultado    │    │ token_cartao     │               │
│  │ confianca    │    │ chave_pix        │               │
│  │ imagem_url   │    │ banco            │               │
│  │ criado_em    │    │ padrao           │               │
│  └──────────────┘    └──────────────────┘               │
│                                                          │
│  ┌──────────────┐    ┌──────────────────┐               │
│  │ITENS_TRANSACAO    │        LOGS      │               │
│  ├──────────────┤    ├──────────────────┤               │
│  │ id (PK)      │    │ id (PK)          │               │
│  │ transacao_id │    │ usuario_id       │               │
│  │ produto_id   │    │ tipo_acao        │               │
│  │ quantidade   │    │ descricao        │               │
│  │ preco_total  │    │ endereco_ip      │               │
│  └──────────────┘    │ criado_em        │               │
│                      └──────────────────┘               │
└─────────────────────────────────────────────────────────────┘
```

## Descrição Detalhada das Tabelas

### 1. **USUARIOS** (Cadastro de Usuários)
```sql
- Informações pessoais (nome, email, CPF, telefone)
- Endereço completo (rua, número, CEP, cidade, estado)
- Verificações de segurança (email, telefone, documento, rosto)
- Histórico de acesso (último login, data de criação)
```

### 2. **PRODUTOS** (Catálogo)
```sql
- Nome e descrição completa
- Preço normal e com desconto
- Gestão de estoque (quantidade, mínimo)
- Imagens (principal + adicionais em JSON)
- SKU e código de barras (únicos)
- Avaliações (rating médio, número de reviews)
- Categorização (categoria, subcategoria)
```

### 3. **CARRINHO** (Carrinho de Compras)
```sql
- Associação com usuário
- Lista de itens
- Rastreamento de abandono
```

### 4. **ITENS_CARRINHO** (Produtos no Carrinho)
```sql
- Link entre carrinho e produto
- Quantidade e preço unitário
- Cálculo automático do total
```

### 5. **TRANSACOES** (Pedidos/Transações)
```sql
- Número de pedido único
- Valores: subtotal, desconto, frete, taxa, total
- Status de pagamento e entrega
- Endereço de entrega
- Número de rastreamento
- Histórico completo de datas
- Motivo de cancelamento (se aplicável)
```

### 6. **ITENS_TRANSACAO** (Produtos da Transação)
```sql
- Registro de cada produto vendido
- Preço no momento da venda
- Quantidade comprada
```

### 7. **PAGAMENTO** (Detalhes do Pagamento)
```sql
- Uma transação = Um pagamento
- Valor pago vs. valor da transação
- Método: QR Code, PIX, Cartão, Dinheiro, Boleto
- QR Code/PIX: código e chave
- Cartão: últimos dígitos, bandeira (sem dados sensíveis)
- Gateway: ID da transação remota
- Tentativas de pagamento
- Data de confirmação
```

### 8. **RECONHECIMENTO** (Validação por IA)
```sql
- Tipos: rosto, QR code, documento, íris
- Resultado: pendente, sucesso, falha
- Confiança (0-1 ou 0-100%)
- URL das imagens (original + processada)
- Versão do modelo ML usado
- Tempo de processamento
- Detalhes extras em JSON
```

### 9. **METODOS_PAGAMENTO** (Métodos Salvos)
```sql
- Cartão: últimos 4 dígitos, bandeira, data (token encriptado)
- PIX: chave e tipo (CPF, email, telefone, aleatória)
- Conta bancária: banco, agência, conta, tipo
- Método padrão
```

### 10. **ENDERECOS_ENTREGA** (Endereços Salvos)
```sql
- Múltiplos endereços por usuário
- Apelido: "Casa", "Trabalho", etc.
- Endereço padrão
- Ativo/Inativo
```

### 11. **AVALIACOES** (Reviews de Produtos)
```sql
- Nota: 1-5 estrelas
- Título e texto da avaliação
- Aspectos: qualidade, precisão da descrição, tempo entrega
- Ligado a uma transação específica
```

### 12. **LOGS** (Auditoria)
```sql
- Todas as ações importantes: login, compra, cancelamento
- IP do usuário
- User Agent (navegador/app)
- Rastreamento completo
```

---

## Relacionamentos

| De | Para | Tipo | Descrição |
|-------|------|------|-----------|
| USUARIOS | TRANSACOES | 1:N | Um usuário tem muitas transações |
| USUARIOS | CARRINHO | 1:N | Um usuário tem múltiplos carrinhos |
| USUARIOS | RECONHECIMENTO | 1:N | Um usuário tem vários reconhecimentos |
| USUARIOS | METODOS_PAGAMENTO | 1:N | Um usuário tem vários métodos |
| USUARIOS | ENDERECOS_ENTREGA | 1:N | Um usuário tem vários endereços |
| CARRINHO | ITENS_CARRINHO | 1:N | Um carrinho tem múltiplos itens |
| ITENS_CARRINHO | PRODUTOS | N:1 | Muitos itens referem 1 produto |
| TRANSACAO | ITENS_TRANSACAO | 1:N | Uma transação tem múltiplos itens |
| ITENS_TRANSACAO | PRODUTOS | N:1 | Muitos itens referem 1 produto |
| TRANSACAO | PAGAMENTO | 1:1 | Cada transação tem 1 pagamento |
| USUARIOS | AVALIACOES | 1:N | Um usuário deixa muitas avaliações |
| PRODUTOS | AVALIACOES | 1:N | Um produto tem muitas avaliações |

---

## Índices de Performance

```sql
CREATE INDEX idx_usuario_email ON usuarios(email);
CREATE INDEX idx_usuario_cpf ON usuarios(cpf);
CREATE INDEX idx_usuario_criado ON usuarios(criado_em);
CREATE INDEX idx_transacao_usuario ON transacoes(usuario_id);
CREATE INDEX idx_transacao_numero ON transacoes(numero_pedido);
CREATE INDEX idx_transacao_criado ON transacoes(criado_em);
CREATE INDEX idx_pagamento_status ON pagamentos(status);
CREATE INDEX idx_pagamento_transacao ON pagamentos(transacao_id);
CREATE INDEX idx_reconhecimento_usuario ON reconhecimentos(usuario_id);
CREATE INDEX idx_reconhecimento_tipo ON reconhecimentos(tipo);
CREATE INDEX idx_log_usuario ON logs(usuario_id);
CREATE INDEX idx_log_criado ON logs(criado_em);
CREATE INDEX idx_produto_sku ON produtos(sku);
CREATE INDEX idx_produto_categoria ON produtos(categoria);
```

---

## Enums Disponíveis

### StatusPagamento
- `pendente` - Aguardando pagamento
- `processando` - Processando
- `concluido` - Pagamento confirmado
- `cancelado` - Cancelado pelo usuário
- `falhou` - Falha na tentativa

### TipoReconhecimento
- `rosto` - Reconhecimento facial
- `qrcode` - Leitura de QR Code
- `documento` - Verificação de documento
- `iris` - Reconhecimento de íris

### StatusTransacao
- `pendente` - Não processada
- `sucesso` - Completada com sucesso
- `falha` - Falha no processamento

---

## Capacidades do Banco

✅ **Segurança**: Campos para criptografia de dados sensíveis
✅ **Auditoria Completa**: Logs de todas as ações
✅ **Múltiplos Métodos**: Cartão, PIX, Dinheiro, QR Code
✅ **IA Integration**: Campos para reconhecimento facial/documento
✅ **E-commerce Completo**: Carrinho, produtos, avaliações
✅ **Rastreamento**: Histórico de entrega
✅ **Escalabilidade**: Índices otimizados
✅ **Relacionamentos**: Integridade referencial

