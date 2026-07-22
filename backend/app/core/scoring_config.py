from typing import Dict, Any


class ScoringConfig:
    """Scoring engine configuration"""
    
    # Score weights (unified with ScoringEngine.WEIGHTS)
    WEIGHTS = {
        "need": 0.25,
        "utility": 0.20,
        "affordability": 0.15,
        "duplication_risk": 0.10,
        "impulse_risk": 0.15,
        "regret_risk": 0.15,
    }
    
    # Decision thresholds
    DECISION_THRESHOLDS = {
        "buy": {
            "min_decision_score": 70,
            "max_regret_risk": 45,
        },
        "wait": {
            "min_decision_score": 45,
            "max_decision_score": 69,
        },
        "dont_buy": {
            "max_decision_score": 44,
            "min_regret_risk": 70,
        }
    }
    
    # Regret risk weights
    REGRET_RISK_WEIGHTS = {
        "impulse_risk": 0.30,
        "duplication_risk": 0.25,
        "budget_pressure": 0.25,
        "low_usage_risk": 0.20,
    }
    
    # Cooling hours based on risk level
    COOLING_HOURS = {
        "low": 6,
        "medium": 24,
        "high": 72,
        "very_high": 168,
    }
    
    # Risk level thresholds
    RISK_THRESHOLDS = {
        "low": 30,
        "medium": 50,
        "high": 70,
        "very_high": 90,
    }
    
    # Hard rules
    HARD_RULES = {
        "max_budget_exceeded": {
            "enabled": True,
            "message": "商品价格超过本月剩余预算",
        },
        "similar_item_exists": {
            "enabled": True,
            "duplication_risk_increase": 30,
        },
        "high_impulse_low_urgency": {
            "enabled": True,
            "impulse_threshold": 75,
            "urgency_threshold": 40,
            "message": "情绪冲动较高但紧急程度较低",
        }
    }
    
    # Reason codes mapping
    REASON_CODES = {
        "CLEAR_NEED": {
            "type": "positive",
            "description": "有明确的使用需求",
            "trigger_field": "need_level",
            "threshold": 70,
        },
        "HIGH_EXPECTED_USAGE": {
            "type": "positive",
            "description": "预计使用频率较高",
            "trigger_field": "expected_usage_frequency",
            "threshold": 70,
        },
        "BUDGET_AFFORDABLE": {
            "type": "positive",
            "description": "预算充足",
            "trigger_field": "budget_pressure",
            "threshold": 30,  # budget_pressure is inverse (lower is better)
        },
        "BUDGET_EXCEEDED": {
            "type": "negative",
            "description": "商品价格超过本月剩余预算",
            "trigger_field": "budget_pressure",
            "threshold": 100,  # Always triggered by hard rule
        },
        "SIMILAR_ITEM_EXISTS": {
            "type": "negative",
            "description": "已有功能相近的商品",
            "trigger_field": "has_similar_item",
            "threshold": 0.5,  # boolean-like
        },
        "HIGH_EMOTIONAL_IMPULSE": {
            "type": "negative",
            "description": "购买动机受到情绪影响",
            "trigger_field": "emotional_impulse",
            "threshold": 75,
        },
        "DISCOUNT_PRESSURE": {
            "type": "condition",
            "description": "受到折扣或促销影响",
            "trigger_field": "discount_influence",
            "threshold": 60,
        },
        "LOW_URGENCY": {
            "type": "negative",
            "description": "紧急程度较低",
            "trigger_field": "urgency_level",
            "threshold": 40,
        },
        "LOW_RESEARCH_COMPLETENESS": {
            "type": "condition",
            "description": "调研不够充分",
            "trigger_field": "research_completeness",
            "threshold": 50,
        },
        "HIGH_REGRET_RISK": {
            "type": "negative",
            "description": "后悔风险较高",
            "trigger_field": "regret_risk",
            "threshold": 70,
        },
    }
    
    # Personality templates for explanation service
    PERSONALITY_TEMPLATES = {
        "gentle": {
            "name": "温和型",
            "tone": "温和、体贴、鼓励",
            "positive_prefix": "看起来",
            "negative_prefix": "不过",
            "condition_prefix": "如果",
        },
        "sharp": {
            "name": "犀利型",
            "tone": "直接、犀利、一针见血",
            "positive_prefix": "很明显",
            "negative_prefix": "但是",
            "condition_prefix": "除非",
        },
        "accountant": {
            "name": "会计型",
            "tone": "理性、数据驱动、分析",
            "positive_prefix": "数据显示",
            "negative_prefix": "然而从数据看",
            "condition_prefix": "需要满足",
        },
        "reverse_sales": {
            "name": "反向销售型",
            "tone": "幽默、反向推销、调侃",
            "positive_prefix": "虽然你可能会喜欢",
            "negative_prefix": "但我得告诉你",
            "condition_prefix": "真想买的话",
        },
    }
    
    @classmethod
    def get_cooling_hours(cls, regret_risk: float) -> int:
        """Get cooling hours based on regret risk score"""
        if regret_risk >= cls.RISK_THRESHOLDS["very_high"]:
            return cls.COOLING_HOURS["very_high"]
        elif regret_risk >= cls.RISK_THRESHOLDS["high"]:
            return cls.COOLING_HOURS["high"]
        elif regret_risk >= cls.RISK_THRESHOLDS["medium"]:
            return cls.COOLING_HOURS["medium"]
        else:
            return cls.COOLING_HOURS["low"]