"""
Pytest configuration and fixtures for testing.
"""

import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool

from app.main import app
from app.db.base import Base, get_db
from app.core.config import settings


# Test database URL
TEST_DATABASE_URL = "sqlite:///:memory:"


@pytest.fixture(scope="session")
def test_engine():
    """Create test database engine."""
    engine = create_engine(
        TEST_DATABASE_URL,
        connect_args={"check_same_thread": False},
        poolclass=StaticPool,
    )
    
    # Start each test session from a clean schema.
    Base.metadata.drop_all(bind=engine)
    Base.metadata.create_all(bind=engine)
    
    yield engine
    
    # Clean up
    Base.metadata.drop_all(bind=engine)


@pytest.fixture(scope="function")
def test_session(test_engine):
    """Create a fresh database session for each test."""
    TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=test_engine)

    for table in reversed(Base.metadata.sorted_tables):
        with test_engine.begin() as connection:
            connection.execute(table.delete())
    
    session = TestingSessionLocal()
    try:
        yield session
    finally:
        session.close()
        for table in reversed(Base.metadata.sorted_tables):
            with test_engine.begin() as connection:
                connection.execute(table.delete())


@pytest.fixture(scope="function")
def test_client(test_session):
    """Create a test client with test database."""
    def override_get_db():
        try:
            yield test_session
        finally:
            pass
    
    # Override the get_db dependency
    app.dependency_overrides[get_db] = override_get_db
    
    with TestClient(app) as client:
        yield client
    
    # Clear overrides
    app.dependency_overrides.clear()


@pytest.fixture(scope="function")
def test_user_data():
    """Sample user data for testing."""
    return {
        "nickname": "测试用户",
        "age": 30,
        "gender": "male",
        "monthly_disposable_budget": 5000.00,
        "current_month_spending": 2500.00,
        "personality_type": "rational",
        "default_cooling_hours": 48
    }


@pytest.fixture(scope="function")
def test_product_data():
    """Sample product data for testing."""
    return {
        "name": "测试商品",
        "price": 999.99,
        "category": "电子产品",
        "description": "测试商品描述",
        "purchase_urgency": 3
    }


@pytest.fixture(scope="function")
def test_questionnaire_data():
    """Sample questionnaire data for testing."""
    return {
        "necessity_score": 4,
        "frequency_score": 3,
        "emotional_value_score": 2,
        "budget_fit_score": 5,
        "additional_notes": "测试问卷备注"
    }


@pytest.fixture(scope="function")
def test_cooling_item_data():
    """Sample cooling item data for testing."""
    return {
        "cooling_hours": 24,
        "notes": "测试冷静池备注"
    }


@pytest.fixture(scope="function")
def test_purchase_review_data():
    """Sample purchase review data for testing."""
    return {
        "actual_purchase_price": 899.99,
        "satisfaction_score": 85,
        "regret_score": 15,
        "is_idle": False,
        "review_notes": "测试购买评价"
    }


@pytest.fixture(scope="function")
def test_owned_item_data():
    """Sample owned item data for testing."""
    return {
        "name": "已有测试商品",
        "category": "电子产品",
        "price": 1999.99,
        "description": "已有测试商品描述",
        "purchase_date": "2024-01-15T10:30:00",
        "usage_frequency": "每周3次",
        "satisfaction_level": 80
    }


@pytest.fixture(scope="function")
def create_test_user(test_session, test_user_data):
    """Helper to create a test user."""
    from app.models.user_profile import UserProfile
    
    user = UserProfile(**test_user_data)
    test_session.add(user)
    test_session.commit()
    test_session.refresh(user)
    return user


@pytest.fixture(scope="function")
def create_test_product(test_session, create_test_user, test_product_data):
    """Helper to create a test product."""
    from app.models.product import Product
    
    user = create_test_user
    product_data = test_product_data.copy()
    product_data["user_id"] = user.id
    product = Product(**product_data)
    test_session.add(product)
    test_session.commit()
    test_session.refresh(product)
    return product


@pytest.fixture(scope="function")
def create_test_questionnaire(test_session, create_test_product, test_questionnaire_data):
    """Helper to create a test questionnaire."""
    from app.models.questionnaire import Questionnaire
    
    product = create_test_product
    questionnaire_data = test_questionnaire_data.copy()
    questionnaire_data["product_id"] = product.id
    questionnaire = Questionnaire(**questionnaire_data)
    test_session.add(questionnaire)
    test_session.commit()
    test_session.refresh(questionnaire)
    return questionnaire


@pytest.fixture(scope="function")
def create_test_analysis_result(test_session, create_test_product, create_test_user):
    """Helper to create a test analysis result."""
    from app.models.analysis_result import AnalysisResult, Recommendation
    
    product = create_test_product
    user = create_test_user
    
    analysis = AnalysisResult(
        product_id=product.id,
        user_id=user.id,
        decision_score=75.5,
        recommendation=Recommendation.BUY,
        reasoning="测试分析理由",
    )
    test_session.add(analysis)
    test_session.commit()
    test_session.refresh(analysis)
    return analysis


@pytest.fixture(scope="function")
def create_test_cooling_item(test_session, create_test_product, create_test_user, test_cooling_item_data):
    """Helper to create a test cooling item."""
    from app.models.cooling_item import CoolingItem, CoolingStatus
    from datetime import datetime, timedelta
    
    product = create_test_product
    user = create_test_user
    
    cooling_data = test_cooling_item_data.copy()
    cooling_data.update({
        "user_id": user.id,
        "product_id": product.id,
        "status": CoolingStatus.COOLING,
        "start_time": datetime.now(),
    })
    
    cooling_item = CoolingItem(**cooling_data)
    test_session.add(cooling_item)
    test_session.commit()
    test_session.refresh(cooling_item)
    return cooling_item


@pytest.fixture(scope="function")
def create_test_purchase_review(test_session, create_test_product, create_test_user, test_purchase_review_data):
    """Helper to create a test purchase review."""
    from app.models.purchase_review import PurchaseReview
    from datetime import datetime
    
    product = create_test_product
    user = create_test_user
    
    review_data = test_purchase_review_data.copy()
    review_data.update({
        "user_id": user.id,
        "product_id": product.id,
        "reviewed_at": datetime.now(),
    })
    
    review = PurchaseReview(**review_data)
    test_session.add(review)
    test_session.commit()
    test_session.refresh(review)
    return review


@pytest.fixture(scope="function")
def create_test_owned_item(test_session, create_test_user, test_owned_item_data):
    """Helper to create a test owned item."""
    from app.models.owned_item import OwnedItem
    from datetime import datetime
    
    user = create_test_user
    
    owned_data = test_owned_item_data.copy()
    owned_data.update({
        "user_id": user.id,
        "purchase_date": datetime.fromisoformat(test_owned_item_data["purchase_date"].replace("Z", "+00:00")),
    })
    
    owned_item = OwnedItem(**owned_data)
    test_session.add(owned_item)
    test_session.commit()
    test_session.refresh(owned_item)
    return owned_item
