from typing import Optional
from datetime import datetime
from pydantic import BaseModel, ConfigDict, Field

from app.models.owned_item import ItemCondition, UsageFrequency


class OwnedItemBase(BaseModel):
    name: str = Field(..., min_length=1, max_length=200)
    category: str = Field(..., min_length=1, max_length=100)
    brand: Optional[str] = Field(None, max_length=100)
    model: Optional[str] = Field(None, max_length=100)
    condition: ItemCondition = ItemCondition.GOOD
    usage_frequency: UsageFrequency = UsageFrequency.WEEKLY
    notes: Optional[str] = Field(None, max_length=500)


class OwnedItemCreate(OwnedItemBase):
    user_id: int


class OwnedItemUpdate(BaseModel):
    name: Optional[str] = Field(None, min_length=1, max_length=200)
    category: Optional[str] = Field(None, min_length=1, max_length=100)
    brand: Optional[str] = Field(None, max_length=100)
    model: Optional[str] = Field(None, max_length=100)
    condition: Optional[ItemCondition] = None
    usage_frequency: Optional[UsageFrequency] = None
    notes: Optional[str] = Field(None, max_length=500)


class OwnedItemInDB(OwnedItemBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    user_id: int
    created_at: datetime


class OwnedItemResponse(OwnedItemInDB):
    pass
