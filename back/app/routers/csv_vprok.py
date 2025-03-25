# app/routers/csv_vprok.py

import csv
from fastapi import APIRouter, UploadFile, File, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from app.database import get_db
from app import models, schemas

router = APIRouter(prefix="/csv/vprok", tags=["CSV Loader Vprok"])

@router.post("/{store_name}/{category_name}", response_model=List[schemas.Product])
def upload_vprok_milk_csv(
    store_name: str,
    category_name: str,
    file: UploadFile = File(...),
    db: Session = Depends(get_db)
):
    """
    Загрузка CSV-файла для "Перекрёсток-Впрок" (категория: "Молоко").
    
    Столбцы в файле (пример):
      - "Название"
      - "Цена"
      - "Старая цена"
      - "Скидка"
      - "Единица измерения" (опционально)
      - "Ссылка на товар"
    """

    # Жёстко зашиваем название магазина
    # store_name = "Перекрёсток-Впрок"
    # # Жёстко зашиваем категорию
    # category_name = "Молоко"

    # 1) Находим/создаём магазин
    store = db.query(models.Store).filter_by(name=store_name).first()
    if not store:
        store = models.Store(name=store_name)
        db.add(store)
        db.commit()
        db.refresh(store)

    # 2) Находим/создаём категорию "Молоко"
    category = db.query(models.Category).filter_by(name=category_name).first()
    if not category:
        category = models.Category(name=category_name)
        db.add(category)
        db.commit()
        db.refresh(category)

    # 3) Читаем CSV из UploadFile
    try:
        content = file.file.read().decode("utf-8")
    except UnicodeDecodeError:
        raise HTTPException(status_code=400, detail="CSV must be UTF-8 encoded")

    lines = content.splitlines()
    reader = csv.DictReader(lines, delimiter=';')  # или ',', если нужно

    results = []

    for row in reader:
        product_name = row.get("Заголовок") or "Без имени"
        
        # Пример извлечения цены
        price_str = row.get("Цена", "0").replace(",", ".")
        try:
            price = float(price_str)
        except ValueError:
            price = 0.0

        old_price_str = row.get("Старая цена", "0").replace(",", ".")
        try:
            old_price = float(old_price_str)
        except ValueError:
            old_price = 0.0

        discount_str = row.get("Скидка", "0").replace(",", ".")
        try:
            discount = float(discount_str)
        except ValueError:
            discount = 0.0

        # "Единица измерения" (опционально)
        unit = row.get("Единица измерения") or ""

        image_url = row.get("Изображения") or ""

        description = row.get("Описание") or ""
        # 4) Ищем, не существует ли продукт с таким названием в этом магазине
        db_product = db.query(models.Product).filter_by(
            name=product_name,
            store_id=store.id
        ).first()

        if not db_product:
            # Создаём новый продукт
            db_product = models.Product(
                name=product_name,
                store_id=store.id,
                # price=price,
                # discount=discount,
                # old_price=old_price,    # если в моделях есть соответствующее поле
                # unit=unit,              # если в моделях есть соответствующее поле
                image_url=image_url,
                description=description
            )
            db.add(db_product)
            db.commit()
            db.refresh(db_product)
        else:
            # Обновляем
            # db_product.price = price
            # db_product.discount = discount
            # db_product.old_price = old_price
            # db_product.unit = unit
            db_product.image_url = image_url
            db_product.description = description
            db.commit()
            db.refresh(db_product)

        # 5) Привязываем к категории "Молоко"
        if category not in db_product.categories:
            db_product.categories.append(category)
            db.commit()
            db.refresh(db_product)

        # 6) Проверяем "без лактозы" (пример)
        if "безлактоз" in product_name.lower():
            cat_lact_free = db.query(models.Category).filter_by(name="Без лактозы").first()
            if not cat_lact_free:
                cat_lact_free = models.Category(name="Без лактозы")
                db.add(cat_lact_free)
                db.commit()
                db.refresh(cat_lact_free)

            if cat_lact_free not in db_product.categories:
                db_product.categories.append(cat_lact_free)
                db.commit()
                db.refresh(db_product)

        results.append(db_product)

    file.file.close()
    return results