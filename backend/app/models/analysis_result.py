from sqlalchemy import Column, Integer, String, Float, DateTime, ForeignKey, JSON, Enum
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import enum

from app.db.base import Base


class Recommendation(str, enum.Enum):
    BUY = "buy"
    WAIT = "wait"
    DONT_BUY = "dont_buy"


class ExplanationSource(str, enum.Enum):
    TEMPLATE = "template"
    LLM = "llm"


class AnalysisResult(Base):
    __tablename__ = "analysis_results"

    id = Column(Integer, primary_key=True, index=True)
    product_id = Column(Integer, ForeignKey("products.id"), nullable=False, unique=True)
    questionnaire_id = Column(Integer, ForeignKey("questionnaires.id"), nullable=False)
    
    # Recommendation
    recommendation = Column(Enum(Recommendation), nullable=False)
    
    # Scores (0-100)
    decision_score = Column(Float, nullable=False)
    need_score = Column(Float, nullable=False)
    utility_score = Column(Float, nullable=False)
    affordability_score = Column(Float, nullable=False)
    duplication_risk = Column(Float, nullable=False)
    impulse_risk = Column(Float, nullable=False)
    regret_risk = Column(Float, nullable=False)
    
    # Reasons
    reason_codes = Column(JSON, default=list)  # List of reason codes
    positive_reasons = Column(JSON, default=list)  # List of positive reasons
    negative_reasons = Column(JSON, default=list)  # List of negative reasons
    purchase_conditions = Column(JSON, default=list)  # List of purchase conditions
    
    # Explanation
    headline = Column(String(200), nullable=False)
    emotional_insight = Column(String(500), nullable=False)
    share_text = Column(String(300))
    
    # Cooling period
    cooling_hours = Column(Integer, nullable=False)
    
    # Metadata
    rule_version = Column(String(20), nullable=False, default="1.0.0")
    explanation_source = Column(Enum(ExplanationSource), nullable=False, default=ExplanationSource.TEMPLATE)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    # Relationships
    product = relationship("Product", back_populates="analysis_result")
    questionnaire = relationship("Questionnaire")
    cooling_item = relationship("CoolingItem", uselist=False, back_populates="analysis")
    purchase_review = relationship("PurchaseReview", uselist=False, back_populates="analysis")