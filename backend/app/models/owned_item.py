from sqlalchemy import Column, Integer, String, Float, DateTime, ForeignKey, Enum
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import enum

from app.db.base import Base


class ItemCondition(str, enum.Enum):
    NEW = "new"
    GOOD = "good"
    FAIR = "fair"
    POOR = "poor"
    BROKEN = "broken"


class UsageFrequency(str, enum.Enum):
    DAILY = "daily"
    WEEKLY = "weekly"
    MONTHLY = "monthly"
    RARELY = "rarely"
    NEVER = "never"


class OwnedItem(Base):
    __tablename__ = "owned_items"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("user_profiles.id"), nullable=False)
    name = Column(String(200), nullable=False)
    category = Column(String(100), nullable=False)
    brand = Column(String(100))
    model = Column(String(100))
    condition = Column(Enum(ItemCondition), nullable=False, default=ItemCondition.GOOD)
    usage_frequency = Column(Enum(UsageFrequency), nullable=False, default=UsageFrequency.WEEKLY)
    notes = Column(String(500))
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    # Relationships
    user = relationship("UserProfile", backref="owned_items")