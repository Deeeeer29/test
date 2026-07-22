from typing import Optional
from datetime import datetime
from pydantic import BaseModel, Field, ConfigDict


class QuestionnaireBase(BaseModel):
    purchase_reason: str = Field(..., min_length=1, max_length=100)
    need_level: float = Field(..., ge=0, le=100)
    expected_usage_frequency: float = Field(..., ge=0, le=100)
    urgency_level: float = Field(..., ge=0, le=100)
    has_similar_item: bool = Field(False)
    similar_item_satisfaction: Optional[float] = Field(None, ge=0, le=100)
    budget_pressure: float = Field(..., ge=0, le=100)
    discount_influence: float = Field(..., ge=0, le=100)
    emotional_impulse: float = Field(..., ge=0, le=100)
    research_completeness: float = Field(..., ge=0, le=100)


class QuestionnaireCreate(QuestionnaireBase):
    product_id: int


class QuestionnaireUpdate(BaseModel):
    purchase_reason: Optional[str] = Field(None, min_length=1, max_length=100)
    need_level: Optional[float] = Field(None, ge=0, le=100)
    expected_usage_frequency: Optional[float] = Field(None, ge=0, le=100)
    urgency_level: Optional[float] = Field(None, ge=0, le=100)
    has_similar_item: Optional[bool] = None
    similar_item_satisfaction: Optional[float] = Field(None, ge=0, le=100)
    budget_pressure: Optional[float] = Field(None, ge=0, le=100)
    discount_influence: Optional[float] = Field(None, ge=0, le=100)
    emotional_impulse: Optional[float] = Field(None, ge=0, le=100)
    research_completeness: Optional[float] = Field(None, ge=0, le=100)


class QuestionnaireInDB(QuestionnaireBase):
    model_config = ConfigDict(from_attributes=True)
    
    id: int
    product_id: int
    submitted_at: datetime


class QuestionnaireResponse(QuestionnaireInDB):
    is_complete: bool