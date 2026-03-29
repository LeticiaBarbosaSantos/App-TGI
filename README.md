# StarFast App

## O que é
App de compras com backend de autenticação (FastAPI + SQLite) + frontend Flutter.

### Principais funcionalidades
- Cadastro com validação (nome, email único, CPF único, senha >= 6)
- Login com JWT (token 24h)
- Hash de senha com bcrypt
- Auditoria de tentativas (login/cadastro)
- Soft delete de contas

## Como usar
1. Backend:
   - `cd backend`
   - `python main.py`
2. Executar testes:
   - `python test_auth.py`
3. App:
   - `flutter run`

## Estrutura
- `backend/` - API Python FastAPI + banco SQLite
- `lib/` - app Flutter (login, cadastro, menu, pagamento)
- `pubspec.yaml`, `android/`, `ios/`, `web/`, `windows/`

## Documentação curta
Este README é a página única recomendada.
Se quiser ler detalhes, abra:
- `INDICE_DOCUMENTACAO.md`
- `INICIO_RAPIDO.md`
- `ARQUITETURA.md`
- `TESTE_RAPIDO.md`

## Teste rápido
```bash
cd backend
python test_auth.py
```

### Resultado esperado
- Cadastros repetidos falham
- Senha curta falha
- Login válido passa

## Dicas de versão minimalista
- Concentre o fluxo em ponto único: `README`.
- Outsider docs são apenas referência, não obrigatórios.
- Se precisar, adicione `RESUMO_ALTERACOES.md` com 5 linhas.

## Contato
- Não há deploy automático incluído.
- Rodar local + validar manual é suficiente.
