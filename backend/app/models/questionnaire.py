from sqlalchemy import Column, Integer, String, Float, DateTime, ForeignKey, Boolean
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from app.db.base import Base


class Questionnaire(Base):
    __tablename__ = "questionnaires"

    id = Column(Integer, primary_key=True, index=True)
    product_id = Column(Integer, ForeignKey("products.id"), nullable=False, unique=True)
    
    # Purchase reason (from Stitch: 刚需、旧的坏了、折扣、看到别人买了、觉得酷、其他)
    purchase_reason = Column(String(100), nullable=False)
    
    # Scores (0-100)
    need_level = Column(Float, nullable=False)  # 需求程度
    expected_usage_frequency = Column(Float, nullable=False)  # 预计使用频率
    urgency_level = Column(Float, nullable=False)  # 紧急程度
    has_similar_item = Column(Boolean, nullable=False, default=False)  # 是否有类似物品
    similar_item_satisfaction = Column(Float)  # 对现有物品的满意度 (0-100, optional)
    budget_pressure = Column(Float, nullable=False)  # 预算压力 (0-100, higher means more pressure)
    discount_influence = Column(Float, nullable=False)  # 折扣影响程度 (0-100)
    emotional_impulse = Column(Float, nullable=False)  # 情绪冲动程度 (0-100)
    research_completeness = Column(Float, nullable=False)  # 调研完整度 (0-100)
    
    submitted_at = Column(DateTime(timezone=True), server_default=func.now())
    
    # Relationships
    product = relationship("Product", back_populates="questionnaire")
    
    @property
    def is_complete(self) -> bool:
        """Check if questionnaire is complete (all required fields filled)"""
        required_fields = [
            self.purchase_reason,
            self.need_level,
            self.expected_usage_frequency,
            self.urgency_level,
            self.budget_pressure,
            self.discount_influence,
            self.emotional_impulse,
            self.research_completeness,
        ]
        
        # Check if has_similar_item is not None (it's boolean, so always has value)
        # Check if similar_item_satisfaction is provided when has_similar_item is True
        if self.has_similar_item and self.similar_item_satisfaction is None:
            return False
            
        return all(field is not None for field in required_fields)