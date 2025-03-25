# app/routers/product.py
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from app.database import get_db
from app import models, schemas

router = APIRouter(prefix="/stores", tags=["Products"])

@router.get("/{store_id}/categories/{category_id}/products", response_model=List[schemas.Product])
def get_products_by_store_category(
    store_id: int,
    category_id: int,
    db: Session = Depends(get_db)
):
    # 1. Проверим, что магазин существует (опционально)
    store = db.query(models.Store).filter(models.Store.id == store_id).first()
    if not store:
        raise HTTPException(status_code=404, detail="Store not found")
    
    # 2. Проверим, что категория существует (опционально)
    category = db.query(models.Category).filter(models.Category.id == category_id).first()
    if not category:
        raise HTTPException(status_code=404, detail="Category not found")

    # 3. Вытащим товары
    #   Вариант A: делаем прямой фильтр
    products = (
        db.query(models.Product)
        .join(models.Product.categories)  # many-to-many через product_category
        .filter(
            models.Product.store_id == store_id,
            models.Category.id == category_id
        )
        .all()
    )
    
    return products