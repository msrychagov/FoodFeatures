# app/routers/user.py

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List

from app.database import get_db
from app.auth import get_current_user
from app import models, schemas

router = APIRouter(prefix="/users/me", tags=["user"])

@router.put("/update")
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