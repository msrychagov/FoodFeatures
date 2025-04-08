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
        description = row.get("Описание") or "Без описания"
        image_url = row.get("Изображения") or ""
        specificies = row.get("Особенности") or "Без особенностей"
        fat_content = row.get("Жирность") or "Без жирности"
        volume = row.get("Объем") or "Без объема"
        compound = row.get("Состав") or "Без состава"
        energy_value = row.get("Энергетическая ценность") or "Без энергетической ценности"
        protein = row.get("Белки") or ""
        fats = row.get("Жиры") or ""
        carbs = row.get("Углеводы") or ""

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
                description=description,
                image_url=image_url,
                specificies=category_name,
                fat_content=fat_content,
                volume=volume,
                compound=compound,
                energy_value=energy_value + "Ккал",
                protein=protein,
                fats=fats,
                carbs=carbs,
            )
            db.add(db_product)
            db.commit()
            db.refresh(db_product)
        else:
            db_product.description = description
            db_product.image_url = image_url
            db_product.specificies = category_name
            db_product.fat_content = fat_content
            db_product.volume = volume
            db_product.compound = compound
            db_product.energy_value = energy_value + " Ккал"
            db_product.protein = protein
            db_product.fats = fats
            db_product.carbs = carbs
            db.commit()
            db.refresh(db_product)

        # 5) Привязываем к категории "Молоко"
        if category not in db_product.categories:
            db_product.categories.append(category)
            db.commit()
            db.refresh(db_product)

        # 6) Проверяем "без лактозы" (пример)
        # if "безлактоз" in product_name.lower():
        #     cat_lact_free = db.query(models.Category).filter_by(name="Без лактозы").first()
        #     if not cat_lact_free:
        #         cat_lact_free = models.Category(name="Без лактозы")
        #         db.add(cat_lact_free)
        #         db.commit()
        #         db.refresh(cat_lact_free)

        #     if cat_lact_free not in db_product.categories:
        #         db_product.categories.append(cat_lact_free)
        #         db.commit()
        #         db.refresh(db_product)

        # results.append(db_product)

    file.file.close()
    return results