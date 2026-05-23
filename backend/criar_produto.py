from database import SessionLocal, engine
from models import Produto, Base

# 1. ESSA É A LINHA MÁGICA: Cria as tabelas se elas não existirem
Base.metadata.create_all(bind=engine)

# 2. Abre a conexão com o banco
db = SessionLocal()

# 3. Cria o produto Rexona
rexona = Produto(nome="Rexona", preco=19.90, estoque=100)
db.add(rexona)
db.commit()
db.refresh(rexona) # Garante que o ID venha preenchido

print(f"✅ SUCESSO! O ID do Rexona é: {rexona.id}")
db.close()