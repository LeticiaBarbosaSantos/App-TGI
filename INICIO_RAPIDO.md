# ⚡ GUIA DE INÍCIO RÁPIDO - VALIDAR AUTENTICAÇÃO

## Em 5 minutos você valida tudo!

### Passo 1️⃣: Abra 2 Terminais

```
Terminal 1: Você vai rodar o BACKEND aqui
Terminal 2: Você vai rodar o TESTE aqui
```

---

### Passo 2️⃣: Terminal 1 - INICIE O BACKEND

```bash
cd c:\projetos\tgi_1_app\backend
python main.py
```

**Você deve ver:**
```
INFO:     Uvicorn running on http://0.0.0.0:8000
```

✅ Deixe rodando! Não feche esse terminal.

---

### Passo 3️⃣: Terminal 2 - RODE O TESTE

```bash
cd c:\projetos\tgi_1_app\backend
pip install requests
python test_auth.py
```

**Espere alguns segundos...**

---

### Passo 4️⃣: VEJA O RESULTADO

Se tudo está correto, você verá:

```
════════════════════════════════════════════════════════════
  ✅ TESTE 1: CADASTRO VÁLIDO
════════════════════════════════════════════════════════════

ℹ️  Cadastrando usuário: teste@example.com
✅ Cadastro realizado! ID do usuário: 1

════════════════════════════════════════════════════════════
  ✅ TESTE 2: EMAIL DUPLICADO
════════════════════════════════════════════════════════════

✅ Email duplicado rejeitado corretamente!

... (mais 5 testes) ...

════════════════════════════════════════════════════════════
  ✨ TODOS OS TESTES PASSARAM! ✨
════════════════════════════════════════════════════════════

O sistema de autenticação está funcionando corretamente!
```

---

## ✅ Se Deu Certo!

🎉 **A validação de banco de dados está funcionando!**

Isso significa:
- ✅ Cadastro salva no banco de dados
- ✅ Login valida contra o banco
- ✅ Senhas são hasheadas
- ✅ Email e CPF são únicos
- ✅ Tudo funciona junto!

---

## ❌ Se Deu Erro...

### Erro: "Connection refused"
```
❌ Não conseguiu conectar à API
```

**Solução:** Certifique-se que:
1. O backend está rodando em outro terminal
2. Está em `http://localhost:8000`
3. Não há outro programa usando porta 8000

---

### Erro: "No module named 'requests'"
```
ModuleNotFoundError: No module named 'requests'
```

**Solução:** Instale o módulo:
```bash
pip install requests
```

---

### Erro: Banco de dados vazio
```
❌ Todos os testes falharam
```

**Solução:** Delete o banco antigo e reinicie:
```bash
cd backend
del smartpay.db      (Windows)
rm smartpay.db       (Mac/Linux)
python main.py
```

---

## 🧪 Teste Manual no App (Opcional)

Se quiser testar no Flutter app também:

```bash
# Terminal 3: Começando do diretório raiz
flutter run
```

Ou em outro diretório VS Code abrir e apertar F5.

**No app:**
1. Clique em "Não tem conta? Cadastre-se"
2. Preencha o cadastro
3. Clique "Cadastrar"
4. Volta para login
5. Preencha email + senha
6. Clique "Entrar"
7. Se funcionar, vai para /home ✅

---

## 📚 Quer Saber Mais?

Leia esses arquivos na ordem:

1. **`TESTE_RAPIDO.md`** - Mais detalhes de teste
2. **`VALIDACAO_AUTENTICACAO.md`** - Explicação completa
3. **`ARQUITETURA.md`** - Como funciona internamente
4. **`RESUMO_ALTERACOES.md`** - O que foi alterado
5. **`CHECKLIST_FINAL.md`** - Checklist completo

---

## 🔍 Verificar Banco de Dados (Curiosidade)

Se quiser ver os usuários cadastrados:

```bash
pip install sqlite3
cd backend
sqlite3 smartpay.db
```

Dentro do sqlite:
```sql
SELECT id, nome, email, cpf FROM usuarios;
SELECT usuario_id, tipo_acao, criado_em FROM logs;
.exit
```

---

## 🎯 Resumo Rápido

| O quê | Comando |
|------|---------|
| Iniciar Backend | `cd backend` → `python main.py` |
| Testar Automaticamente | `python test_auth.py` |
| Iniciar App | `flutter run` |
| Ver Banco Dados | `sqlite3 smartpay.db` |

---

**Dúvidas?** Consulte os arquivos `.md` na raiz do projeto!

**Status:** ✅ Pronto para validar em 5 minutos!
