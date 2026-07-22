from typing import Optional
from datetime import datetime
from pydantic import BaseModel, Field, ConfigDict

from app.models.user_profile import PersonalityType


class UserProfileBase(BaseModel):
    nickname: str = Field(..., min_length=1, max_length=100)
    age: Optional[int] = Field(None, ge=0, le=120)
    gender: Optional[str] = Field(None, pattern="^(male|female|other)$")
    monthly_disposable_budget: float = Field(3000.0, ge=0)
    current_month_spending: float = Field(0.0, ge=0)
    default_cooling_hours: int = Field(24, ge=0)
    personality_type: PersonalityType = PersonalityType.GENTLE


class UserProfileCreate(UserProfileBase):
    pass


class UserProfileUpdate(BaseModel):
    nickname: Optional[str] = Field(None, min_length=1, max_length=100)
    age: Optional[int] = Field(None, ge=0, le=120)
    gender: Optional[str] = Field(None, pattern="^(male|female|other)$")
    monthly_disposable_budget: Optional[float] = Field(None, ge=0)
    current_month_spending: Optional[float] = Field(None, ge=0)
    default_cooling_hours: Optional[int] = Field(None, ge=0)
    personality_type: Optional[PersonalityType] = None


class UserProfileInDB(UserProfileBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    created_at: datetime
    updated_at: Optional[datetime] = None


class UserProfileResponse(UserProfileInDB):
    remaining_budget: float
