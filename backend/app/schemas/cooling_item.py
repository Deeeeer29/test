from typing import Optional
from datetime import datetime
from pydantic import BaseModel, Field, ConfigDict

from app.models.cooling_item import CoolingStatus, FinalDecision


class CoolingItemBase(BaseModel):
    end_time: datetime


class CoolingItemCreate(CoolingItemBase):
    user_id: int
    product_id: int
    analysis_id: int


class CoolingItemUpdate(BaseModel):
    status: Optional[CoolingStatus] = None
    final_decision: Optional[FinalDecision] = None
    completed_at: Optional[datetime] = None


class CoolingItemInDB(CoolingItemBase):
    model_config = ConfigDict(from_attributes=True)
    
    id: int
    user_id: int
    product_id: int
    analysis_id: int
    start_time: datetime
    status: CoolingStatus
    final_decision: Optional[FinalDecision] = None
    completed_at: Optional[datetime] = None
    created_at: datetime
    updated_at: Optional[datetime] = None


class CoolingItemResponse(CoolingItemInDB):
    remaining_hours: float
    is_expired: bool


class CoolingItemAction(BaseModel):
    """Schema for cooling item actions (purchase/abandon)"""
    notes: Optional[str] = Field(None, max_length=500)