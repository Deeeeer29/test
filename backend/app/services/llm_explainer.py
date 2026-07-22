import logging
import json
from typing import Optional, Dict, Any, List
from sqlalchemy.orm import Session

from app.models.product import Product
from app.models.questionnaire import Questionnaire
from app.models.analysis_result import Recommendation, ExplanationSource
from app.schemas.analysis_result import Scores

logger = logging.getLogger(__name__)


class LLMExplainer:
    """大模型解释服务：使用LLM生成个性化解释，带降级到模板系统"""
    
    def __init__(self, db: Session, llm_api_key: Optional[str] = None, llm_base_url: Optional[str] = None):
        self.db = db
        self.llm_api_key = llm_api_key
        self.llm_base_url = llm_base_url
        self.use_llm = bool(llm_api_key and llm_base_url)
        
        # 模板系统作为降级方案
        self.template_system = TemplateExplanationSystem()
    
    def generate_explanation(self, recommendation: Recommendation, scores: Scores,
                           questionnaire: Questionnaire, product: Product,
                           reason_codes: List[str], positive_reasons: List[str],
                           negative_reasons: List[str]) -> Dict[str, Any]:
        """生成解释，尝试使用LLM，失败时降级到模板系统"""
        
        explanation_data = {
            "recommendation": recommendation.value,
            "scores": scores.model_dump(),
            "reason_codes": reason_codes,
            "positive_reasons": positive_reasons,
            "negative_reasons": negative_reasons,
            "product_name": product.name,
            "product_price": product.price,
            "product_category": product.category,
            "need_level": questionnaire.need_level,
            "urgency_level": questionnaire.urgency_level,
            "budget_pressure": questionnaire.budget_pressure,
            "emotional_impulse": questionnaire.emotional_impulse,
        }
        
        try:
            if self.use_llm:
                explanation = self._generate_with_llm(explanation_data)
                explanation_source = ExplanationSource.LLM
            else:
                # 如果没有配置LLM，使用模板系统
                explanation = self.template_system.generate_explanation(
                    recommendation, scores, questionnaire, product,
                    reason_codes, positive_reasons, negative_reasons
                )
                explanation_source = ExplanationSource.TEMPLATE
                
        except Exception as e:
            logger.warning(f"LLM解释生成失败，降级到模板系统: {e}")
            explanation = self.template_system.generate_explanation(
                recommendation, scores, questionnaire, product,
                reason_codes, positive_reasons, negative_reasons
            )
            explanation_source = ExplanationSource.TEMPLATE
        
        return {
            "explanation": explanation,
            "source": explanation_source,
            "data": explanation_data
        }
    
    def _generate_with_llm(self, explanation_data: Dict[str, Any]) -> Dict[str, Any]:
        """使用LLM生成个性化解释"""
        # 这里实现实际的LLM调用
        # 由于这是一个示例，我们模拟LLM响应
        
        prompt = self._build_llm_prompt(explanation_data)
        
        # 模拟LLM响应
        llm_response = {
            "headline": self._generate_headline_from_llm(explanation_data),
            "emotional_insight": self._generate_emotional_insight_from_llm(explanation_data),
            "detailed_analysis": self._generate_detailed_analysis_from_llm(explanation_data),
            "personalized_advice": self._generate_personalized_advice_from_llm(explanation_data),
            "share_text": self._generate_share_text_from_llm(explanation_data)
        }
        
        return llm_response
    
    def _build_llm_prompt(self, data: Dict[str, Any]) -> str:
        """构建LLM提示词"""
        recommendation_text = {
            "buy": "建议购买",
            "wait": "建议等待",
            "dont_buy": "建议不购买"
        }.get(data["recommendation"], "建议等待")
        
        prompt = f"""你是一个购物决策助手，请根据以下数据生成购物建议解释：

商品信息：
- 名称：{data['product_name']}
- 价格：{data['product_price']}元
- 类别：{data['product_category']}

用户评估：
- 需求程度：{data['need_level']}/100
- 紧急程度：{data['urgency_level']}/100
- 预算压力：{data['budget_pressure']}/100
- 情感冲动：{data['emotional_impulse']}/100

评分结果：
- 最终决策分数：{data['scores']['decision']}/100
- 需求分数：{data['scores']['need']}/100
- 实用分数：{data['scores']['utility']}/100
- 负担能力分数：{data['scores']['affordability']}/100
- 重复风险：{data['scores']['duplication_risk']}/100
- 冲动风险：{data['scores']['impulse_risk']}/100
- 后悔风险：{data['scores']['regret_risk']}/100

推荐：{recommendation_text}

请生成：
1. 一个吸引人的标题（不超过20字）
2. 情感洞察（分析用户的购买心理，不超过100字）
3. 详细分析（分点说明优缺点，不超过200字）
4. 个性化建议（针对这个用户的建议，不超过100字）
5. 分享文本（用于社交分享，不超过50字）

请用中文回复，语气亲切但专业。"""
        
        return prompt
    
    def _generate_headline_from_llm(self, data: Dict[str, Any]) -> str:
        """从LLM生成标题（模拟）"""
        recommendation = data["recommendation"]
        scores = data["scores"]
        
        if recommendation == "buy":
            if scores["affordability"] >= 80:
                return "超值之选，现在入手正当时！"
            elif scores["need"] >= 80:
                return "刚需必备，果断拿下！"
            else:
                return "综合评估，建议购买"
        elif recommendation == "wait":
            if scores["impulse_risk"] <= 40:
                return "冷静一下，冲动是魔鬼"
            elif scores["regret_risk"] <= 40:
                return "三思而行，避免后悔"
            else:
                return "不妨再等等，观察一下"
        else:
            if scores["affordability"] <= 30:
                return "预算告急，理性放弃"
            elif scores["need"] <= 30:
                return "需求不足，不必强求"
            else:
                return "综合评估，建议放弃"
    
    def _generate_emotional_insight_from_llm(self, data: Dict[str, Any]) -> str:
        """从LLM生成情感洞察（模拟）"""
        emotional_impulse = data["emotional_impulse"]
        budget_pressure = data["budget_pressure"]
        
        insights = []
        
        if emotional_impulse > 70:
            insights.append("你似乎对这件物品有很强的情感冲动")
        elif emotional_impulse > 40:
            insights.append("你对这件物品有一定的好感")
        
        if budget_pressure > 70:
            insights.append("预算压力较大，需要谨慎考虑")
        elif budget_pressure > 40:
            insights.append("预算有些紧张，但还在可控范围")
        
        if data["urgency_level"] > 70:
            insights.append("你感觉这件事很紧急")
        
        if not insights:
            insights.append("你的决策比较理性")
        
        return "。".join(insights) + "。"
    
    def _generate_detailed_analysis_from_llm(self, data: Dict[str, Any]) -> str:
        """从LLM生成详细分析（模拟）"""
        analysis = []
        
        # 优点分析
        positives = data["positive_reasons"]
        if positives:
            analysis.append("优点：")
            for reason in positives[:3]:  # 最多3个优点
                analysis.append(f"- {reason}")
        
        # 缺点分析
        negatives = data["negative_reasons"]
        if negatives:
            analysis.append("需要注意：")
            for reason in negatives[:3]:  # 最多3个缺点
                analysis.append(f"- {reason}")
        
        # 风险提示
        scores = data["scores"]
        if scores["impulse_risk"] < 50:
            analysis.append("⚠️ 冲动消费风险较高")
        if scores["regret_risk"] < 50:
            analysis.append("⚠️ 后悔风险需要注意")
        
        return "\n".join(analysis)
    
    def _generate_personalized_advice_from_llm(self, data: Dict[str, Any]) -> str:
        """从LLM生成个性化建议（模拟）"""
        recommendation = data["recommendation"]
        
        if recommendation == "buy":
            return "建议在确认预算充足的情况下购买，注意保留购买凭证。"
        elif recommendation == "wait":
            return "建议设置一个24小时冷静期，如果冷静后仍然想要，再考虑购买。"
        else:
            return "建议从购物车中移除，避免反复看到产生购买冲动。"
    
    def _generate_share_text_from_llm(self, data: Dict[str, Any]) -> str:
        """从LLM生成分享文本（模拟）"""
        recommendation = data["recommendation"]
        product_name = data["product_name"]
        
        if recommendation == "buy":
            return f"经过理性分析，我决定购买{product_name}！"
        elif recommendation == "wait":
            return f"对{product_name}还需要再考虑一下，设置冷静期。"
        else:
            return f"理性思考后，决定不购买{product_name}了。"


class TemplateExplanationSystem:
    """模板解释系统：降级方案"""
    
    def generate_explanation(self, recommendation: Recommendation, scores: Scores,
                           questionnaire: Questionnaire, product: Product,
                           reason_codes: List[str], positive_reasons: List[str],
                           negative_reasons: List[str]) -> Dict[str, Any]:
        """使用模板生成解释"""
        
        headline = self._generate_headline(recommendation, scores)
        emotional_insight = self._generate_emotional_insight(recommendation, reason_codes, questionnaire)
        detailed_analysis = self._generate_detailed_analysis(scores, positive_reasons, negative_reasons)
        personalized_advice = self._generate_personalized_advice(recommendation, scores)
        share_text = self._generate_share_text(recommendation, product.name, positive_reasons, negative_reasons)
        
        return {
            "headline": headline,
            "emotional_insight": emotional_insight,
            "detailed_analysis": detailed_analysis,
            "personalized_advice": personalized_advice,
            "share_text": share_text
        }
    
    def _generate_headline(self, recommendation: Recommendation, scores: Scores) -> str:
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
    
    def _generate_emotional_insight(self, recommendation: Recommendation, 
                                   reason_codes: List[str], questionnaire: Questionnaire) -> str:
        """生成情感洞察"""
        insights = []
        
        # 根据原因代码生成洞察
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
    
    def _generate_detailed_analysis(self, scores: Scores, 
                                   positive_reasons: List[str], negative_reasons: List[str]) -> str:
        """生成详细分析"""
        analysis = []
        
        if positive_reasons:
            analysis.append("✅ 优势：")
            for reason in positive_reasons[:3]:
                analysis.append(f"  • {reason}")
        
        if negative_reasons:
            analysis.append("⚠️ 需要注意：")
            for reason in negative_reasons[:3]:
                analysis.append(f"  • {reason}")
        
        # 分数分析
        analysis.append("📊 分数分析：")
        analysis.append(f"  需求分数：{scores.need:.1f}/100")
        analysis.append(f"  实用分数：{scores.utility:.1f}/100")
        analysis.append(f"  负担能力：{scores.affordability:.1f}/100")
        analysis.append(f"  冲动风险：{scores.impulse_risk:.1f}/100")
        analysis.append(f"  后悔风险：{scores.regret_risk:.1f}/100")
        
        return "\n".join(analysis)
    
    def _generate_personalized_advice(self, recommendation: Recommendation, scores: Scores) -> str:
        """生成个性化建议"""
        if recommendation == Recommendation.BUY:
            advice = "建议购买，但请注意："
            if scores.affordability < 80:
                advice += "确保不会影响其他必要开支。"
            if scores.impulse_risk < 60:
                advice += "确认不是一时冲动。"
            if scores.regret_risk < 60:
                advice += "考虑清楚是否真的需要。"
            return advice
        
        elif recommendation == Recommendation.WAIT:
            advice = "建议等待24小时冷静期，然后："
            if scores.affordability < 60:
                advice += "等到下个月预算更充足时再考虑。"
            if scores.need < 60:
                advice += "确认是否真的需要。"
            return advice + "冷静后再做决定。"
        
        else:  # DONT_BUY
            return "建议放弃购买：删除购物车或收藏夹，寻找替代品或更合适的时机。"
    
    def _generate_share_text(self, recommendation: Recommendation, product_name: str,
                            positive_reasons: List[str], negative_reasons: List[str]) -> str:
        """生成分享文本"""
        if recommendation == Recommendation.BUY:
            if positive_reasons:
                main_reason = positive_reasons[0]
                return f"经过理性分析，我决定购买{product_name}！主要原因是：{main_reason}"
            else:
                return f"经过理性分析，我决定购买{product_name}！"
        
        elif recommendation == Recommendation.WAIT:
            if negative_reasons:
                main_reason = negative_reasons[0]
                return f"对{product_name}还需要再考虑一下，主要是因为：{main_reason}"
            else:
                return f"对{product_name}还需要再考虑一下，设置冷静期。"
        
        else:  # DONT_BUY
            if negative_reasons:
                main_reason = negative_reasons[0]
                return f"理性思考后，决定不购买{product_name}了，主要是因为：{main_reason}"
            else:
                return f"理性思考后，决定不购买{product_name}了。"