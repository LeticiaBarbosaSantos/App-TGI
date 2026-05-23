from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from models import Base
import os
from dotenv import load_dotenv

load_dotenv()

# Para teste local, usar SQLite em vez de PostgreSQL
USE_SQLITE = True

if USE_SQLITE:
    # Pega o caminho absoluto da pasta atual (onde está o database.py)
    BASE_DIR = os.path.dirname(os.path.abspath(__file__))
    # Força o banco a ser sempre o arquivo starfast.db dentro desta mesma pasta
    DB_PATH = os.path.join(BASE_DIR, "starfast.db")
    
    DATABASE_URL = f"sqlite:///{DB_PATH}"
else:
    DATABASE_URL = os.getenv(
        "DATABASE_URL",
        "postgresql://usuario:senha@localhost:5432/starfast"
    )

engine = create_engine(
    DATABASE_URL,
    connect_args={"check_same_thread": False} if USE_SQLITE else {},
    echo=True
)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Criar tabelas
Base.metadata.create_all(bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
