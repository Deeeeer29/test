import logging
from typing import Dict, Any, List
from sqlalchemy.orm import Session

from app.models.user_profile import UserProfile
from app.models.product import Product
from app.models.questionnaire import Questionnaire
from app.models.analysis_result import Recommendation
from app.schemas.analysis_result import Scores

logger = logging.getLogger(__name__)


class ScoringEngine:
    """评分引擎：基于问卷数据计算购买决策分数"""
    
    # 权重配置
    WEIGHTS = {
        "need": 0.25,
        "utility": 0.20,
        "affordability": 0.15,
        "duplication_risk": 0.10,
        "impulse_risk": 0.15,
        "regret_risk": 0.15,
    }
    
    # 阈值配置
    THRESHOLDS = {
        "buy": 70,
        "wait": 40,
        "dont_buy": 0,
    }
    
    def __init__(self, db: Session):
        self.db = db
    
    def calculate_scores(self, questionnaire: Questionnaire, user: UserProfile, product: Product) -> Scores:
        """计算所有维度的分数"""
        need_score = self._calculate_need_score(questionnaire)
        utility_score = self._calculate_utility_score(questionnaire)
        affordability_score = self._calculate_affordability_score(questionnaire, user, product)
        duplication_risk = self._calculate_duplication_risk(questionnaire)
        impulse_risk = self._calculate_impulse_risk(questionnaire)
        regret_risk = self._calculate_regret_risk(questionnaire)
        heart_score = self._calculate_heart_score(questionnaire)
        
        decision_score = self._calculate_decision_score(
            need_score, utility_score, affordability_score,
            duplication_risk, impulse_risk, regret_risk
        )
        
        return Scores(
            heart=heart_score,
            need=need_score,
            utility=utility_score,
            affordability=affordability_score,
            duplication_risk=duplication_risk,
            impulse_risk=impulse_risk,
            regret_risk=regret_risk,
            decision=decision_score
        )
    
    def _calculate_need_score(self, questionnaire: Questionnaire) -> float:
        """计算需求程度分数"""
        base_need = questionnaire.need_level
        urgency_factor = questionnaire.urgency_level / 100
        
        if questionnaire.has_similar_item:
            similarity_factor = (100 - (questionnaire.similar_item_satisfaction or 50)) / 100
            base_need *= similarity_factor
        
        research_factor = questionnaire.research_completeness / 100
        final_score = base_need * 0.6 + (base_need * urgency_factor) * 0.2 + (base_need * research_factor) * 0.2
        return min(100, max(0, final_score))
    
    def _calculate_utility_score(self, questionnaire: Questionnaire) -> float:
        """计算实用程度分数"""
        usage_score = questionnaire.expected_usage_frequency
        research_factor = questionnaire.research_completeness / 100
        
        if questionnaire.has_similar_item:
            satisfaction = questionnaire.similar_item_satisfaction or 50
            utility_factor = (100 - satisfaction) / 100
            usage_score *= utility_factor
        
        final_score = usage_score * 0.7 + (usage_score * research_factor) * 0.3
        return min(100, max(0, final_score))
    
    def _calculate_affordability_score(self, questionnaire: Questionnaire, user: UserProfile, product: Product) -> float:
        """计算负担能力分数"""
        budget_pressure = questionnaire.budget_pressure
        remaining_budget = max(0, user.monthly_disposable_budget - user.current_month_spending)
        budget_ratio = min(1.0, remaining_budget / user.monthly_disposable_budget) if user.monthly_disposable_budget > 0 else 0
        price_ratio = product.price / user.monthly_disposable_budget if user.monthly_disposable_budget > 0 else 1.0
        discount_factor = (100 - questionnaire.discount_influence) / 100
        
        affordability = (
            (100 - budget_pressure) * 0.4 +
            budget_ratio * 100 * 0.3 +
            (1.0 - min(price_ratio, 1.0)) * 100 * 0.2 +
            discount_factor * 100 * 0.1
        )
        
        return min(100, max(0, affordability))
    
    def _calculate_duplication_risk(self, questionnaire: Questionnaire) -> float:
        """计算重复购买风险（分数越高表示风险越低）"""
        if not questionnaire.has_similar_item:
            return 80
        
        satisfaction = questionnaire.similar_item_satisfaction or 50
        if satisfaction >= 80:
            return 20
        elif satisfaction >= 60:
            return 40
        else:
            return 60
    
    def _calculate_impulse_risk(self, questionnaire: Questionnaire) -> float:
        """计算冲动风险（分数越高表示风险越低）"""
        emotional_impulse = questionnaire.emotional_impulse
        discount_influence = questionnaire.discount_influence
        urgency_level = questionnaire.urgency_level
        research_completeness = questionnaire.research_completeness
        
        impulse_risk = (
            emotional_impulse * 0.4 +
            discount_influence * 0.3 +
            urgency_level * 0.2 +
            (100 - research_completeness) * 0.1
        )
        
        return max(0, 100 - impulse_risk)
    
    def _calculate_regret_risk(self, questionnaire: Questionnaire) -> float:
        """计算后悔风险（分数越高表示风险越低）"""
        regret_factors = []
        
        if questionnaire.need_level < 50:
            regret_factors.append(30)
        
        if questionnaire.expected_usage_frequency < 40:
            regret_factors.append(25)
        
        if questionnaire.emotional_impulse > 70:
            regret_factors.append(20)
        
        if questionnaire.research_completeness < 60:
            regret_factors.append(15)
        
        if questionnaire.budget_pressure > 70:
            regret_factors.append(10)
        
        if regret_factors:
            avg_regret_risk = sum(regret_factors) / len(regret_factors)
        else:
            avg_regret_risk = 10
        
        return max(0, 100 - avg_regret_risk)
    
    def _calculate_heart_score(self, questionnaire: Questionnaire) -> float:
        """计算心动程度分数"""
        heart_score = (
            questionnaire.need_level * 0.3 +
            questionnaire.expected_usage_frequency * 0.2 +
            (100 - questionnaire.budget_pressure) * 0.2 +
            questionnaire.discount_influence * 0.15 +
            questionnaire.emotional_impulse * 0.15
        )
        
        return min(100, max(0, heart_score))
    
    def _calculate_decision_score(self, need_score: float, utility_score: float, 
                                 affordability_score: float, duplication_risk: float,
                                 impulse_risk: float, regret_risk: float) -> float:
        """计算最终决策分数"""
        return (
            need_score * self.WEIGHTS["need"] +
            utility_score * self.WEIGHTS["utility"] +
            affordability_score * self.WEIGHTS["affordability"] +
            duplication_risk * self.WEIGHTS["duplication_risk"] +
            impulse_risk * self.WEIGHTS["impulse_risk"] +
            regret_risk * self.WEIGHTS["regret_risk"]
        )
    
    def get_recommendation(self, decision_score: float) -> Recommendation:
        """根据决策分数获取推荐"""
        if decision_score >= self.THRESHOLDS["buy"]:
            return Recommendation.BUY
        elif decision_score >= self.THRESHOLDS["wait"]:
            return Recommendation.WAIT
        else:
            return Recommendation.DONT_BUY
    
    def generate_reason_codes(self, scores: Scores, questionnaire: Questionnaire) -> List[str]:
        """生成原因代码"""
        reason_codes = []
        
        # 需求相关
        if scores.need >= 70:
            reason_codes.append("high_need")
        elif scores.need <= 30:
            reason_codes.append("low_need")
        
        # 实用相关
        if scores.utility >= 70:
            reason_codes.append("high_utility")
        elif scores.utility <= 30:
            reason_codes.append("low_utility")
        
        # 负担能力相关
        if scores.affordability >= 70:
            reason_codes.append("affordable")
        elif scores.affordability <= 30:
            reason_codes.append("unaffordable")
        
        # 重复风险相关
        if questionnaire.has_similar_item:
            reason_codes.append("has_duplicate")
        else:
            reason_codes.append("no_duplicate")
        
        # 冲动风险相关
        if scores.impulse_risk >= 70:
            reason_codes.append("low_impulse")
        elif scores.impulse_risk <= 30:
            reason_codes.append("high_impulse")
        
        # 后悔风险相关
        if scores.regret_risk >= 70:
            reason_codes.append("low_regret")
        elif scores.regret_risk <= 30:
            reason_codes.append("high_regret")
        
        # 预算相关
        if questionnaire.budget_pressure <= 30:
            reason_codes.append("budget_ok")
        elif questionnaire.budget_pressure >= 70:
            reason_codes.append("budget_tight")
        
        # 调研相关
        if questionnaire.research_completeness >= 70:
            reason_codes.append("well_researched")
        elif questionnaire.research_completeness <= 30:
            reason_codes.append("poor_research")
        
        # 紧急程度相关
        if questionnaire.urgency_level >= 70:
            reason_codes.append("urgent")
        elif questionnaire.urgency_level <= 30:
            reason_codes.append("not_urgent")
        
        # 折扣相关
        if questionnaire.discount_influence >= 70:
            reason_codes.append("discount_trap")
        elif questionnaire.discount_influence <= 30:
            reason_codes.append("discount_ok")
        
        return reason_codes
    
    def generate_headline(self, recommendation: Recommendation, scores: Scores) -> str:
        """生成标题"""
        if recommendation == Recommendation.BUY:
            if scores.affordability >= 80:
                return "物超所值，可以入手！"
            elif scores.need >= 80:
                return "刚需必备，值得购买！"
            else:
                return "综合评估，建议购买"
        
        elif recommendation == Recommendation.WAIT:
            if scores.impulse_risk <= 40:
                return "冲动消费风险高，建议冷静"
            elif scores.regret_risk <= 40:
                return "后悔风险较高，建议三思"
            else:
                return "建议再等等，观察一下"
        
        else:  # DONT_BUY
            if scores.affordability <= 30:
                return "负担过重，建议放弃"
            elif scores.need <= 30:
                return "需求不足，不必购买"
            else:
                return "综合评估，建议放弃"
    
    def generate_emotional_insight(self, recommendation: Recommendation, 
                                  reason_codes: List[str], questionnaire: Questionnaire) -> str:
        """生成情感洞察"""
        insights = []
        
        # 原因代码映射
        code_mapping = {
            "high_need": "这件物品能很好地满足你的实际需求",
            "low_need": "你可能并不是真的需要这件物品",
            "high_utility": "这件物品的实用性很强，使用频率会很高",
            "low_utility": "这件物品可能很快就会闲置",
            "affordable": "价格在你的预算范围内，负担不重",
            "unaffordable": "价格可能会给你的预算带来压力",
            "has_duplicate": "你已经有类似的物品了",
            "high_impulse": "你可能是被一时冲动驱使",
            "high_regret": "购买后可能会感到后悔",
            "budget_tight": "这个月预算已经比较紧张了",
            "poor_research": "你对这件物品的了解还不够充分",
        }
        
        for code in reason_codes:
            if code in code_mapping:
                insights.append(code_mapping[code])
        
        # 添加个性化洞察
        if questionnaire.emotional_impulse > 70:
            insights.append("情感因素占了很大比重，建议理性思考")
        
        if questionnaire.discount_influence > 70:
            insights.append("不要被折扣冲昏头脑，想想是否真的需要")
        
        if not insights:
            insights.append("建议综合考虑所有因素再做决定")
        
        # 根据推荐类型添加总结
        if recommendation == Recommendation.BUY:
            insights.append("综合来看，这是一个明智的选择")
        elif recommendation == Recommendation.WAIT:
            insights.append("给自己一些时间思考，或许会有新的发现")
        else:
            insights.append("放弃购买可能是个更好的选择")
        
        return "。".join(insights)
    
    def generate_purchase_conditions(self, recommendation: Recommendation, scores: Scores) -> List[str]:
        """生成购买条件"""
        conditions = []
        
        if recommendation == Recommendation.BUY:
            if scores.affordability < 80:
                conditions.append("确保不会影响其他必要开支")
            if scores.impulse_risk < 60:
                conditions.append("确认不是一时冲动")
            if scores.regret_risk < 60:
                conditions.append("考虑清楚是否真的需要")
        
        elif recommendation == Recommendation.WAIT:
            conditions.append("等待至少24小时冷静期")
            if scores.affordability < 60:
                conditions.append("等到下个月预算更充足时再考虑")
            if scores.need < 60:
                conditions.append("确认是否真的需要")
        
        else:  # DONT_BUY
            conditions.append("删除购物车或收藏夹")
            conditions.append("寻找替代品或更合适的时机")
        
        return conditions