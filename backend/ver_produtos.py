from database import SessionLocal
from models import Produto

# Abre a conexão
db = SessionLocal()

# Puxa todos os produtos cadastrados
produtos = db.query(Produto).all()

print("--- LISTA DE PRODUTOS NO BANCO ---")
for p in produtos:
    print(f"ID: {p.id} | Nome: {p.nome} | Preço: R${p.preco}")

db.close()