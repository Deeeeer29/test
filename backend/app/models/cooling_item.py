from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Enum
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import enum

from app.db.base import Base


class CoolingStatus(str, enum.Enum):
    COOLING = "cooling"
    EXPIRED = "expired"
    PURCHASED = "purchased"
    ABANDONED = "abandoned"


class FinalDecision(str, enum.Enum):
    PURCHASED = "purchased"
    ABANDONED = "abandoned"


class CoolingItem(Base):
    __tablename__ = "cooling_items"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("user_profiles.id"), nullable=False)
    product_id = Column(Integer, ForeignKey("products.id"), nullable=False)
    analysis_id = Column(Integer, ForeignKey("analysis_results.id"), nullable=False)
    
    # Cooling period
    start_time = Column(DateTime(timezone=True), nullable=False, server_default=func.now())
    end_time = Column(DateTime(timezone=True), nullable=False)
    
    # Status
    status = Column(Enum(CoolingStatus), nullable=False, default=CoolingStatus.COOLING)
    final_decision = Column(Enum(FinalDecision))
    completed_at = Column(DateTime(timezone=True))
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Relationships
    user = relationship("UserProfile", backref="cooling_items")
    product = relationship("Product", back_populates="cooling_items")
    analysis = relationship("AnalysisResult", back_populates="cooling_item")
    
    @property
    def remaining_hours(self) -> float:
        """Calculate remaining cooling hours"""
        from datetime import datetime, timezone
        now = datetime.now(timezone.utc)
        if now >= self.end_time:
            return 0.0
        remaining = (self.end_time - now).total_seconds() / 3600
        return max(0.0, remaining)
    
    @property
    def is_expired(self) -> bool:
        """Check if cooling period has expired"""
        from datetime import datetime, timezone
        now = datetime.now(timezone.utc)
        return now >= self.end_time and self.status == CoolingStatus.COOLING