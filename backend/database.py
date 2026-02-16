from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from models import Base
import os
from dotenv import load_dotenv

load_dotenv()

# Para teste local, usar SQLite em vez de PostgreSQL
USE_SQLITE = True

if USE_SQLITE:
    DATABASE_URL = "sqlite:///./smartpay.db"
else:
    DATABASE_URL = os.getenv(
        "DATABASE_URL",
        "postgresql://usuario:senha@localhost:5432/smartpay"
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
