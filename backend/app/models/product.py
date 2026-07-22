from sqlalchemy import Column, Integer, String, Float, DateTime, ForeignKey, Boolean, JSON, Enum
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import enum

from app.db.base import Base


class SourceType(str, enum.Enum):
    MANUAL = "manual"
    SCREENSHOT = "screenshot"
    LINK = "link"


class Product(Base):
    __tablename__ = "products"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("user_profiles.id"), nullable=False)
    name = Column(String(200), nullable=False)
    brand = Column(String(100))
    model = Column(String(100))
    price = Column(Float, nullable=False)
    currency = Column(String(3), nullable=False, default="CNY")
    category = Column(String(100), nullable=False)
    description = Column(String(1000))
    purchase_urgency = Column(Integer, nullable=False, default=3)
    specifications = Column(JSON, default=dict)  # JSON field for product specifications
    source_type = Column(Enum(SourceType), nullable=False, default=SourceType.MANUAL)
    source_url = Column(String(500))
    image_path = Column(String(500))
    user_confirmed = Column(Boolean, nullable=False, default=False)
    confirmed_at = Column(DateTime(timezone=True))
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Relationships
    user = relationship("UserProfile", backref="products")
    questionnaire = relationship("Questionnaire", uselist=False, back_populates="product")
    analysis_result = relationship("AnalysisResult", uselist=False, back_populates="product")
    cooling_items = relationship("CoolingItem", back_populates="product")
    purchase_reviews = relationship("PurchaseReview", back_populates="product")
