import logging
from typing import List, Dict, Any
from sqlalchemy.orm import Session

from app.models.questionnaire import Questionnaire
from app.models.analysis_result import Recommendation
from app.schemas.analysis_result import Scores

logger = logging.getLogger(__name__)


class ReasonGenerator:
    """原因生成器：将原因代码转换为可读的原因文本"""
    
    # 原因代码到中文描述的映射
    REASON_MAPPING = {
        "high_need": "需求强烈",
        "low_need": "需求不足",
        "high_utility": "实用性强",
        "low_utility": "实用性弱",
        "affordable": "负担得起",
        "unaffordable": "负担过重",
        "no_duplicate": "无重复物品",
        "has_duplicate": "已有类似物品",
        "low_impulse": "冲动风险低",
        "high_impulse": "冲动风险高",
        "low_regret": "后悔风险低",
        "high_regret": "后悔风险高",
        "budget_ok": "预算充足",
        "budget_tight": "预算紧张",
        "well_researched": "调研充分",
        "poor_research": "调研不足",
        "urgent": "紧急需要",
        "not_urgent": "不紧急",
        "discount_ok": "折扣合理",
        "discount_trap": "折扣陷阱",
    }
    
    # 正面原因代码
    POSITIVE_REASONS = {
        "high_need", "high_utility", "affordable", "no_duplicate",
        "low_impulse", "low_regret", "budget_ok", "well_researched",
        "urgent", "discount_ok"
    }
    
    # 负面原因代码
    NEGATIVE_REASONS = {
        "low_need", "low_utility", "unaffordable", "has_duplicate",
        "high_impulse", "high_regret", "budget_tight", "poor_research",
        "not_urgent", "discount_trap"
    }
    
    def __init__(self, db: Session):
        self.db = db
    
    def generate_positive_reasons(self, reason_codes: List[str]) -> List[str]:
        """生成正面原因列表"""
        positive_reasons = []
        for code in reason_codes:
            if code in self.POSITIVE_REASONS and code in self.REASON_MAPPING:
                positive_reasons.append(self.REASON_MAPPING[code])
        return positive_reasons
    
    def generate_negative_reasons(self, reason_codes: List[str]) -> List[str]:
        """生成负面原因列表"""
        negative_reasons = []
        for code in reason_codes:
            if code in self.NEGATIVE_REASONS and code in self.REASON_MAPPING:
                negative_reasons.append(self.REASON_MAPPING[code])
        return negative_reasons
    
    def generate_share_text(self, recommendation: Recommendation, headline: str, 
                           positive_reasons: List[str], negative_reasons: List[str]) -> str:
        """生成分享文本"""
        if recommendation == Recommendation.BUY:
            if positive_reasons:
                main_reason = positive_reasons[0]
                return f"我决定购买这件物品！{headline}。主要原因是：{main_reason}。"
            else:
                return f"我决定购买这件物品！{headline}。"
        
        elif recommendation == Recommendation.WAIT:
            if negative_reasons:
                main_reason = negative_reasons[0]
                return f"我决定再等等看。{headline}。主要是因为：{main_reason}。"
            else:
                return f"我决定再等等看。{headline}。"
        
        else:  # DONT_BUY
            if negative_reasons:
                main_reason = negative_reasons[0]
                return f"我决定不买了。{headline}。主要是因为：{main_reason}。"
            else:
                return f"我决定不买了。{headline}。"
    
    def generate_detailed_reasons(self, scores: Scores, questionnaire: Questionnaire) -> Dict[str, Any]:
        """生成详细原因分析"""
        reasons = {
            "need": {
                "score": scores.need,
                "description": self._get_need_description(scores.need),
                "factors": self._get_need_factors(questionnaire)
            },
            "utility": {
                "score": scores.utility,
                "description": self._get_utility_description(scores.utility),
                "factors": self._get_utility_factors(questionnaire)
            },
            "affordability": {
                "score": scores.affordability,
                "description": self._get_affordability_description(scores.affordability),
                "factors": self._get_affordability_factors(questionnaire)
            },
            "duplication_risk": {
                "score": scores.duplication_risk,
                "description": self._get_duplication_risk_description(scores.duplication_risk),
                "factors": self._get_duplication_risk_factors(questionnaire)
            },
            "impulse_risk": {
                "score": scores.impulse_risk,
                "description": self._get_impulse_risk_description(scores.impulse_risk),
                "factors": self._get_impulse_risk_factors(questionnaire)
            },
            "regret_risk": {
                "score": scores.regret_risk,
                "description": self._get_regret_risk_description(scores.regret_risk),
                "factors": self._get_regret_risk_factors(questionnaire)
            }
        }
        
        return reasons
    
    def _get_need_description(self, score: float) -> str:
        """获取需求程度描述"""
        if score >= 80:
            return "强烈需求，非常需要这件物品"
        elif score >= 60:
            return "中度需求，比较需要这件物品"
        elif score >= 40:
            return "轻度需求，可有可无"
        else:
            return "需求很低，不太需要"
    
    def _get_utility_description(self, score: float) -> str:
        """获取实用程度描述"""
        if score >= 80:
            return "实用性很强，使用频率会很高"
        elif score >= 60:
            return "实用性较好，会经常使用"
        elif score >= 40:
            return "实用性一般，偶尔使用"
        else:
            return "实用性较差，可能闲置"
    
    def _get_affordability_description(self, score: float) -> str:
        """获取负担能力描述"""
        if score >= 80:
            return "完全负担得起，不影响预算"
        elif score >= 60:
            return "负担较轻，预算充足"
        elif score >= 40:
            return "负担适中，需要考虑预算"
        else:
            return "负担较重，预算紧张"
    
    def _get_duplication_risk_description(self, score: float) -> str:
        """获取重复购买风险描述"""
        if score >= 80:
            return "重复风险很低，没有类似物品"
        elif score >= 60:
            return "重复风险较低，类似物品满意度低"
        elif score >= 40:
            return "重复风险中等，有类似物品"
        else:
            return "重复风险很高，已有满意类似物品"
    
    def _get_impulse_risk_description(self, score: float) -> str:
        """获取冲动风险描述"""
        if score >= 80:
            return "冲动风险很低，决策理性"
        elif score >= 60:
            return "冲动风险较低，比较理性"
        elif score >= 40:
            return "冲动风险中等，有一定冲动"
        else:
            return "冲动风险很高，可能冲动消费"
    
    def _get_regret_risk_description(self, score: float) -> str:
        """获取后悔风险描述"""
        if score >= 80:
            return "后悔风险很低，购买后不会后悔"
        elif score >= 60:
            return "后悔风险较低，不太可能后悔"
        elif score >= 40:
            return "后悔风险中等，可能后悔"
        else:
            return "后悔风险很高，很可能后悔"
    
    def _get_need_factors(self, questionnaire: Questionnaire) -> List[str]:
        """获取需求因素"""
        factors = []
        factors.append(f"需求程度：{questionnaire.need_level:.1f}分")
        factors.append(f"紧急程度：{questionnaire.urgency_level:.1f}分")
        
        if questionnaire.has_similar_item:
            satisfaction = questionnaire.similar_item_satisfaction or 50
            factors.append(f"已有类似物品满意度：{satisfaction:.1f}分")
        else:
            factors.append("没有类似物品")
        
        return factors
    
    def _get_utility_factors(self, questionnaire: Questionnaire) -> List[str]:
        """获取实用因素"""
        factors = []
        factors.append(f"预期使用频率：{questionnaire.expected_usage_frequency:.1f}分")
        factors.append(f"调研完整度：{questionnaire.research_completeness:.1f}分")
        return factors
    
    def _get_affordability_factors(self, questionnaire: Questionnaire) -> List[str]:
        """获取负担能力因素"""
        factors = []
        factors.append(f"预算压力：{questionnaire.budget_pressure:.1f}分")
        factors.append(f"折扣影响：{questionnaire.discount_influence:.1f}分")
        return factors
    
    def _get_duplication_risk_factors(self, questionnaire: Questionnaire) -> List[str]:
        """获取重复风险因素"""
        factors = []
        if questionnaire.has_similar_item:
            satisfaction = questionnaire.similar_item_satisfaction or 50
            factors.append(f"已有类似物品，满意度{satisfaction:.1f}分")
        else:
            factors.append("没有类似物品")
        return factors
    
    def _get_impulse_risk_factors(self, questionnaire: Questionnaire) -> List[str]:
        """获取冲动风险因素"""
        factors = []
        factors.append(f"情感冲动：{questionnaire.emotional_impulse:.1f}分")
        factors.append(f"折扣影响：{questionnaire.discount_influence:.1f}分")
        factors.append(f"紧急程度：{questionnaire.urgency_level:.1f}分")
        factors.append(f"调研完整度：{questionnaire.research_completeness:.1f}分")
        return factors
    
    def _get_regret_risk_factors(self, questionnaire: Questionnaire) -> List[str]:
        """获取后悔风险因素"""
        factors = []
        factors.append(f"需求程度：{questionnaire.need_level:.1f}分")
        factors.append(f"预期使用频率：{questionnaire.expected_usage_frequency:.1f}分")
        factors.append(f"情感冲动：{questionnaire.emotional_impulse:.1f}分")
        factors.append(f"调研完整度：{questionnaire.research_completeness:.1f}分")
        factors.append(f"预算压力：{questionnaire.budget_pressure:.1f}分")
        return factors