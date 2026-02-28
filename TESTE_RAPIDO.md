# 🚀 Guia Rápido - Teste de Autenticação

## 1️⃣ Iniciar o Backend

```bash
cd backend
pip install -r requirements.txt
python main.py
```

Ou com uvicorn:
```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

Você deve ver algo como:
```
INFO:     Uvicorn running on http://0.0.0.0:8000
```

## 2️⃣ Testar via Script Python (Automático) ⚡

Em outro terminal:
```bash
cd backend
pip install requests
python test_auth.py
```

Isso vai executar **7 testes automaticamente** verificando:
- ✅ Cadastro válido
- ✅ Rejeição de email duplicado
- ✅ Rejeição de CPF duplicado  
- ✅ Rejeição de senha curta
- ✅ Login com credenciais corretas
- ✅ Rejeição de senha incorreta
- ✅ Rejeição de email inexistente

## 3️⃣ Testar via API (Manual) 📝

### A) Cadastro
```bash
curl -X POST "http://localhost:8000/auth/registro" \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "João Silva",
    "email": "joao@example.com",
    "cpf": "12345678901",
    "senha": "senha123",
    "telefone": "11999999999"
  }'
```

Resposta esperada:
```json
{
  "id": 1,
  "nome": "João Silva",
  "email": "joao@example.com",
  "cpf": "12345678901",
  "telefone": "11999999999",
  ...
}
```

### B) Login
```bash
curl -X POST "http://localhost:8000/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "joao@example.com",
    "senha": "senha123"
  }'
```

Resposta esperada:
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer",
  "usuario_id": 1,
  "nome": "João Silva",
  "email": "joao@example.com"
}
```

### C) Login com Senha Errada
```bash
curl -X POST "http://localhost:8000/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "joao@example.com",
    "senha": "senhaErrada"
  }'
```

Resposta esperada (erro):
```json
{
  "detail": "Email ou senha incorretos"
}
```

## 4️⃣ Testar no Flutter App 📱

1. **Inicie o backend** (confira que está rodando em http://localhost:8000)

2. **Abra o app Flutter:**
```bash
flutter run
```

3. **Teste o cadastro:**
   - Clique em "Não tem conta? Cadastre-se"
   - Preencha o formulário
   - Clique "Cadastrar"
   - Aguarde mensagem de sucesso
   - Você volta automaticamente para login

4. **Teste o login:**
   - Preencha email e senha cadastrados
   - Clique "Entrar"
   - Se correto → vai para /home
   - Se errado → mostra mensagem de erro

## ✅ Checklist de Validação

Depois de rodar os testes, verifique:

- [ ] Backend iniciou sem erros
- [ ] Banco de dados `smartpay.db` foi criado
- [ ] POST `/auth/registro` retorna 200 + dados do usuário
- [ ] POST `/auth/registro` retorna 400 para email duplicado
- [ ] POST `/auth/registro` retorna 400 para CPF duplicado
- [ ] POST `/auth/registro` retorna 400 para senha < 6 chars
- [ ] POST `/auth/login` retorna 200 + token JWT
- [ ] POST `/auth/login` retorna 401 para senha incorreta
- [ ] POST `/auth/login` retorna 401 para email inexistente
- [ ] Flutter app mostra erro se senha/email estão vazios
- [ ] Flutter app valida pelo menos 6 caracteres de senha
- [ ] Flutter consegue se registrar via app
- [ ] Flutter consegue fazer login após cadastro

## 🔍 Verificar Banco de Dados

Você pode inspecionar o banco de dados SQLite criado:

```bash
# Instalar sqlite3 se não tiver
pip install sqlite3

# Abrir o banco
sqlite3 smartpay.db

# Ver tabelas
.tables

# Ver usuários cadastrados
SELECT id, nome, email, cpf, ativo, criado_em FROM usuarios;

# Ver logs de autenticação
SELECT usuario_id, tipo_acao, descricao, criado_em FROM logs ORDER BY criado_em DESC LIMIT 10;
```

## 🔧 Troubleshooting

**Erro: "Connection refused" ao testar API**
- Verifique se backend está rodando em `http://localhost:8000`
- Verifique CORS - está configurado para "*"

**Erro: "Email já cadastrado"**
- Normal! Significa que você já cadastrou esse email antes
- Use um email diferente no próximo teste

**Erro: "No module named 'bcrypt'"**
```bash
pip install bcrypt
```

**Erro: "No module named 'jwt'"**
```bash
pip install PyJWT
```

**Banco de dados vazio**
- Delete o arquivo `smartpay.db` se existe
- Reinicie o backend - ele vai criar novo banco

## 📊 Estrutura de Resposta

### Token JWT decodificado:
```python
# O token contém:
{
  "usuario_id": 1,
  "email": "joao@example.com",
  "exp": 1740672000  # Válido por 24 horas
}
```

### Erro Padrão:
```json
{
  "detail": "Mensagem de erro descritiva"
}
```

## 📚 Referências

- Documentação Interativa: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc
- Código Backend: `backend/routes_auth.py`
- Código Frontend: `lib/login.dart` e `lib/cadastro.dart`

---

**Status:** ✅ Sistema pronto para testes completos
