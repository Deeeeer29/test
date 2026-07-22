from sqlalchemy import Column, Integer, String, Float, DateTime, ForeignKey, Boolean
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from app.db.base import Base


class PurchaseReview(Base):
    __tablename__ = "purchase_reviews"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("user_profiles.id"), nullable=False)
    product_id = Column(Integer, ForeignKey("products.id"), nullable=False)
    analysis_id = Column(Integer, ForeignKey("analysis_results.id"), nullable=False)
    
    # Actual purchase details
    actual_purchase_price = Column(Float)
    usage_frequency = Column(Float)  # 0-100 score
    satisfaction_score = Column(Float)  # 0-100 score
    regret_score = Column(Float)  # 0-100 score
    is_idle = Column(Boolean, default=False)  # Whether the item is now idle
    notes = Column(String(1000))
    
    reviewed_at = Column(DateTime(timezone=True), server_default=func.now())
    
    # Relationships
    user = relationship("UserProfile", backref="purchase_reviews")
    product = relationship("Product", back_populates="purchase_reviews")
    analysis = relationship("AnalysisResult", back_populates="purchase_review")