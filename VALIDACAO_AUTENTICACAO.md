# ✅ Validação de Autenticação - Login e Cadastro com Banco de Dados

## Estado Atual

O sistema foi atualizado para validar **tanto login quanto cadastro** através do banco de dados SQLite com as seguintes melhorias:

### ✅ Frontend (Flutter)

#### **login.dart**
- ✅ Agora usa `ApiService.loginUsuario()` em vez de validação local
- ✅ Valida credenciais contra o banco de dados
- ✅ Mostra estado de carregamento enquanto processa
- ✅ Toggle para mostrar/ocultar senha
- ✅ Mensagens de erro claras

#### **cadastro.dart**
- ✅ Usa `ApiService.registrarUsuario()` para criar conta
- ✅ Validação em tempo real de email, CPF e senha
- ✅ Confirma segunda quando de senha
- ✅ Mostra erros se email ou CPF já estão cadastrados

### ✅ Backend (Python/FastAPI)

#### **routes_auth.py**
- ✅ POST `/auth/registro` - Cria novo usuário com validações:
  - Email único (verifica se não existe)
  - CPF único (verifica se não existe)
  - Senha com mínimo 6 caracteres
  - Hash seguro com bcrypt
  
- ✅ POST `/auth/login` - Faz login com validações:
  - Busca usuário por email
  - Verifica se usuário está ativo
  - Compara senha com hash armazenado (bcrypt)
  - Atualiza `ultimo_login`
  - Retorna token JWT válido por 24 horas
  - Registra log de tentativa (sucesso ou falha)

#### **models.py**
- ✅ Modelo `Usuario` com campos completos:
  - `email` - Unique, index
  - `cpf` - Unique, index
  - `senha_hash` - O que é armazenado (nunca senha em texto plano)
  - `ativo` - Para desativar conta sem deletar
  - `ultimo_login` - Rastreamento
  - `criado_em` - Auditoria

- ✅ Modelo `Log` para rastreamento:
  - Registra login bem-sucedido
  - Registra tentativas falhadas
  - Rastreia IP e user agent

#### **database.py**
- ✅ SQLite configurado para desenvolvimento local
- ✅ Tabelas criadas automaticamente on startup
- ✅ Session manager com segurança

## Fluxo Completo

### 1️⃣ CADASTRO
```
User → Flutter App
              ↓
         Preenche formulário
         (nome, email, cpf, telefone, senha)
              ↓
         Clica "Cadastrar"
              ↓
         POST /auth/registro
              ↓
         Backend valida:
         - Email já existe? ❌ Erro
         - CPF já existe? ❌ Erro
         - Senha < 6 chars? ❌ Erro
         - Tudo OK? ✅ Continua
              ↓
         Hash da senha com bcrypt
              ↓
         Inserir no banco: usuarios
              ↓
         Registrar no log: "cadastro"
              ↓
         Retorna 200 + dados do usuário
              ↓
         App mostra mensagem de sucesso
              ↓
         Volta para tela de LOGIN
```

### 2️⃣ LOGIN
```
User → Flutter App
              ↓
         Preenche email + senha
              ↓
         Clica "Entrar"
              ↓
         POST /auth/login
              ↓
         Backend valida:
         - Email existe? ❌ Erro 401
         - Usuário está ativo? ❌ Erro 403
         - Senha correta (bcrypt)? ❌ Erro 401
         - Tudo OK? ✅ Continua
              ↓
         Atualiza: ultimo_login = agora
              ↓
         Gera token JWT (validade 24h)
              ↓
         Registra no log: "login"
              ↓
         Retorna 200 + token + usuario_id
              ↓
         App navega para /home
              ↓
         Autenticado! ✅
```

## 🔒 Segurança Implementada

✅ **Passwords não são armazenadas em texto plano**
- Usamos bcrypt com salt automático
- Hash é irreversível

✅ **Email e CPF são únicos**
- Validação de unicidade no banco
- Index para performance

✅ **JWT Token**
- Válido por 24 horas
- Contém usuario_id e email
- Usa SECRET_KEY segura (mude em produção!)

✅ **Rastreamento com Log**
- Cada tentativa de login (sucesso ou falha) é registrada
- IP do cliente pode ser capturado
- Utíl para auditoria

✅ **Soft Delete**
- Usuários podem ser desativados sem deletar histórico
- Campo `ativo` marca se conta está ativa

## 📋 Como Testar

### Opção 1: Teste Manual no App

1. **Inicie o backend:**
   ```bash
   cd backend
   python main.py
   ```
   Ou se preferir com uvicorn:
   ```bash
   pip install uvicorn
   uvicorn main:app --reload
   ```

2. **Inicie o app Flutter:**
   ```bash
   flutter run
   ```

3. **Teste o cadastro:**
   - Clique em "Não tem conta? Cadastre-se"
   - Preencha:
     - Nome: João Silva
     - Email: joao@example.com
     - CPF: 12345678901
     - Telefone: 11999999999
     - Senha: 123456
   - Clique "Cadastrar"
   - Aguarde mensagem de sucesso

4. **Teste o login:**
   - Você está de volta na tela de LOGIN
   - Preencha:
     - Email: joao@example.com
     - Senha: 123456
   - Clique "Entrar"
   - Se credenciais corretas → vai para /home
   - Se erradas → mostra erro

5. **Teste senha incorreta:**
   - Use o mesmo email mas senha diferente
   - Deve mostrar "Email ou senha incorretos"

6. **Teste email não cadastrado:**
   - Use um email que não foi cadastrado
   - Deve mostrar "Email ou senha incorretos"

### Opção 2: Teste via API direto (curl/Postman)

**Cadastro:**
```bash
curl -X POST "http://localhost:8000/auth/registro" \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "Maria Silva",
    "email": "maria@example.com",
    "cpf": "98765432101",
    "senha": "senha123",
    "telefone": "11988888888"
  }'
```

**Login com credenciais corretas:**
```bash
curl -X POST "http://localhost:8000/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "maria@example.com",
    "senha": "senha123"
  }'
```

Resposta esperada:
```json
{
  "access_token": "eyJhbGc...",
  "token_type": "bearer",
  "usuario_id": 1,
  "nome": "Maria Silva",
  "email": "maria@example.com"
}
```

**Login com senha incorreta:**
```bash
curl -X POST "http://localhost:8000/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "maria@example.com",
    "senha": "senhaErrada"
  }'
```

Resposta esperada:
```json
{
  "detail": "Email ou senha incorretos"
}
```

## 📊 Checklist de Validação

- [ ] Backend iniciando sem erros
- [ ] POST `/auth/registro` cria novo usuário
- [ ] POST `/auth/registro` rejeita email duplicado
- [ ] POST `/auth/registro` rejeita CPF duplicado
- [ ] POST `/auth/registro` rejeita senha < 6 chars
- [ ] POST `/auth/login` aceita credenciais corretas
- [ ] POST `/auth/login` retorna token JWT
- [ ] POST `/auth/login` rejeita email não cadastrado
- [ ] POST `/auth/login` rejeita senha incorreta
- [ ] Flutter app valida campos antes de enviar
- [ ] Flutter app mostra erros da API
- [ ] Flutter app navega para /home após login
- [ ] Database.db criado com tabelas corretas

## 📝 Variáveis de Ambiente (Opcional)

Crie um arquivo `.env` na pasta `backend/`:

```env
SECRET_KEY=sua-chave-super-secreta-aqui-mudar-em-producao
DATABASE_URL=sqlite:///./smartpay.db
```

## 🚀 Próximos Passos

Depois de validar que login + cadastro funcionam:

1. **Persistência de sessão** - Considerar usar SharedPreferences para manter usuário logado
2. **Refresh token** - Implementar rotação de tokens para segurança
3. **2FA** - Autenticação de dois fatores
4. **Recuperação de senha** - Fluxo para resetar senha
5. **Email de confirmação** - Validar posse do email

---

**Status:** ✅ Sistema pronto para testes
**Data de atualização:** 27 de fevereiro de 2026
