from typing import Optional
from datetime import datetime
from pydantic import BaseModel, Field, ConfigDict


class PurchaseReviewBase(BaseModel):
    actual_purchase_price: Optional[float] = Field(None, gt=0)
    usage_frequency: Optional[float] = Field(None, ge=0, le=100)
    satisfaction_score: Optional[float] = Field(None, ge=0, le=100)
    regret_score: Optional[float] = Field(None, ge=0, le=100)
    is_idle: bool = Field(False)
    notes: Optional[str] = Field(None, max_length=1000)


class PurchaseReviewCreate(PurchaseReviewBase):
    user_id: int
    product_id: int
    analysis_id: int


class PurchaseReviewUpdate(BaseModel):
    actual_purchase_price: Optional[float] = Field(None, gt=0)
    usage_frequency: Optional[float] = Field(None, ge=0, le=100)
    satisfaction_score: Optional[float] = Field(None, ge=0, le=100)
    regret_score: Optional[float] = Field(None, ge=0, le=100)
    is_idle: Optional[bool] = None
    notes: Optional[str] = Field(None, max_length=1000)


class PurchaseReviewInDB(PurchaseReviewBase):
    model_config = ConfigDict(from_attributes=True)
    
    id: int
    user_id: int
    product_id: int
    analysis_id: int
    reviewed_at: datetime


class PurchaseReviewResponse(PurchaseReviewInDB):
    pass


class PurchaseReviewStats(BaseModel):
    """Purchase review statistics"""
    user_id: int
    time_range: str
    total_reviews: int
    average_satisfaction: float
    average_regret: float
    idle_percentage: float
    total_spent: float
    average_price_difference: float
    recommendation_accuracy: float