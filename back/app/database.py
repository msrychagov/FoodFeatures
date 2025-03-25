# app/database.py
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

from .config import DATABASE_URL

# Создаем движок
engine = create_engine(DATABASE_URL)

# Создаем Session
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Базовый класс для моделей
Base = declarative_base()

# Функция для получения сессии (Dependency)
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()