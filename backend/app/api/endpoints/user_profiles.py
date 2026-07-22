from typing import Any, Dict, List

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from app.db.base import get_db
from app.models.user_profile import UserProfile
from app.schemas.user_profile import UserProfileCreate, UserProfileResponse, UserProfileUpdate

router = APIRouter()


def user_to_dict(user: UserProfile) -> Dict[str, Any]:
    return UserProfileResponse.model_validate(user).model_dump(mode="json")


def success_response(data: Any = None, message: str | None = None) -> Dict[str, Any]:
    response: Dict[str, Any] = {"success": True}
    if message is not None:
        response["message"] = message
    if data is not None:
        response["data"] = data
    return response


@router.get("")
async def get_user_profiles(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
):
    users = db.query(UserProfile).offset(skip).limit(limit).all()
    total = db.query(UserProfile).count()
    return {
        "success": True,
        "data": [user_to_dict(user) for user in users],
        "pagination": {"skip": skip, "limit": limit},
        "total": total,
    }


@router.get("/{user_id}")
async def get_user_profile(user_id: int, db: Session = Depends(get_db)):
    user = db.query(UserProfile).filter(UserProfile.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail=f"User with ID {user_id} not found")
    return success_response(user_to_dict(user))


@router.post("")
async def create_user_profile(
    user_data: UserProfileCreate,
    db: Session = Depends(get_db),
):
    existing_user = db.query(UserProfile).filter(UserProfile.nickname == user_data.nickname).first()
    if existing_user:
        raise HTTPException(status_code=400, detail="Nickname already exists")

    try:
        user = UserProfile(**user_data.model_dump())
        db.add(user)
        db.commit()
        db.refresh(user)
        return success_response(user_to_dict(user))
    except IntegrityError:
        db.rollback()
        raise HTTPException(status_code=400, detail="Failed to create user profile")


@router.put("/{user_id}")
async def update_user_profile(
    user_id: int,
    user_data: UserProfileUpdate,
    db: Session = Depends(get_db),
):
    user = db.query(UserProfile).filter(UserProfile.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail=f"User with ID {user_id} not found")

    if user_data.nickname and user_data.nickname != user.nickname:
        existing_user = (
            db.query(UserProfile)
            .filter(UserProfile.nickname == user_data.nickname, UserProfile.id != user_id)
            .first()
        )
        if existing_user:
            raise HTTPException(status_code=400, detail="Nickname is already used")

    try:
        update_data = user_data.model_dump(exclude_unset=True)
        for field, value in update_data.items():
            setattr(user, field, value)

        db.commit()
        db.refresh(user)
        return success_response(user_to_dict(user))
    except Exception as exc:
        db.rollback()
        raise HTTPException(status_code=400, detail=f"Failed to update user profile: {exc}")


@router.delete("/{user_id}")
async def delete_user_profile(user_id: int, db: Session = Depends(get_db)):
    user = db.query(UserProfile).filter(UserProfile.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail=f"User with ID {user_id} not found")

    try:
        db.delete(user)
        db.commit()
        return success_response(message="User profile deleted successfully")
    except Exception as exc:
        db.rollback()
        raise HTTPException(status_code=400, detail=f"Failed to delete user profile: {exc}")


@router.get("/{user_id}/monthly-spending")
async def get_user_monthly_spending(user_id: int, db: Session = Depends(get_db)):
    user = db.query(UserProfile).filter(UserProfile.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail=f"User with ID {user_id} not found")

    return success_response(
        {
            "user_id": user.id,
            "nickname": user.nickname,
            "monthly_disposable_budget": user.monthly_disposable_budget,
            "current_month_spending": user.current_month_spending,
            "remaining_budget": user.remaining_budget,
            "budget_utilization": (
                user.current_month_spending / user.monthly_disposable_budget * 100
                if user.monthly_disposable_budget > 0
                else 0
            ),
        }
    )


@router.put("/{user_id}/reset-monthly-spending")
async def reset_monthly_spending(user_id: int, db: Session = Depends(get_db)):
    user = db.query(UserProfile).filter(UserProfile.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail=f"User with ID {user_id} not found")

    try:
        user.current_month_spending = 0.0
        db.commit()
        db.refresh(user)
        return success_response(
            {
                "user_id": user.id,
                "current_month_spending": user.current_month_spending,
                "remaining_budget": user.monthly_disposable_budget,
            },
            message="Monthly spending reset successfully",
        )
    except Exception as exc:
        db.rollback()
        raise HTTPException(status_code=400, detail=f"Failed to reset monthly spending: {exc}")
