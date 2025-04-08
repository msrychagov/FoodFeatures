# app/models.py
from sqlalchemy import Column, Integer, String, ForeignKey, Table, Float, Text, ARRAY
from sqlalchemy.orm import relationship
from .database import Base


# Таблица-связка многие-ко-многим
product_category = Table(
    "product_category",
    Base.metadata,
    Column("product_id", ForeignKey("products.id"), primary_key=True),
    Column("category_id", ForeignKey("categories.id"), primary_key=True)
)

class Store(Base):
    __tablename__ = "stores"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, unique=True, index=True)

    products = relationship("Product", back_populates="store")

class Category(Base):
    __tablename__ = "categories"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, unique=True, index=True)

    products = relationship("Product", secondary=product_category, back_populates="categories")

class Product(Base):
    __tablename__ = "products"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    description = Column(Text, default="")
    image_url = Column(String, default="")
    specificies = Column(String, default="")
    fat_content = Column(String, default="")
    volume = Column(String, default="")
    compound = Column(String, default="")
    energy_value = Column(String, default="")
    protein = Column(String, default="")
    fats = Column(String, default="")
    carbs = Column(String, default="")

    store_id = Column(Integer, ForeignKey("stores.id"))
    store = relationship("Store", back_populates="products")

    categories = relationship(
        "Category",
        secondary="product_category",  # <-- связь многие-к-многим
        back_populates="products"
    )
    favorited_by = relationship("FavoriteProduct", back_populates="product")


class FavoriteProduct(Base):
    __tablename__ = "favorite_products"
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    product_id = Column(Integer, ForeignKey("products.id"), nullable=False)
    
    user = relationship("User", back_populates="favorite_products")
    product = relationship("Product", back_populates="favorited_by")

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    preferences = Column(ARRAY(String), nullable=True)
    email = Column(String, unique=True, index=True, nullable=False)
    hashed_password = Column(String, nullable=False)

    favorite_products = relationship("FavoriteProduct", back_populates="user")

