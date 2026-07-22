from typing import List, Dict, Any, Optional
from datetime import datetime
from pydantic import BaseModel, Field


class MonthlyReport(BaseModel):
    """Monthly consumption battle report"""
    year: int
    month: int
    total_analyzed: int = Field(0, description="分析商品数量")
    total_purchased: int = Field(0, description="最终购买数量")
    total_abandoned: int = Field(0, description="主动放弃数量")
    total_cooling: int = Field(0, description="正在冷静数量")
    avg_regret_score: Optional[float] = Field(None, ge=0, le=100, description="平均后悔分")
    total_saved: float = Field(0.0, description="节省金额")
    
    # Purchase motivations
    purchase_motivations: Dict[str, int] = Field(
        default_factory=dict,
        description="高频购买动机统计"
    )
    
    # Impulse patterns
    impulse_patterns: Dict[str, Any] = Field(
        default_factory=dict,
        description="高频冲动时间段"
    )
    
    # Personalized insights
    personalized_insights: List[str] = Field(
        default_factory=list,
        description="个性化提醒"
    )
    
    # Data sufficiency
    has_sufficient_data: bool = Field(False, description="是否有足够数据生成报告")
    message: Optional[str] = Field(None, description="数据不足时的提示信息")


class ReportRequest(BaseModel):
    year: int
    month: int