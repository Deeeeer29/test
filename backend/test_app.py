#!/usr/bin/env python3
"""
Simple script to verify that the FastAPI application can be imported and initialized.
"""

import sys
import os

# Add the current directory to the path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

def check_app_import():
    """Test that the application can be imported."""
    print("Testing application import...")
    
    try:
        # Try to import the main app
        from app.main import app
        print("✓ Successfully imported app from app.main")
        
        # Check that it's a FastAPI app
        from fastapi import FastAPI
        assert isinstance(app, FastAPI), "app is not a FastAPI instance"
        print("✓ app is a valid FastAPI instance")
        
        # Check routes
        routes = []
        for route in app.routes:
            if hasattr(route, "path"):
                routes.append(route.path)
        
        print(f"✓ Found {len(routes)} routes")
        print("  Some routes:", routes[:10])  # Print first 10 routes
        
        # Check that we have the expected routes
        expected_routes = ["/", "/api/v1/health", "/docs", "/openapi.json"]
        for expected in expected_routes:
            if expected in routes:
                print(f"✓ Found expected route: {expected}")
            else:
                print(f"✗ Missing expected route: {expected}")
        
        return True
        
    except ImportError as e:
        print(f"✗ Import error: {e}")
        return False
    except Exception as e:
        print(f"✗ Error: {e}")
        return False

def check_config_import():
    """Test that configuration can be imported."""
    print("\nTesting configuration import...")
    
    try:
        from app.core.config import settings
        print("✓ Successfully imported settings")
        
        # Check some settings
        print(f"  Database URL: {settings.database_url}")
        print(f"  Debug mode: {settings.debug}")
        print(f"  Environment: {settings.environment}")
        
        return True
        
    except ImportError as e:
        print(f"✗ Import error: {e}")
        return False
    except Exception as e:
        print(f"✗ Error: {e}")
        return False

def check_db_import():
    """Test that database modules can be imported."""
    print("\nTesting database import...")
    
    try:
        from app.db.base import Base, engine, SessionLocal
        print("✓ Successfully imported database modules")
        
        from app.db.session import get_db, get_db_session
        print("✓ Successfully imported session modules")
        
        return True
        
    except ImportError as e:
        print(f"✗ Import error: {e}")
        return False
    except Exception as e:
        print(f"✗ Error: {e}")
        return False

def check_models_import():
    """Test that models can be imported."""
    print("\nTesting models import...")
    
    models_to_test = [
        "app.models.user_profile",
        "app.models.product",
        "app.models.questionnaire",
        "app.models.analysis_result",
        "app.models.cooling_item",
        "app.models.purchase_review",
        "app.models.owned_item",
    ]
    
    all_success = True
    for model_path in models_to_test:
        try:
            __import__(model_path)
            print(f"✓ Successfully imported {model_path}")
        except ImportError as e:
            print(f"✗ Failed to import {model_path}: {e}")
            all_success = False
    
    return all_success

def check_services_import():
    """Test that services can be imported."""
    print("\nTesting services import...")
    
    services_to_test = [
        "app.services.scoring_engine",
        "app.services.reason_generator",
        "app.services.llm_explainer",
    ]
    
    all_success = True
    for service_path in services_to_test:
        try:
            __import__(service_path)
            print(f"✓ Successfully imported {service_path}")
        except ImportError as e:
            print(f"✗ Failed to import {service_path}: {e}")
            all_success = False
    
    return all_success

def check_api_endpoints_import():
    """Test that API endpoints can be imported."""
    print("\nTesting API endpoints import...")
    
    endpoints_to_test = [
        "app.api.endpoints.health",
        "app.api.endpoints.user_profiles",
        "app.api.endpoints.owned_items",
        "app.api.endpoints.products",
        "app.api.endpoints.questionnaires",
        "app.api.endpoints.analysis",
        "app.api.endpoints.cooling_items",
        "app.api.endpoints.purchase_reviews",
        "app.api.endpoints.reports",
    ]
    
    all_success = True
    for endpoint_path in endpoints_to_test:
        try:
            __import__(endpoint_path)
            print(f"✓ Successfully imported {endpoint_path}")
        except ImportError as e:
            print(f"✗ Failed to import {endpoint_path}: {e}")
            all_success = False
    
    return all_success

def main():
    """Run all tests."""
    print("=" * 60)
    print("Testing Don't Buy Yet Backend Application")
    print("=" * 60)
    
    tests = [
        ("App Import", check_app_import),
        ("Config Import", check_config_import),
        ("Database Import", check_db_import),
        ("Models Import", check_models_import),
        ("Services Import", check_services_import),
        ("API Endpoints Import", check_api_endpoints_import),
    ]
    
    results = []
    for test_name, test_func in tests:
        print(f"\n{'='*40}")
        print(f"Test: {test_name}")
        print(f"{'='*40}")
        success = test_func()
        results.append((test_name, success))
    
    print(f"\n{'='*60}")
    print("Test Results Summary")
    print(f"{'='*60}")
    
    all_passed = True
    for test_name, success in results:
        status = "PASS" if success else "FAIL"
        print(f"{test_name:30} [{status}]")
        if not success:
            all_passed = False
    
    print(f"\nOverall: {'ALL TESTS PASSED' if all_passed else 'SOME TESTS FAILED'}")
    
    if all_passed:
        print("\nApplication structure is valid and ready to run!")
        print("\nTo start the application:")
        print("  python run.py")
        print("\nOr using uvicorn directly:")
        print("  uvicorn app.main:app --reload --host 0.0.0.0 --port 8000")
    else:
        print("\nSome tests failed. Please check the errors above.")
    
    return 0 if all_passed else 1

if __name__ == "__main__":
    sys.exit(main())


def test_app_import():
    assert check_app_import()


def test_config_import():
    assert check_config_import()


def test_db_import():
    assert check_db_import()


def test_models_import():
    assert check_models_import()


def test_services_import():
    assert check_services_import()


def test_api_endpoints_import():
    assert check_api_endpoints_import()
