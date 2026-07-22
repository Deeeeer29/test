from typing import Optional, Dict, Any
from datetime import datetime
from pydantic import BaseModel, Field, ConfigDict

from app.models.product import SourceType


class ProductBase(BaseModel):
    name: str = Field(..., min_length=1, max_length=200)
    brand: Optional[str] = Field(None, max_length=100)
    model: Optional[str] = Field(None, max_length=100)
    price: float = Field(..., gt=0)
    currency: str = Field("CNY", min_length=3, max_length=3)
    category: str = Field(..., min_length=1, max_length=100)
    description: Optional[str] = Field(None, max_length=1000)
    purchase_urgency: int = Field(3, ge=1, le=5)
    specifications: Dict[str, Any] = Field(default_factory=dict)
    source_type: SourceType = SourceType.MANUAL
    source_url: Optional[str] = Field(None, max_length=500)
    image_path: Optional[str] = Field(None, max_length=500)


class ProductCreate(ProductBase):
    user_id: int


class ProductUpdate(BaseModel):
    name: Optional[str] = Field(None, min_length=1, max_length=200)
    brand: Optional[str] = Field(None, max_length=100)
    model: Optional[str] = Field(None, max_length=100)
    price: Optional[float] = Field(None, gt=0)
    currency: Optional[str] = Field(None, min_length=3, max_length=3)
    category: Optional[str] = Field(None, min_length=1, max_length=100)
    description: Optional[str] = Field(None, max_length=1000)
    purchase_urgency: Optional[int] = Field(None, ge=1, le=5)
    specifications: Optional[Dict[str, Any]] = None
    source_url: Optional[str] = Field(None, max_length=500)
    image_path: Optional[str] = Field(None, max_length=500)


class ProductConfirm(BaseModel):
    user_confirmed: bool = True


class ProductInDB(ProductBase):
    model_config = ConfigDict(from_attributes=True)
    
    id: int
    user_id: int
    user_confirmed: bool
    confirmed_at: Optional[datetime] = None
    created_at: datetime
    updated_at: Optional[datetime] = None


class ProductResponse(ProductInDB):
    pass


class ProductExtractFromImage(BaseModel):
    """Schema for image extraction request"""
    image_data: str = Field(..., description="Base64 encoded image data")
    image_type: str = Field(..., description="Image MIME type (e.g., image/jpeg, image/png)")


class ProductExtractFromLink(BaseModel):
    """Schema for link extraction request"""
    url: str = Field(..., description="Product URL")
    source_type: SourceType = SourceType.LINK
