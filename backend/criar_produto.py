from database import SessionLocal, engine
from models import Produto, Base

# 1. ESSA É A LINHA MÁGICA: Cria as tabelas se elas não existirem
#Base.metadata.create_all(bind=engine)

# 2. Abre a conexão com o banco
#db = SessionLocal()

# 3. Cria o produto Rexona
#rexona = Produto(nome="Rexona", preco=19.90, estoque=100)
#db.add(rexona)
#db.commit()
# db.refresh(rexona) # Garante que o ID venha preenchido

#print(f"✅ SUCESSO! O ID do Rexona é: {rexona.id}")
#db.close()

#---------------------------------------------------------------------------------------
# 1. Garante que as tabelas existem
Base.metadata.create_all(bind=engine)

# 2. Abre a conexão com o banco
db = SessionLocal()

# 3. Verifica se o Tenys Pé já existe para não duplicar
tenys = db.query(Produto).filter(Produto.nome == "Tenys Pé").first()

if not tenys:
    print("Criando o Tenys Pé no banco de dados...")
    tenys = Produto(nome="Tenys Pé", preco=14.90, estoque=100) # Coloquei um preço fictício, pode alterar se quiser!
    db.add(tenys)
    db.commit()
    db.refresh(tenys)
else:
    print("Tenys Pé já estava no banco!")

print("-" * 30)
print(f"✅ SUCESSO! O ID OFICIAL DO TENYS PÉ É: {tenys.id}")
print("-" * 30)

db.close()