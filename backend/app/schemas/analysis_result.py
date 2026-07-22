from typing import List, Optional, Dict, Any
from datetime import datetime
from pydantic import BaseModel, Field, ConfigDict, computed_field

from app.models.analysis_result import Recommendation, ExplanationSource


class Scores(BaseModel):
    """Score breakdown for analysis result"""
    heart: float = Field(..., ge=0, le=100, description="心动程度")
    need: float = Field(..., ge=0, le=100, description="需求程度")
    utility: float = Field(..., ge=0, le=100, description="实用程度")
    affordability: float = Field(..., ge=0, le=100, description="负担能力")
    duplication_risk: float = Field(..., ge=0, le=100, description="重复购买风险")
    impulse_risk: float = Field(..., ge=0, le=100, description="冲动风险")
    regret_risk: float = Field(..., ge=0, le=100, description="后悔风险")
    decision: float = Field(..., ge=0, le=100, description="最终决策分数")


class AnalysisResultBase(BaseModel):
    recommendation: Recommendation
    decision_score: float = Field(..., ge=0, le=100)
    need_score: float = Field(..., ge=0, le=100)
    utility_score: float = Field(..., ge=0, le=100)
    affordability_score: float = Field(..., ge=0, le=100)
    duplication_risk: float = Field(..., ge=0, le=100)
    impulse_risk: float = Field(..., ge=0, le=100)
    regret_risk: float = Field(..., ge=0, le=100)
    reason_codes: List[str] = Field(default_factory=list)
    positive_reasons: List[str] = Field(default_factory=list)
    negative_reasons: List[str] = Field(default_factory=list)
    purchase_conditions: List[str] = Field(default_factory=list)
    headline: str = Field(..., min_length=1, max_length=200)
    emotional_insight: str = Field(..., min_length=1, max_length=500)
    share_text: Optional[str] = Field(None, max_length=300)
    cooling_hours: int = Field(..., ge=0)
    rule_version: str = Field("1.0.0")
    explanation_source: ExplanationSource = ExplanationSource.TEMPLATE


class AnalysisResultCreate(AnalysisResultBase):
    product_id: int
    questionnaire_id: int


class AnalysisResultResponse(BaseModel):
    analysis_id: int
    product_id: int
    recommendation: Recommendation
    scores: Scores
    reason_codes: List[str]
    headline: str
    emotional_insight: str
    positive_reasons: List[str]
    negative_reasons: List[str]
    purchase_conditions: List[str]
    cooling_hours: int
    rule_version: str
    explanation_source: ExplanationSource
    created_at: datetime
    
    @computed_field
    @property
    def recommendation_text(self) -> str:
        """Get recommendation text in Chinese"""
        if self.recommendation == Recommendation.BUY:
            return "建议买"
        elif self.recommendation == Recommendation.WAIT:
            return "建议等等"
        else:
            return "先别买"


class AnalysisResultInDB(AnalysisResultBase):
    model_config = ConfigDict(from_attributes=True)
    
    id: int
    product_id: int
    questionnaire_id: int
    created_at: datetime


class AnalysisRequest(BaseModel):
    """Analysis request body"""
    product_id: int