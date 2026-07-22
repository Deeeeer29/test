#!/usr/bin/env python3
"""
Seed data script for Don't Buy Yet application.
This script populates the database with sample data for testing and development.
"""

import sys
import os
from datetime import datetime, timedelta
from decimal import Decimal

# Add the parent directory to the path so we can import app modules
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from sqlalchemy.orm import Session
from sqlalchemy import create_engine
from app.db.base import Base, SessionLocal
from app.models.user_profile import UserProfile
from app.models.product import Product
from app.models.questionnaire import Questionnaire
from app.models.analysis_result import AnalysisResult, Recommendation
from app.models.cooling_item import CoolingItem, CoolingStatus, FinalDecision
from app.models.purchase_review import PurchaseReview
from app.models.owned_item import OwnedItem


def create_sample_users(db: Session):
    """Create sample user profiles"""
    users = [
        UserProfile(
            nickname="理性消费者",
            age=30,
            gender="male",
            monthly_disposable_budget=5000.00,
            current_month_spending=2500.00,
            personality_type="rational",
            default_cooling_hours=48,
            created_at=datetime.now() - timedelta(days=30),
            updated_at=datetime.now() - timedelta(days=30)
        ),
        UserProfile(
            nickname="冲动购物者",
            age=25,
            gender="female",
            monthly_disposable_budget=3000.00,
            current_month_spending=2800.00,
            personality_type="impulsive",
            default_cooling_hours=24,
            created_at=datetime.now() - timedelta(days=25),
            updated_at=datetime.now() - timedelta(days=25)
        ),
        UserProfile(
            nickname="节俭达人",
            age=35,
            gender="male",
            monthly_disposable_budget=4000.00,
            current_month_spending=1200.00,
            personality_type="frugal",
            default_cooling_hours=72,
            created_at=datetime.now() - timedelta(days=20),
            updated_at=datetime.now() - timedelta(days=20)
        ),
        UserProfile(
            nickname="情感消费者",
            age=28,
            gender="female",
            monthly_disposable_budget=3500.00,
            current_month_spending=2000.00,
            personality_type="emotional",
            default_cooling_hours=36,
            created_at=datetime.now() - timedelta(days=15),
            updated_at=datetime.now() - timedelta(days=15)
        )
    ]
    
    for user in users:
        db.add(user)
    
    db.commit()
    print(f"Created {len(users)} sample users")
    return users


def create_sample_products(db: Session, users):
    """Create sample products for users"""
    products = []
    
    # Products for user 1 (理性消费者)
    products.extend([
        Product(
            user_id=users[0].id,
            name="无线降噪耳机",
            price=899.00,
            category="电子产品",
            description="高端无线降噪耳机，适合通勤和办公使用",
            purchase_urgency=3,
            created_at=datetime.now() - timedelta(days=10),
            updated_at=datetime.now() - timedelta(days=10)
        ),
        Product(
            user_id=users[0].id,
            name="智能手表",
            price=1299.00,
            category="电子产品",
            description="多功能智能手表，支持健康监测",
            purchase_urgency=2,
            created_at=datetime.now() - timedelta(days=8),
            updated_at=datetime.now() - timedelta(days=8)
        ),
        Product(
            user_id=users[0].id,
            name="办公椅",
            price=599.00,
            category="家具",
            description="人体工学办公椅，保护腰椎健康",
            purchase_urgency=4,
            created_at=datetime.now() - timedelta(days=5),
            updated_at=datetime.now() - timedelta(days=5)
        )
    ])
    
    # Products for user 2 (冲动购物者)
    products.extend([
        Product(
            user_id=users[1].id,
            name="限量版球鞋",
            price=1299.00,
            category="服饰",
            description="限量版联名球鞋，收藏价值高",
            purchase_urgency=5,
            created_at=datetime.now() - timedelta(days=7),
            updated_at=datetime.now() - timedelta(days=7)
        ),
        Product(
            user_id=users[1].id,
            name="游戏主机",
            price=2999.00,
            category="电子产品",
            description="最新款游戏主机，支持4K游戏",
            purchase_urgency=4,
            created_at=datetime.now() - timedelta(days=3),
            updated_at=datetime.now() - timedelta(days=3)
        ),
        Product(
            user_id=users[1].id,
            name="设计师包包",
            price=2599.00,
            category="服饰",
            description="知名设计师品牌包包，时尚单品",
            purchase_urgency=5,
            created_at=datetime.now() - timedelta(days=1),
            updated_at=datetime.now() - timedelta(days=1)
        )
    ])
    
    # Products for user 3 (节俭达人)
    products.extend([
        Product(
            user_id=users[2].id,
            name="保温杯",
            price=89.00,
            category="日用品",
            description="不锈钢保温杯，保热保冷",
            purchase_urgency=2,
            created_at=datetime.now() - timedelta(days=12),
            updated_at=datetime.now() - timedelta(days=12)
        ),
        Product(
            user_id=users[2].id,
            name="书籍",
            price=59.00,
            category="教育",
            description="个人成长类书籍",
            purchase_urgency=1,
            created_at=datetime.now() - timedelta(days=9),
            updated_at=datetime.now() - timedelta(days=9)
        )
    ])
    
    # Products for user 4 (情感消费者)
    products.extend([
        Product(
            user_id=users[3].id,
            name="鲜花",
            price=199.00,
            category="礼品",
            description="节日鲜花，表达情感",
            purchase_urgency=3,
            created_at=datetime.now() - timedelta(days=6),
            updated_at=datetime.now() - timedelta(days=6)
        ),
        Product(
            user_id=users[3].id,
            name="纪念品",
            price=399.00,
            category="礼品",
            description="旅游纪念品，有特殊意义",
            purchase_urgency=4,
            created_at=datetime.now() - timedelta(days=4),
            updated_at=datetime.now() - timedelta(days=4)
        )
    ])
    
    for product in products:
        db.add(product)
    
    db.commit()
    print(f"Created {len(products)} sample products")
    return products


def create_sample_questionnaires(db: Session, products):
    """Create sample questionnaires for products"""
    questionnaires = []
    
    # Questionnaires for each product
    for i, product in enumerate(products):
        necessity_score = (i % 5) + 1  # 1-5
        frequency_score = ((i + 1) % 5) + 1  # 1-5
        emotional_value_score = ((i + 2) % 5) + 1  # 1-5
        budget_fit_score = ((i + 3) % 5) + 1  # 1-5
        
        questionnaire = Questionnaire(
            product_id=product.id,
            necessity_score=necessity_score,
            frequency_score=frequency_score,
            emotional_value_score=emotional_value_score,
            budget_fit_score=budget_fit_score,
            additional_notes=f"产品{i+1}的问卷备注",
            created_at=product.created_at + timedelta(hours=1),
            updated_at=product.created_at + timedelta(hours=1)
        )
        questionnaires.append(questionnaire)
        db.add(questionnaire)
    
    db.commit()
    print(f"Created {len(questionnaires)} sample questionnaires")
    return questionnaires


def create_sample_analysis_results(db: Session, products, users):
    """Create sample analysis results"""
    analysis_results = []
    
    # Analysis for each product
    for i, product in enumerate(products):
        user = next((u for u in users if u.id == product.user_id), None)
        if not user:
            continue
        
        # Different recommendations based on user personality
        if user.personality_type == "rational":
            recommendation = Recommendation.BUY if i % 3 == 0 else Recommendation.WAIT
        elif user.personality_type == "impulsive":
            recommendation = Recommendation.DONT_BUY if i % 4 == 0 else Recommendation.BUY
        elif user.personality_type == "frugal":
            recommendation = Recommendation.DONT_BUY if i % 2 == 0 else Recommendation.WAIT
        else:  # emotional
            recommendation = Recommendation.BUY if i % 3 != 0 else Recommendation.WAIT
        
        decision_score = float(70 + (i % 30))  # 70-100
        
        analysis = AnalysisResult(
            product_id=product.id,
            user_id=product.user_id,
            decision_score=decision_score,
            recommendation=recommendation,
            reasoning=f"基于用户画像和商品评估，建议{recommendation.value}。用户类型：{user.personality_type}，商品价格：{product.price}",
            created_at=product.created_at + timedelta(hours=2),
            updated_at=product.created_at + timedelta(hours=2)
        )
        analysis_results.append(analysis)
        db.add(analysis)
    
    db.commit()
    print(f"Created {len(analysis_results)} sample analysis results")
    return analysis_results


def create_sample_cooling_items(db: Session, products, analysis_results):
    """Create sample cooling items"""
    cooling_items = []
    
    # Create cooling items for some products
    for i, product in enumerate(products[:8]):  # First 8 products
        analysis = next((a for a in analysis_results if a.product_id == product.id), None)
        if not analysis:
            continue
        
        # Different statuses based on index
        if i % 4 == 0:
            status = CoolingStatus.COOLING
            final_decision = None
            completed_at = None
        elif i % 4 == 1:
            status = CoolingStatus.PURCHASED
            final_decision = FinalDecision.PURCHASED
            completed_at = product.created_at + timedelta(days=1)
        elif i % 4 == 2:
            status = CoolingStatus.ABANDONED
            final_decision = FinalDecision.ABANDONED
            completed_at = product.created_at + timedelta(days=2)
        else:
            status = CoolingStatus.EXPIRED
            final_decision = FinalDecision.EXPIRED
            completed_at = product.created_at + timedelta(days=3)
        
        cooling_item = CoolingItem(
            user_id=product.user_id,
            product_id=product.id,
            cooling_hours=24 if i % 2 == 0 else 48,
            status=status,
            final_decision=final_decision,
            start_time=product.created_at + timedelta(hours=3),
            completed_at=completed_at,
            notes=f"冷静池项目{i+1}的备注",
            created_at=product.created_at + timedelta(hours=3),
            updated_at=product.created_at + timedelta(hours=3)
        )
        cooling_items.append(cooling_item)
        db.add(cooling_item)
    
    db.commit()
    print(f"Created {len(cooling_items)} sample cooling items")
    return cooling_items


def create_sample_purchase_reviews(db: Session, products, cooling_items):
    """Create sample purchase reviews"""
    purchase_reviews = []
    
    # Create purchase reviews for purchased cooling items
    purchased_cooling_items = [ci for ci in cooling_items if ci.status == CoolingStatus.PURCHASED]
    
    for i, cooling_item in enumerate(purchased_cooling_items):
        product = next((p for p in products if p.id == cooling_item.product_id), None)
        if not product:
            continue
        
        satisfaction_score = 80 + (i % 20)  # 80-100
        regret_score = 10 + (i % 30)  # 10-40
        is_idle = i % 3 == 0  # 1/3 are idle
        
        review = PurchaseReview(
            user_id=cooling_item.user_id,
            product_id=cooling_item.product_id,
            actual_purchase_price=product.price * Decimal(0.9),  # 10% discount
            satisfaction_score=satisfaction_score,
            regret_score=regret_score,
            is_idle=is_idle,
            review_notes=f"购买后评价{i+1}：商品质量{(satisfaction_score/20):.1f}星",
            reviewed_at=cooling_item.completed_at + timedelta(hours=1),
            created_at=cooling_item.completed_at + timedelta(hours=1),
            updated_at=cooling_item.completed_at + timedelta(hours=1)
        )
        purchase_reviews.append(review)
        db.add(review)
    
    db.commit()
    print(f"Created {len(purchase_reviews)} sample purchase reviews")
    return purchase_reviews


def create_sample_owned_items(db: Session, users):
    """Create sample owned items"""
    owned_items = []
    
    # Sample owned items for each user
    items_data = [
        ("笔记本电脑", "电子产品", 6999.00, "工作用笔记本电脑"),
        ("智能手机", "电子产品", 3999.00, "日常使用手机"),
        ("冬季外套", "服饰", 899.00, "保暖冬季外套"),
        ("书籍", "教育", 299.00, "学习资料"),
        ("厨房用具", "家居", 599.00, "厨房必备工具"),
    ]
    
    for user in users:
        for i, (name, category, price, description) in enumerate(items_data[:3]):  # 3 items per user
            owned_item = OwnedItem(
                user_id=user.id,
                name=name,
                category=category,
                price=price,
                description=description,
                purchase_date=datetime.now() - timedelta(days=30 + i*10),
                usage_frequency=f"{i+1}次/周",
                satisfaction_level=80 - i*10,
                created_at=datetime.now() - timedelta(days=30 + i*10),
                updated_at=datetime.now() - timedelta(days=30 + i*10)
            )
            owned_items.append(owned_item)
            db.add(owned_item)
    
    db.commit()
    print(f"Created {len(owned_items)} sample owned items")
    return owned_items


def main():
    """Main function to seed the database"""
    print("Starting database seeding...")
    
    # Create database engine and session
    engine = create_engine("sqlite:///./don_t_buy_yet.db")
    SessionLocal = SessionLocal
    
    # Create all tables
    Base.metadata.create_all(bind=engine)
    
    # Create session
    db = SessionLocal()
    
    try:
        # Create sample data
        users = create_sample_users(db)
        products = create_sample_products(db, users)
        questionnaires = create_sample_questionnaires(db, products)
        analysis_results = create_sample_analysis_results(db, products, users)
        cooling_items = create_sample_cooling_items(db, products, analysis_results)
        purchase_reviews = create_sample_purchase_reviews(db, products, cooling_items)
        owned_items = create_sample_owned_items(db, users)
        
        print("\n" + "="*50)
        print("Database seeding completed successfully!")
        print("="*50)
        print(f"Total users created: {len(users)}")
        print(f"Total products created: {len(products)}")
        print(f"Total questionnaires created: {len(questionnaires)}")
        print(f"Total analysis results created: {len(analysis_results)}")
        print(f"Total cooling items created: {len(cooling_items)}")
        print(f"Total purchase reviews created: {len(purchase_reviews)}")
        print(f"Total owned items created: {len(owned_items)}")
        print("="*50)
        
    except Exception as e:
        print(f"Error during seeding: {e}")
        db.rollback()
        raise
    finally:
        db.close()


if __name__ == "__main__":
    main()