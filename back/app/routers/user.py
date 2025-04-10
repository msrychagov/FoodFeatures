# app/routers/user.py

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from datetime import timedelta
from app.database import get_db
from app.auth import get_current_user
from app import models, schemas, auth, hashing
from app.config import ACCESS_TOKEN_EXPIRE_MINUTES
from fastapi.security import OAuth2PasswordRequestForm
from app.models import User


router = APIRouter(prefix="/user", tags=["user"])

@router.put("/me/update")
def update_user_data(
    updatedUser: schemas.UserUpdate, 
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    user = db.query(models.User).filter(models.User.id == current_user.id).first()
    user.name = updatedUser.name
    user.email = updatedUser.email
    user.preferences = updatedUser.preferences

    db.add(user)
    db.commit()
    db.refresh(user)

    return user

@router.post("/register")
def register_user(user_data: schemas.UserCreate, db: Session = Depends(get_db)):
    existing_user = db.query(models.User).filter(models.User.email == user_data.email).first()
    if existing_user:
        raise HTTPException(status_code=400, detail="Пользователь уже существует")

    # Создаем пользователя
    hashed = hashing.hash_password(user_data.password)
    new_user = models.User(name=user_data.name, preferences=user_data.preferences, email=user_data.email, hashed_password=hashed)
    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    # Генерируем токен
    # access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = auth.create_access_token(
        data={"sub": new_user.email},
        # expires_delta=access_token_expires
    )

    # Возвращаем JSON с токеном
    return {
        "access_token": access_token,
        "token_type": "bearer"
    }

@router.post("/login", response_model=schemas.Token)
def login_user(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
    # OAuth2PasswordRequestForm ожидает поля 'username' и 'password'
    user = db.query(models.User).filter(models.User.email == form_data.username).first()

    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Неверный email или пароль.",
            headers={"WWW-Authenticate": "Bearer"},
        )

    if not hashing.verify_password(form_data.password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Неверный email или пароль.",
            headers={"WWW-Authenticate": "Bearer"},
        )

    # Генерируем JWT токен
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = auth.create_access_token(
        data={"sub": user.email},
        expires_delta=access_token_expires
    )

    return {"access_token": access_token, "token_type": "bearer"}

# @app.get("/users/{user_id}", response_model=schemas.UserOut)
# def get_user_profile(user_id: int, db: Session = Depends(get_db)):
#     user = db.query(models.User).filter(models.User.id == user_id).first()
#     if not user:
#         raise HTTPException(status_code=404, detail="User not found")
#     return user

@router.get("/me")
def read_current_user(current_user: User = Depends(get_current_user)):
    """
    Этот эндпоинт возвращает информацию о текущем пользователе,
    если токен валиден. 
    """
    return current_user
