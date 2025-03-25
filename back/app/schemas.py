# app/schemas.py
from pydantic import BaseModel, EmailStr
from typing import Optional, List

class CategoryBase(BaseModel):
    name: str

class CategoryCreate(CategoryBase):
    pass

class Category(CategoryBase):
    id: int
    class Config:
        orm_mode = True


class StoreBase(BaseModel):
    name: str

class StoreCreate(StoreBase):
    pass

class Store(StoreBase):
    id: int
    class Config:
        orm_mode = True


class ProductBase(BaseModel):
    name: str

class ProductCreate(ProductBase):
    store_id: int
    category_ids: List[int] = []

class Product(BaseModel):
    id: int
    name: str
    # price: float
    # discount: float
    # old_price: float
    # unit: str
    image_url: str
    store_id: int
    description: str

    class Config:
        orm_mode = True

# Схема для регистрации
class UserCreate(BaseModel):
    name: str
    email: EmailStr
    password: str

# Схема для вывода (без пароля)
class UserOut(BaseModel):
    id: int
    name: str
    email: EmailStr

    class Config:
        orm_mode = True

# Схема для логина
class UserLogin(BaseModel):
    email: EmailStr
    password: str

# Схема для токена
class Token(BaseModel):
    access_token: str
    token_type: str

# Дополнительная схема для payload внутри токена
class TokenData(BaseModel):
    email: Optional[str] = None