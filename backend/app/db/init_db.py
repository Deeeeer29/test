"""
Database initialization script.
This module provides functions to initialize the database with tables and optionally seed data.
"""

import logging
from typing import Optional

from sqlalchemy import create_engine
from sqlalchemy.exc import SQLAlchemyError

from app.core.config import settings
from app.db.base import Base
from app.db.session import engine

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def init_db(drop_all: bool = False, seed_data: bool = False) -> None:
    """
    Initialize the database by creating all tables.
    
    Args:
        drop_all: If True, drop all existing tables before creating new ones.
        seed_data: If True, seed the database with initial data after creating tables.
    
    Returns:
        None
    """
    try:
        if drop_all:
            logger.warning("Dropping all existing tables...")
            Base.metadata.drop_all(bind=engine)
            logger.info("All tables dropped successfully")
        
        logger.info("Creating database tables...")
        Base.metadata.create_all(bind=engine)
        logger.info("Database tables created successfully")
        
        if seed_data:
            logger.info("Seeding database with initial data...")
            seed_initial_data()
            logger.info("Database seeded successfully")
        
        logger.info("Database initialization completed successfully")
        
    except SQLAlchemyError as e:
        logger.error(f"Database initialization failed: {e}")
        raise
    except Exception as e:
        logger.error(f"Unexpected error during database initialization: {e}")
        raise


def seed_initial_data() -> None:
    """
    Seed the database with initial data.
    
    This function creates sample users, products, and other data for development and testing.
    """
    try:
        from datetime import datetime, timedelta, timezone
        from sqlalchemy.orm import Session
        from app.db.session import SessionLocal
        
        from app.models.user_profile import UserProfile, PersonalityType
        from app.models.product import Product, SourceType
        from app.models.owned_item import OwnedItem, ItemCondition, UsageFrequency
        from app.models.questionnaire import Questionnaire
        from app.models.analysis_result import AnalysisResult, Recommendation, ExplanationSource
        from app.models.cooling_item import CoolingItem, CoolingStatus
        from app.models.purchase_review import PurchaseReview
        
        db = SessionLocal()
        
        try:
            now = datetime.now(timezone.utc)
            
            # Create sample users (matching actual UserProfile fields)
            users = [
                UserProfile(
                    nickname="理性消费者小王",
                    monthly_disposable_budget=5000.0,
                    current_month_spending=1200.0,
                    default_cooling_hours=24,
                    personality_type=PersonalityType.GENTLE
                ),
                UserProfile(
                    nickname="冲动消费者小李",
                    monthly_disposable_budget=8000.0,
                    current_month_spending=3500.0,
                    default_cooling_hours=48,
                    personality_type=PersonalityType.SHARP
                ),
                UserProfile(
                    nickname="节俭达人小张",
                    monthly_disposable_budget=3000.0,
                    current_month_spending=500.0,
                    default_cooling_hours=72,
                    personality_type=PersonalityType.ACCOUNTANT
                ),
            ]
            
            for user in users:
                db.add(user)
            db.flush()
            
            # Create sample products (matching actual Product fields)
            products = [
                Product(
                    user_id=users[0].id,
                    name="降噪无线耳机",
                    brand="AudioTech",
                    model="ANC-X1",
                    price=599.99,
                    currency="CNY",
                    category="电子产品",
                    specifications={"颜色": "黑色", "蓝牙": "5.3", "续航": "30小时"},
                    source_type=SourceType.MANUAL,
                    user_confirmed=True,
                    confirmed_at=now
                ),
                Product(
                    user_id=users[0].id,
                    name="全自动咖啡机",
                    brand="BrewMaster",
                    model="CM-200",
                    price=899.99,
                    currency="CNY",
                    category="家用电器",
                    specifications={"功率": "1200W", "容量": "1.5L"},
                    source_type=SourceType.LINK,
                    source_url="https://example.com/coffee-maker",
                    user_confirmed=True,
                    confirmed_at=now
                ),
                Product(
                    user_id=users[1].id,
                    name="轻量跑鞋",
                    brand="RunFast",
                    model="RF-Pro",
                    price=499.99,
                    currency="CNY",
                    category="运动装备",
                    specifications={"尺码": "42", "颜色": "白色"},
                    source_type=SourceType.MANUAL,
                    user_confirmed=False
                ),
            ]
            
            for product in products:
                db.add(product)
            db.flush()
            
            # Create sample questionnaires (matching actual Questionnaire fields)
            questionnaires = [
                Questionnaire(
                    product_id=products[0].id,
                    purchase_reason="刚需",
                    need_level=85.0,
                    expected_usage_frequency=90.0,
                    urgency_level=30.0,
                    has_similar_item=False,
                    similar_item_satisfaction=None,
                    budget_pressure=20.0,
                    discount_influence=10.0,
                    emotional_impulse=15.0,
                    research_completeness=80.0
                ),
                Questionnaire(
                    product_id=products[1].id,
                    purchase_reason="折扣",
                    need_level=40.0,
                    expected_usage_frequency=50.0,
                    urgency_level=20.0,
                    has_similar_item=False,
                    similar_item_satisfaction=None,
                    budget_pressure=60.0,
                    discount_influence=85.0,
                    emotional_impulse=70.0,
                    research_completeness=30.0
                ),
                Questionnaire(
                    product_id=products[2].id,
                    purchase_reason="旧的坏了",
                    need_level=75.0,
                    expected_usage_frequency=80.0,
                    urgency_level=65.0,
                    has_similar_item=True,
                    similar_item_satisfaction=20.0,
                    budget_pressure=25.0,
                    discount_influence=30.0,
                    emotional_impulse=40.0,
                    research_completeness=70.0
                ),
            ]
            
            for q in questionnaires:
                db.add(q)
            db.flush()
            
            # Create sample analysis results (matching actual AnalysisResult fields)
            analysis_results = [
                AnalysisResult(
                    product_id=products[0].id,
                    questionnaire_id=questionnaires[0].id,
                    recommendation=Recommendation.BUY,
                    decision_score=78.5,
                    need_score=85.0,
                    utility_score=90.0,
                    affordability_score=80.0,
                    duplication_risk=80.0,
                    impulse_risk=85.0,
                    regret_risk=75.0,
                    reason_codes=["high_need", "high_utility", "affordable", "no_duplicate", "low_impulse"],
                    positive_reasons=["需求强烈", "实用性强", "负担得起", "无重复物品", "冲动风险低"],
                    negative_reasons=[],
                    purchase_conditions=["确保不会影响其他必要开支"],
                    headline="刚需必备，值得购买！",
                    emotional_insight="这件物品能很好地满足你的实际需求。综合来看，这是一个明智的选择",
                    share_text="经过理性分析，我决定买降噪无线耳机！主要因为：需求强烈",
                    cooling_hours=24,
                    rule_version="1.0.0",
                    explanation_source=ExplanationSource.TEMPLATE
                ),
                AnalysisResult(
                    product_id=products[1].id,
                    questionnaire_id=questionnaires[1].id,
                    recommendation=Recommendation.DONT_BUY,
                    decision_score=35.0,
                    need_score=40.0,
                    utility_score=50.0,
                    affordability_score=40.0,
                    duplication_risk=80.0,
                    impulse_risk=25.0,
                    regret_risk=30.0,
                    reason_codes=["low_need", "discount_trap", "high_impulse", "budget_tight"],
                    positive_reasons=["无重复物品"],
                    negative_reasons=["需求不足", "冲动风险高", "预算紧张"],
                    purchase_conditions=["删除购物车", "寻找替代品"],
                    headline="冲动消费风险高，建议放弃",
                    emotional_insight="你可能并不是真的需要这件物品。不要被折扣冲昏头脑，想想是否真的需要",
                    share_text="理性思考后，我决定不买全自动咖啡机了，主要因为：需求不足",
                    cooling_hours=48,
                    rule_version="1.0.0",
                    explanation_source=ExplanationSource.TEMPLATE
                ),
                AnalysisResult(
                    product_id=products[2].id,
                    questionnaire_id=questionnaires[2].id,
                    recommendation=Recommendation.BUY,
                    decision_score=72.0,
                    need_score=75.0,
                    utility_score=80.0,
                    affordability_score=75.0,
                    duplication_risk=55.0,
                    impulse_risk=65.0,
                    regret_risk=60.0,
                    reason_codes=["high_need", "high_utility", "affordable", "no_duplicate", "well_researched"],
                    positive_reasons=["需求强烈", "实用性强", "负担得起", "调研充分"],
                    negative_reasons=[],
                    purchase_conditions=["确认鞋码合适再下单"],
                    headline="刚需必备，值得购买！",
                    emotional_insight="旧的已经损坏，确实需要更新换代。综合来看，这是一个明智的选择",
                    share_text="经过理性分析，我决定购买轻量跑鞋！主要原因是：需求强烈",
                    cooling_hours=24,
                    rule_version="1.0.0",
                    explanation_source=ExplanationSource.TEMPLATE
                ),
            ]
            
            for analysis in analysis_results:
                db.add(analysis)
            db.flush()
            
            # Create sample owned items (matching actual OwnedItem fields)
            owned_items = [
                OwnedItem(
                    user_id=users[0].id,
                    name="MacBook Pro",
                    category="电子产品",
                    brand="Apple",
                    model="M3 Pro",
                    condition=ItemCondition.GOOD,
                    usage_frequency=UsageFrequency.DAILY,
                    notes="工作和娱乐主力机"
                ),
                OwnedItem(
                    user_id=users[0].id,
                    name="运动水壶",
                    category="运动装备",
                    brand="Thermos",
                    model="T-500",
                    condition=ItemCondition.FAIR,
                    usage_frequency=UsageFrequency.WEEKLY,
                    notes="健身时使用"
                ),
                OwnedItem(
                    user_id=users[1].id,
                    name="机械键盘",
                    category="电子产品",
                    brand="KeyChron",
                    model="K8 Pro",
                    condition=ItemCondition.GOOD,
                    usage_frequency=UsageFrequency.DAILY,
                    notes="打字手感很好"
                ),
            ]
            
            for item in owned_items:
                db.add(item)
            db.flush()
            
            # Create sample cooling items (matching actual CoolingItem fields)
            cooling_items = [
                CoolingItem(
                    user_id=users[0].id,
                    product_id=products[1].id,
                    analysis_id=analysis_results[1].id,
                    start_time=now - timedelta(hours=20),
                    end_time=now + timedelta(hours=28),
                    status=CoolingStatus.COOLING
                ),
            ]
            
            for item in cooling_items:
                db.add(item)
            db.flush()
            
            # Create sample purchase reviews (matching actual PurchaseReview fields)
            purchase_reviews = [
                PurchaseReview(
                    user_id=users[0].id,
                    product_id=products[0].id,
                    analysis_id=analysis_results[0].id,
                    actual_purchase_price=599.99,
                    usage_frequency=85.0,
                    satisfaction_score=90.0,
                    regret_score=5.0,
                    is_idle=False,
                    notes="音质和降噪效果都很满意，每天通勤都在用"
                ),
            ]
            
            for review in purchase_reviews:
                db.add(review)
            
            db.commit()
            logger.info(f"Seeded {len(users)} users, {len(products)} products, "
                       f"{len(questionnaires)} questionnaires, {len(analysis_results)} analyses, "
                       f"{len(owned_items)} owned items, {len(cooling_items)} cooling items, "
                       f"{len(purchase_reviews)} purchase reviews")
            
        except Exception as e:
            db.rollback()
            logger.error(f"Error seeding data: {e}")
            raise
        finally:
            db.close()
            
    except ImportError as e:
        logger.warning(f"Could not import models for seeding: {e}")
        logger.warning("Database tables created, but no data was seeded")
    except Exception as e:
        logger.error(f"Unexpected error during data seeding: {e}")
        raise


def check_db_connection() -> bool:
    """
    Check if database connection is working.
    
    Returns:
        True if connection is successful, False otherwise.
    """
    try:
        # Try to create a simple connection
        test_engine = create_engine(settings.DATABASE_URL)
        with test_engine.connect() as conn:
            conn.execute("SELECT 1")
        logger.info("Database connection successful")
        return True
    except Exception as e:
        logger.error(f"Database connection failed: {e}")
        return False


def get_db_info() -> dict:
    """
    Get database information.
    
    Returns:
        Dictionary with database information.
    """
    try:
        from sqlalchemy import inspect
        
        inspector = inspect(engine)
        tables = inspector.get_table_names()
        
        return {
            "database_url": str(settings.DATABASE_URL),
            "tables": tables,
            "table_count": len(tables),
            "connected": True
        }
    except Exception as e:
        logger.error(f"Could not get database info: {e}")
        return {
            "database_url": str(settings.DATABASE_URL),
            "tables": [],
            "table_count": 0,
            "connected": False,
            "error": str(e)
        }


if __name__ == "__main__":
    """
    Command-line interface for database initialization.
    
    Usage:
        python -m app.db.init_db [--drop-all] [--seed] [--check] [--info]
    
    Options:
        --drop-all   Drop all tables before creating new ones
        --seed       Seed database with initial data
        --check      Check database connection
        --info       Show database information
    """
    import argparse
    
    parser = argparse.ArgumentParser(description="Initialize Don't Buy Yet database")
    parser.add_argument("--drop-all", action="store_true", help="Drop all tables before creating")
    parser.add_argument("--seed", action="store_true", help="Seed database with initial data")
    parser.add_argument("--check", action="store_true", help="Check database connection")
    parser.add_argument("--info", action="store_true", help="Show database information")
    
    args = parser.parse_args()
    
    if args.check:
        if check_db_connection():
            print("✅ Database connection successful")
            exit(0)
        else:
            print("❌ Database connection failed")
            exit(1)
    
    if args.info:
        info = get_db_info()
        print("📊 Database Information:")
        print(f"  URL: {info.get('database_url', 'N/A')}")
        print(f"  Connected: {info.get('connected', False)}")
        print(f"  Tables: {info.get('table_count', 0)}")
        if info.get('tables'):
            print("  Table list:")
            for table in info['tables']:
                print(f"    - {table}")
        exit(0)
    
    # Default action: initialize database
    print("🚀 Initializing Don't Buy Yet database...")
    try:
        init_db(drop_all=args.drop_all, seed_data=args.seed)
        print("✅ Database initialization completed successfully")
        
        if args.seed:
            print("✅ Database seeded with initial data")
        
        # Show database info after initialization
        info = get_db_info()
        print(f"📊 Created {info.get('table_count', 0)} tables")
        
    except Exception as e:
        print(f"❌ Database initialization failed: {e}")
        exit(1)