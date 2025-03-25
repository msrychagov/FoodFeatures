# app/routers/favorites.py
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List

from app.database import get_db
from app.auth import get_current_user
from app import models, schemas

router = APIRouter(prefix="/favorites", tags=["Favorites"])

@router.get("/{product_id}")
def is_liked(
    product_id: int, 
    db: Session = Depends(get_db), 
    current_user: models.User = Depends(get_current_user)
    ):
    fav_exists = db.query(models.FavoriteProduct).filter_by(
        user_id=current_user.id, product_id=product_id
    ).first()
    if fav_exists:
        return True
    return False
    
@router.get("/", response_model=List[schemas.Product])
def get_favorite_products(
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Возвращаем список товаров (models.Product),
    которые пользователь добавил в избранное.
    """
    favorite_products = (
        db.query(models.Product)
        .join(models.FavoriteProduct, models.Product.id == models.FavoriteProduct.product_id)
        .filter(models.FavoriteProduct.user_id == current_user.id)
        .all()
    )
    return favorite_products

@router.get("/{store_id}/{category_id}", response_model=List[schemas.Product])
def get_favorite_products(
    store_id: int,
    category_id: int,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    # Базовый запрос: получаем товары (Product),
    # которые пользователь добавил в избранное
    query = (
        db.query(models.Product)
          .join(models.FavoriteProduct, models.Product.id == models.FavoriteProduct.product_id)
          .filter(models.FavoriteProduct.user_id == current_user.id)
    )

    # Фильтруем по магазину
    query = query.filter(models.Product.store_id == store_id)

    # Фильтруем по категории
    # При "многие к многим" (product_category) нужно сделать JOIN на связь с категориями
    query = (
        query.join(models.Product.categories)  # secondary=... из модели
             .filter(models.Category.id == category_id)
    )

    return query.all()


@router.post("/{product_id}", status_code=status.HTTP_201_CREATED)
def add_to_favorites(
    product_id: int,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Добавляем товар в избранное.
    """
    # Проверяем, существует ли товар
    product = db.query(models.Product).filter(models.Product.id == product_id).first()
    if not product:
        raise HTTPException(status_code=404, detail="Товар не найден")

    # Проверим, нет ли уже в избранном
    fav_exists = db.query(models.FavoriteProduct).filter_by(
        user_id=current_user.id, product_id=product_id
    ).first()
    if fav_exists:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Товар уже в избранном"
        )

    # Создаём запись
    new_fav = models.FavoriteProduct(user_id=current_user.id, product_id=product_id)
    db.add(new_fav)
    db.commit()
    return {"detail": "Товар добавлен в избранное"}

@router.delete("/{product_id}")
def remove_from_favorites(
    product_id: int,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Удаляем товар из избранного.
    """
    fav_record = db.query(models.FavoriteProduct).filter_by(
        user_id=current_user.id, product_id=product_id
    ).first()
    if not fav_record:
        raise HTTPException(status_code=404, detail="Товар не в избранном")

    db.delete(fav_record)
    db.commit()
    return {"detail": "Товар удалён из избранного"}




