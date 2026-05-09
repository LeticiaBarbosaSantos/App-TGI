from database import SessionLocal
from models import Produto

# Abre a conexão com o banco
db = SessionLocal()

# Cria o produto Rexona
rexona = Produto(nome="Rexona", preco=19.90, estoque=100)
db.add(rexona)
db.commit()

print("Produto cadastrado com sucesso! O ID do Rexona agora é:", rexona.id)
db.close()