# 📖 Exemplo Prático - Passo a Passo

> **Acompanhe este exemplo enquanto testa o sistema**

---

## 👤 Cenário: Novo Usuário - João Silva

### Dados do usuário:
```
Nome: João Silva
Email: joao@example.com
CPF: 12345678901
Telefone: 11 99999999
Senha: senha123456
```

---

## 1️⃣ CADASTRO

### 1.1 - Usuário preenche formulário no app

```
┌─────────────────────────────────┐
│ 📝 CADASTRO                     │
│─────────────────────────────────│
│ Nome: João Silva                │
│ Email: joao@example.com         │
│ CPF: 12345678901                │
│ Telefone: 11 99999999           │
│ Senha: senha123456 [👁️ ]      │
│ Confirmar: senha123456 [👁️ ]  │
│                                 │
│ [CADASTRAR]                     │
└─────────────────────────────────┘
```

### 1.2 - App faz requisição para API

```bash
POST http://localhost:8000/auth/registro
Content-Type: application/json

{
  "nome": "João Silva",
  "email": "joao@example.com",
  "cpf": "12345678901",
  "senha": "senha123456",
  "telefone": "11 99999999"
}
```

### 1.3 - Backend valida e processa

```python
# routes_auth.py - Função registrar_usuario()

1. Verifica se email já existe
   ✅ joao@example.com NÃO existe no banco
   
2. Verifica se CPF já existe
   ✅ 12345678901 NÃO existe no banco
   
3. Valida comprimento de senha
   ✅ senha123456 tem 12 caracteres (>= 6)
   
4. Hash da senha
   senha_plana: "senha123456"
   ↓ bcrypt.hashpw()
   senha_hash: "$2b$12$abcd1234efgh5678ijkl9012..."
   
5. Insere no banco de dados
   INSERT INTO usuarios (
     nome, email, cpf, senha_hash, telefone, criado_em, ativo
   ) VALUES (
     'João Silva',
     'joao@example.com',
     '12345678901',
     '$2b$12$abcd1234efgh5678ijkl9012...',
     '11 99999999',
     2026-02-27 15:30:45.123456,
     true
   )
   
   ↓ Gerado ID: 1
   
6. Registra log de cadastro
   INSERT INTO logs (
     usuario_id, tipo_acao, descricao, criado_em
   ) VALUES (
     1,
     'cadastro',
     'Novo usuário registrado',
     2026-02-27 15:30:45.543210
   )
```

### 1.4 - Backend retorna resposta 200 OK

```json
{
  "id": 1,
  "nome": "João Silva",
  "email": "joao@example.com",
  "cpf": "12345678901",
  "telefone": "11 99999999",
  "data_nascimento": null,
  "endereco": null,
  "numero_endereco": null,
  "cep": null,
  "cidade": null,
  "estado": null,
  "email_verificado": false,
  "rosto_verificado": false,
  "documento_verificado": false,
  "criado_em": "2026-02-27T15:30:45.123456"
}
```

### 1.5 - App mostra feedback

```
┌─────────────────────────────────┐
│                                 │
│ ✅ Cadastro realizado com      │
│    sucesso! Faça login.         │
│                                 │
│ [OK]                            │
└─────────────────────────────────┘

↓ App volta para tela de LOGIN
```

### ✅ ESTADO DO BANCO APÓS CADASTRO

```sql
-- TABELA: usuarios
┌────┬──────────────┬──────────────────┬───────────────┬──────────────────────────────┐
│ id │ nome         │ email            │ cpf           │ senha_hash                   │
├────┼──────────────┼──────────────────┼───────────────┼──────────────────────────────┤
│ 1  │ João Silva   │ joao@example.com │ 12345678901   │ $2b$12$abcd1234efgh5678... │
└────┴──────────────┴──────────────────┴───────────────┴──────────────────────────────┘

-- TABELA: logs
┌────┬────────────┬──────────┬──────────────────────────┐
│ id │ usuario_id │ acao     │ criado_em                │
├────┼────────────┼──────────┼──────────────────────────┤
│ 1  │ 1          │ cadastro │ 2026-02-27 15:30:45      │
└────┴────────────┴──────────┴──────────────────────────┘
```

---

## 2️⃣ LOGIN - PRIMEIRA TENTATIVA (CORRETA)

### 2.1 - Usuário preenche credenciais

```
┌─────────────────────────────────┐
│ 🔐 LOGIN                        │
│─────────────────────────────────│
│ Email: joao@example.com         │
│ Senha: senha123456 [👁️ ]      │
│                                 │
│ [Entrar]                        │
└─────────────────────────────────┘
```

### 2.2 - App faz requisição para API

```bash
POST http://localhost:8000/auth/login
Content-Type: application/json

{
  "email": "joao@example.com",
  "senha": "senha123456"
}
```

### 2.3 - Backend valida e processa

```python
# routes_auth.py - Função login_usuario()

1. Busca usuário por email
   SELECT * FROM usuarios 
   WHERE email = 'joao@example.com'
   ✅ Encontrado: usuario_id=1
   
   usuario = {
     id: 1,
     email: 'joao@example.com',
     senha_hash: '$2b$12$abcd1234efgh5678ijkl9012...',
     ativo: true,
     ...
   }
   
2. Verifica se está ativo
   ✅ usuario.ativo = true
   
3. Compara senha com bcrypt
   bcrypt.checkpw(
     "senha123456".encode(),
     "$2b$12$abcd1234efgh5678ijkl9012...".encode()
   )
   ✅ Senhas conferem!
   
4. Atualiza último login
   UPDATE usuarios 
   SET ultimo_login = '2026-02-27 15:35:22'
   WHERE id = 1
   
5. Gera token JWT
   payload = {
     "usuario_id": 1,
     "email": "joao@example.com",
     "exp": 1740758400  (24 horas depois)
   }
   
   token = jwt.encode(payload, SECRET_KEY, "HS256")
   token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
   
6. Registra log de sucesso
   INSERT INTO logs (
     usuario_id, tipo_acao, descricao, criado_em
   ) VALUES (
     1,
     'login',
     'Login realizado com sucesso',
     2026-02-27 15:35:22
   )
```

### 2.4 - Backend retorna 200 OK + TOKEN

```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c3VhcmlvX2lkIjoxLCJlbWFpbCI6ImpvYW9AZXhhbXBsZS5jb20iLCJleHAiOjE3NDA3NTg0MDB9.NtzgQr2F4hfxAb9z8K0L1M2N3O4P5Q6R7S8T9U0V1W2X3Y4Z5",
  "token_type": "bearer",
  "usuario_id": 1,
  "nome": "João Silva",
  "email": "joao@example.com"
}
```

### 2.5 - App recebe token e navega

```
✅ Login realizado com sucesso!

[App navega para /home]
[App passa usuario_id = 1 como argumento]

Tela HOME carregada ✅
Usuário autenticado!
```

### ✅ ESTADO DO BANCO APÓS LOGIN

```sql
-- TABELA: usuarios
┌────┬──────────────┬──────────────────┬───────────────┬──────────────┐
│ id │ email        │ ultimo_login     │ ativo         │ ...          │
├────┼──────────────┼──────────────────┼───────────────┼──────────────┤
│ 1  │ joao@exa...  │ 2026-02-27 15:35 │ true          │ ...          │
└────┴──────────────┴──────────────────┴───────────────┴──────────────┘

-- TABELA: logs
┌────┬────────────┬──────────┬───────────────────┐
│ id │ usuario_id │ acao     │ criado_em         │
├────┼────────────┼──────────┼───────────────────┤
│ 1  │ 1          │ cadastro │ 2026-02-27 15:30  │
│ 2  │ 1          │ login    │ 2026-02-27 15:35  │ ← LOGIN SUCESSO
└────┴────────────┴──────────┴───────────────────┘
```

---

## 3️⃣ LOGIN - TENTATIVA ERRADA (SENHA INCORRETA)

### 3.1 - Usuário digita senha errada

```
┌─────────────────────────────────┐
│ 🔐 LOGIN                        │
│─────────────────────────────────│
│ Email: joao@example.com         │
│ Senha: senhaErrada [👁️]        │
│                                 │
│ [Entrar]                        │
└─────────────────────────────────┘
```

### 3.2 - App faz requisição

```bash
POST http://localhost:8000/auth/login
Content-Type: application/json

{
  "email": "joao@example.com",
  "senha": "senhaErrada"
}
```

### 3.3 - Backend valida

```python
# routes_auth.py - Função login_usuario()

1. Busca usuário por email
   ✅ Encontrado: usuario_id=1
   
2. Verifica se está ativo
   ✅ usuario.ativo = true
   
3. Compara senha com bcrypt
   bcrypt.checkpw(
     "senhaErrada".encode(),
     "$2b$12$abcd1234efgh5678ijkl9012...".encode()
   )
   ❌ Senhas NÃO conferem!
   
4. Registra log de FALHA
   INSERT INTO logs (
     usuario_id, tipo_acao, descricao, criado_em
   ) VALUES (
     1,
     'login_falhou',
     'Senha incorreta',
     2026-02-27 15:40:10
   )
```

### 3.4 - Backend retorna 401 UNAUTHORIZED

```json
{
  "detail": "Email ou senha incorretos"
}
```

### 3.5 - App mostra erro

```
┌─────────────────────────────────┐
│                                 │
│ ❌ Erro: Email ou senha         │
│    incorretos                   │
│                                 │
│ [OK]                            │
└─────────────────────────────────┘

Fica na tela de LOGIN (não avança)
```

### ❌ ESTADO DO BANCO APÓS ERRO

```sql
-- TABELA: logs
┌────┬────────────┬─────────────────┬──────────────────┐
│ id │ usuario_id │ acao            │ criado_em        │
├────┼────────────┼─────────────────┼──────────────────┤
│ 1  │ 1          │ cadastro        │ 2026-02-27 15:30 │
│ 2  │ 1          │ login           │ 2026-02-27 15:35 │
│ 3  │ 1          │ login_falhou    │ 2026-02-27 15:40 │ ← TENTATIVA FALHOU
└────┴────────────┴─────────────────┴──────────────────┘
```

---

## 4️⃣ LOGIN - EMAIL NÃO CADASTRADO

### 4.1 - Usuário digita email que não existe

```
┌─────────────────────────────────┐
│ 🔐 LOGIN                        │
│─────────────────────────────────│
│ Email: maria@example.com        │ ← NÃO CADASTRADA
│ Senha: qualquerSenha [👁️]      │
│                                 │
│ [Entrar]                        │
└─────────────────────────────────┘
```

### 4.2 - Backend valida

```python
1. Busca usuário por email
   SELECT * FROM usuarios 
   WHERE email = 'maria@example.com'
   ❌ Não encontrado!
   
2. Registra log de FALHA
   INSERT INTO logs (
     usuario_id, tipo_acao, descricao, criado_em
   ) VALUES (
     NULL,  ← Sem usuario_id (email não existe)
     'login_falhou',
     'Email não encontrado: maria@example.com',
     2026-02-27 15:45:30
   )
```

### 4.3 - Backend retorna 401

```json
{
  "detail": "Email ou senha incorretos"
}
```

**Nota:** Mesma mensagem de erro que senha incorreta! Isso é por segurança (não revela quem está cadastrado).

---

## 📊 Resumo Visual

```
┌─────────────────────────────────────────────────────────────┐
│                      FLUXO COMPLETO                         │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│ 1️⃣  CADASTRO                                                │
│     ├─ Preenche formulário                                 │
│     ├─ Envia para /auth/registro                           │
│     ├─ Backend valida: email único ✅ CPF único ✅         │
│     ├─ Hash da senha: senha123456 → $2b$12$abc...        │
│     ├─ Insere no banco de dados                            │
│     ├─ Registra log: usuario_id=1, acao=cadastro          │
│     └─ Status: 200 OK ✅                                    │
│                                                              │
│ 2️⃣  LOGIN - SUCESSO                                        │
│     ├─ Preenche email + senha                              │
│     ├─ Envia para /auth/login                              │
│     ├─ Backend busca usuário: encontrado ✅                │
│     ├─ Verifica ativo: true ✅                              │
│     ├─ Compara senha: bcrypt.verify() ✅                   │
│     ├─ Atualiza ultimo_login                               │
│     ├─ Gera JWT token (24h)                                │
│     ├─ Registra log: acao=login                            │
│     ├─ Status: 200 OK + token ✅                            │
│     └─ App navega para /home                               │
│                                                              │
│ 3️⃣  LOGIN - ERRO (SENHA ERRADA)                            │
│     ├─ Preenche email + senha ERRADA                       │
│     ├─ Envia para /auth/login                              │
│     ├─ Backend busca usuário: encontrado ✅                │
│     ├─ Verifica ativo: true ✅                              │
│     ├─ Compara senha: bcrypt.verify() ❌                   │
│     ├─ Registra log: acao=login_falhou                     │
│     ├─ Status: 401 UNAUTHORIZED ❌                          │
│     └─ App mostra erro, fica no login                      │
│                                                              │
│ 4️⃣  LOGIN - ERRO (EMAIL NÃO EXISTE)                        │
│     ├─ Preenche email que não foi cadastrado              │
│     ├─ Envia para /auth/login                              │
│     ├─ Backend busca usuário: não encontrado ❌            │
│     ├─ Registra log: usuario_id=NULL, acao=login_falhou   │
│     ├─ Status: 401 UNAUTHORIZED ❌                          │
│     └─ App mostra erro, fica no login                      │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔐 Dados Sensíveis - Como são Protegidos

```
┌──────────────────────────────────────────────────────────────┐
│ O que o usuário vê no app:                                   │
│                                                               │
│ senha: ••••••••••• (nunca mostra a senha real)               │
│                                                               │
└──────────────────────────────────────────────────────────────┘
                            ↓
┌──────────────────────────────────────────────────────────────┐
│ O que é enviado na rede HTTP para API:                       │
│                                                               │
│ "senha": "senha123456"  ← TEXTO PLANO (mas em HTTPS)         │
│                                                               │
│ ⚠️  Por isso use HTTPS em produção (não HTTP)!               │
│                                                               │
└──────────────────────────────────────────────────────────────┘
                            ↓
┌──────────────────────────────────────────────────────────────┐
│ O que é armazenado no banco de dados:                        │
│                                                               │
│ senha_hash: "$2b$12$abcd1234efgh5678ijkl9012mno34pqr"      │
│                            ↑                                  │
│                    HASH BCRYPT (irreversível!)              │
│                                                               │
│ ✅ Impossível recuperar a senha original                    │
│ ✅ Cada vez que hash, resultado é diferente (salt)         │
│ ✅ Mesmo que banco vaze, senhas estão seguras              │
│                                                               │
└──────────────────────────────────────────────────────────────┘
```

---

## ✅ Validação Final

Depois de seguir este exemplo:

- [x] Usuário cadastrado no banco
- [x] Email é único (teste duplicar)
- [x] Password hasheada com bcrypt
- [x] Login funciona com credenciais corretas
- [x] Login falha com senha incorreta
- [x] Login falha com email inexistente
- [x] Logs registram cada tentativa
- [x] Token JWT gerado com 24h de validade

**Status:** ✅ SUA AUTENTICAÇÃO FUNCIONA COMPLETAMENTE!

---

*Exemplo prático criado em: 27 de fevereiro de 2026*
