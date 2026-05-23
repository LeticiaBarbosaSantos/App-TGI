from database import engine, Base
import models

print("Iniciando a construção das tabelas...")
Base.metadata.create_all(bind=engine)
print("Sucesso! Tabelas criadas no starfast.db.")