# ✅ AUTENTICAÇÃO COMPLETA - LOGIN E CADASTRO

## Fluxo da Autenticação

```
┌─────────────────────────────────────────────────────────┐
│                    SMARTPAY APP (Flutter)                │
├─────────────────────────────────────────────────────────┤
│                                                           │
│  1. Usuário abre o app                                   │
│     ↓                                                     │
│  2. Vê a tela de LOGIN                                   │
│     ├─ Opção 1: Email + Senha                           │
│     ├─ Opção 2: QR Code                                 │
│     └─ Opção 3: Reconhecimento Facial                   │
│     ↓                                                     │
│  3. Se novo → Clica "Cadastre-se"                       │
│     │                                                     │
│     └→ TELA DE CADASTRO                                 │
│        ├─ Nome Completo                                 │
│        ├─ Email                                         │
│        ├─ CPF                                           │
│        ├─ Telefone                                      │
│        ├─ Senha (mínimo 6 caracteres)                   │
│        ├─ Confirmar Senha                               │
│        └─ Validação em tempo real                       │
│                                                           │
└─────────────────────────────────────────────────────────┘
                         ↓↓↓
┌─────────────────────────────────────────────────────────┐
│              BACKEND (Python + FastAPI)                  │
├─────────────────────────────────────────────────────────┤
│                                                           │
│  POST /auth/registro                                     │
│  ├─ Valida: email único, CPF único                      │
│  ├─ Hash da senha com bcrypt                            │
│  ├─ Insere no banco: tabela USUARIOS                    │
│  ├─ Registra no LOG                                     │
│  └─ Retorna: dados do usuário criado                    │
│                                                           │
│  POST /auth/login                                        │
│  ├─ Busca usuário por email                             │
│  ├─ Verifica se está ativo                              │
│  ├─ Verifica senha com bcrypt                           │
│  ├─ Atualiza: ultimo_login                              │
│  ├─ Gera: Token JWT válido por 24 horas                │
│  ├─ Registra: log de login                              │
│  └─ Retorna: Token + dados do usuário                   │
│                                                           │
└─────────────────────────────────────────────────────────┘
                         ↓↓↓
┌─────────────────────────────────────────────────────────┐
│           BANCO DE DADOS (PostgreSQL)                    │
├─────────────────────────────────────────────────────────┤
│                                                           │
│  USUARIOS                                                │
│  ├─ id (PK)                                              │
│  ├─ nome                                                 │
│  ├─ email (UNIQUE)                                       │
│  ├─ cpf (UNIQUE)                                         │
│  ├─ telefone                                             │
│  ├─ senha_hash (bcrypt)                                 │
│  ├─ data_nascimento                                      │
│  ├─ email_verificado (Boolean)                          │
│  ├─ rosto_verificado (Boolean)                          │
│  ├─ documento_verificado (Boolean)                      │
│  ├─ ultimo_login (DateTime)                             │
│  ├─ criado_em (DateTime)                                │
│  └─ ativo (Boolean)                                      │
│                                                           │
│  LOGS                                                     │
│  ├─ id (PK)                                              │
│  ├─ usuario_id (FK)                                      │
│  ├─ tipo_acao (cadastro, login, login_falhou)           │
│  ├─ descricao                                            │
│  ├─ endereco_ip                                          │
│  └─ criado_em (DateTime)                                │
│                                                           │
└─────────────────────────────────────────────────────────┘
```

---

## Telas Implementadas

### 1️⃣ LOGIN SCREEN (`lib/login.dart`)

**Funcionalidades:**
- ✅ Input de Email
- ✅ Input de Senha (com toggle de visibilidade)
- ✅ Botão "Entrar"
- ✅ Botão "Entrar com QR Code"
- ✅ Botão "Entrar com Rosto"
- ✅ Link "Esqueceu a senha?"
- ✅ Link para Cadastro
- ✅ Indicador de carregamento
- ✅ Validação de campos

**O que faz:**
```dart
// Usuario clica "Entrar"
→ Valida se email e senha estão preenchidos
→ Faz requisição: POST /auth/login
→ Backend verifica credenciais
→ Gera Token JWT
→ Volta para o app com os dados
→ Navega para /home
→ Salva token localmente (usar shared_preferences)
```

---

### 2️⃣ CADASTRO SCREEN (`lib/cadastro.dart`)

**Funcionalidades:**
- ✅ Validação de Nome (obrigatório)
- ✅ Validação de Email (único, válido)
- ✅ Validação de CPF (11 dígitos, único)
- ✅ Campo de Telefone (opcional)
- ✅ Validação de Senha (mínimo 6 caracteres)
- ✅ Confirmação de Senha (deve corresponder)
- ✅ Visibilidade da senha (toggle)
- ✅ Indicador de carregamento
- ✅ Feedback de erro

**O que faz:**
```dart
// Usuario preenche e clica "Cadastrar"
→ Valida todos os campos (client-side)
→ Verifica se senhas correspondem
→ Faz requisição: POST /auth/registro
→ Backend valida:
   - Email único
   - CPF único
   - Senha > 6 caracteres
→ Hash da senha
→ Insere no banco
→ Mostra mensagem de sucesso
→ Volta para login
```

---

## Rotas Backend

### **POST /auth/registro**
Registrar novo usuário

**Request:**
```json
{
  "nome": "João Silva",
  "email": "joao@example.com",
  "cpf": "12345678901",
  "senha": "senha123",
  "telefone": "11987654321",
  "data_nascimento": "1995-05-15"
}
```

**Response (200):**
```json
{
  "id": 1,
  "nome": "João Silva",
  "email": "joao@example.com",
  "cpf": "12345678901",
  "telefone": "11987654321",
  "data_nascimento": "1995-05-15",
  "email_verificado": false,
  "rosto_verificado": false,
  "documento_verificado": false,
  "criado_em": "2026-02-04T10:30:00"
}
```

**Erros:**
- 400: Email já cadastrado
- 400: CPF já cadastrado
- 400: Senha < 6 caracteres

---

### **POST /auth/login**
Fazer login

**Request:**
```json
{
  "email": "joao@example.com",
  "senha": "senha123"
}
```

**Response (200):**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer",
  "usuario_id": 1,
  "nome": "João Silva",
  "email": "joao@example.com"
}
```

**Erros:**
- 401: Email ou senha incorretos
- 403: Usuário desativado

---

### **GET /auth/perfil/{usuario_id}**
Obter dados do usuário

**Response (200):**
```json
{
  "id": 1,
  "nome": "João Silva",
  "email": "joao@example.com",
  "telefone": "11987654321",
  "endereco": "Rua A, 123",
  "cidade": "São Paulo",
  "estado": "SP",
  "email_verificado": true,
  "rosto_verificado": true,
  "documento_verificado": true,
  "criado_em": "2026-02-04T10:30:00"
}
```

---

### **PUT /auth/perfil/{usuario_id}**
Atualizar perfil

**Request:**
```json
{
  "nome": "João da Silva",
  "telefone": "11987654321",
  "endereco": "Rua B, 456",
  "numero_endereco": "456",
  "cep": "01234567",
  "cidade": "São Paulo",
  "estado": "SP"
}
```

---

### **POST /auth/verificar-rosto/{usuario_id}**
Marcar rosto como verificado (após reconhecimento bem-sucedido)

**Response (200):**
```json
{
  "mensagem": "Rosto verificado com sucesso"
}
```

---

### **POST /auth/verificar-documento/{usuario_id}**
Marcar documento como verificado

**Response (200):**
```json
{
  "mensagem": "Documento verificado com sucesso"
}
```

---

### **POST /auth/alterar-senha/{usuario_id}**
Alterar senha

**Request:**
```json
{
  "senha_atual": "senha123",
  "senha_nova": "novaSenha456"
}
```

---

### **DELETE /auth/desativar-conta/{usuario_id}**
Desativar conta (soft delete)

**Response (200):**
```json
{
  "mensagem": "Conta desativada com sucesso"
}
```

---

## Segurança Implementada

### 🔐 **Hash de Senha (bcrypt)**
```python
# Ao registrar
senha_hash = bcrypt.hashpw(senha.encode(), bcrypt.gensalt())

# Ao fazer login
bcrypt.checkpw(senha_plana.encode(), senha_hash)
```

### 🔐 **Token JWT**
```python
# Gerado no login, válido por 24 horas
payload = {
    "usuario_id": 1,
    "email": "joao@example.com",
    "exp": datetime.utcnow() + timedelta(hours=24)
}
token = jwt.encode(payload, SECRET_KEY, algorithm="HS256")
```

### 🔐 **Validações**
- Email único e válido
- CPF único
- Senha mínimo 6 caracteres
- Usuário ativo
- Email verificado (opcional)
- Rosto verificado (opcional)

### 🔐 **Auditoria**
Todas as ações são registradas em LOGS:
- cadastro
- login
- login_falhou
- email_verificado
- rosto_verificado
- documento_verificado
- senha_alterada
- conta_desativada

---

## Como Integrar ao App

### 1. Instalar dependências
```bash
cd backend
pip install -r requirements.txt
```

### 2. Criar arquivo `.env`
```
DATABASE_URL=postgresql://usuario:senha@localhost:5432/smartpay
SECRET_KEY=sua-chave-super-secreta-aqui
API_HOST=0.0.0.0
API_PORT=8000
```

### 3. Subir banco e API
```bash
docker-compose up -d
```

### 4. API estará em
```
http://localhost:8000
http://localhost:8000/docs  # Swagger UI para testar
```

### 5. No Flutter
Atualizar `baseUrl` em `lib/services/api_service.dart`:
```dart
static const String baseUrl = "http://localhost:8000";  // Local
// static const String baseUrl = "https://api.seu-servidor.com";  // Produção
```

---

## Próximos Passos

1. ✅ **Autenticação Básica** - IMPLEMENTADO
2. ⏳ **Token Refresh** - Renovar tokens expirados
3. ⏳ **Dois Fatores** - 2FA com código por email/SMS
4. ⏳ **Recuperação de Senha** - Reset via email
5. ⏳ **Social Login** - Google, Facebook
6. ⏳ **Integração de Reconhecimento Facial** - Validar cadastro
7. ⏳ **Integração de Reconhecimento de Documento** - Validação de CPF

---

## Resumo

✅ **Funciona com o banco?** **SIM!**

O banco de dados está totalmente integrado:
- Tabela `USUARIOS` armazena dados e senha_hash
- Tabela `LOGS` rastreia toda atividade
- Campos de verificação (email, rosto, documento)
- Histórico de login
- Relacionamentos com transações, carrinhos, etc

A autenticação é segura:
- Senhas em bcrypt (não são armazenadas em texto)
- Tokens JWT para manter sessão
- Validação completa de dados
- Auditoria de todas as ações

