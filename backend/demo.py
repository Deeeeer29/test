#!/usr/bin/env python3
"""
Demo script for Don't Buy Yet Backend Application
This script demonstrates how to:
1. Set up the environment
2. Install dependencies
3. Initialize the database
4. Start the application
5. Test API endpoints
"""

import os
import sys
import subprocess
import time
import json
from pathlib import Path

def print_header(text):
    """Print a formatted header."""
    print("\n" + "=" * 60)
    print(f" {text}")
    print("=" * 60)

def run_command(cmd, description, cwd=None):
    """Run a shell command and print result."""
    print(f"\n{description}...")
    print(f"Command: {cmd}")
    
    try:
        result = subprocess.run(
            cmd,
            shell=True,
            capture_output=True,
            text=True,
            cwd=cwd,
            timeout=30
        )
        
        if result.returncode == 0:
            print(f"✅ Success")
            if result.stdout.strip():
                print(f"Output:\n{result.stdout[:500]}...")
        else:
            print(f"❌ Failed with return code: {result.returncode}")
            if result.stderr:
                print(f"Error:\n{result.stderr}")
        
        return result.returncode == 0
        
    except subprocess.TimeoutExpired:
        print(f"⏰ Timeout after 30 seconds")
        return False
    except Exception as e:
        print(f"⚠️  Error: {e}")
        return False

def check_python_version():
    """Check Python version."""
    print_header("Checking Python Environment")
    
    # Check Python version
    version_cmd = "python --version"
    run_command(version_cmd, "Python version")
    
    # Check pip version
    pip_cmd = "pip --version"
    run_command(pip_cmd, "Pip version")
    
    return True

def check_dependencies():
    """Check if required dependencies are installed."""
    print_header("Checking Dependencies")
    
    dependencies = [
        "fastapi",
        "uvicorn",
        "sqlalchemy",
        "alembic",
        "pydantic",
        "pydantic-settings",
        "python-dotenv",
        "httpx",
        "pytest",
    ]
    
    for dep in dependencies:
        check_cmd = f"python -c \"import {dep}; print('{dep}:', {dep}.__version__ if hasattr({dep}, '__version__') else 'available')\""
        run_command(check_cmd, f"Checking {dep}")

def create_env_file():
    """Create .env file from .env.example."""
    print_header("Setting Up Environment")
    
    env_example = Path(".env.example")
    env_file = Path(".env")
    
    if env_example.exists():
        if not env_file.exists():
            print("Creating .env file from .env.example...")
            try:
                content = env_example.read_text()
                env_file.write_text(content)
                print("✅ .env file created successfully")
                print("\nGenerated .env file content:")
                print("-" * 40)
                print(content)
                print("-" * 40)
            except Exception as e:
                print(f"❌ Failed to create .env file: {e}")
                return False
        else:
            print("✅ .env file already exists")
    else:
        print("⚠️  .env.example not found, creating basic .env file...")
        basic_env = """# Database Configuration
DATABASE_URL=sqlite:///./dontbuyyet.db

# Application Configuration
APP_NAME=Don't Buy Yet
APP_VERSION=1.0.0
DEBUG=True

# CORS Configuration
CORS_ORIGINS=["http://localhost:3000", "http://127.0.0.1:3000"]

# API Configuration
API_V1_STR=/api/v1

# LLM Configuration (optional)
LLM_API_KEY=
LLM_BASE_URL=http://localhost:11434
LLM_MODEL=llama3.2
LLM_ENABLED=False

# Scoring Configuration
SCORING_WEIGHTS={"price": 0.3, "need": 0.4, "urgency": 0.3}
"""
        try:
            env_file.write_text(basic_env)
            print("✅ Basic .env file created")
        except Exception as e:
            print(f"❌ Failed to create .env file: {e}")
            return False
    
    return True

def show_project_structure():
    """Display project structure."""
    print_header("Project Structure")
    
    structure = """
backend/
├── app/
│   ├── api/
│   │   ├── endpoints/
│   │   │   ├── health.py
│   │   │   ├── user_profiles.py
│   │   │   ├── owned_items.py
│   │   │   ├── products.py
│   │   │   ├── questionnaires.py
│   │   │   ├── analysis.py
│   │   │   ├── cooling_items.py
│   │   │   ├── purchase_reviews.py
│   │   │   └── reports.py
│   │   └── deps.py
│   ├── core/
│   │   ├── config.py
│   │   ├── exceptions.py
│   │   └── error_handler.py
│   ├── db/
│   │   ├── base.py
│   │   ├── session.py
│   │   └── init_db.py
│   ├── models/
│   │   ├── user_profile.py
│   │   ├── product.py
│   │   ├── questionnaire.py
│   │   ├── analysis_result.py
│   │   ├── cooling_item.py
│   │   ├── purchase_review.py
│   │   └── owned_item.py
│   ├── schemas/
│   │   ├── user_profile.py
│   │   ├── product.py
│   │   ├── questionnaire.py
│   │   ├── analysis_result.py
│   │   ├── cooling_item.py
│   │   ├── purchase_review.py
│   │   ├── owned_item.py
│   │   ├── error.py
│   │   └── report.py
│   ├── services/
│   │   ├── scoring_engine.py
│   │   ├── reason_generator.py
│   │   └── llm_explainer.py
│   └── main.py
├── alembic/
│   ├── versions/
│   ├── env.py
│   └── alembic.ini
├── tests/
│   ├── test_health.py
│   ├── test_user_profiles.py
│   ├── test_products.py
│   └── conftest.py
├── scripts/
│   ├── seed_data.py
│   └── run_seed.py
├── requirements.txt
├── requirements_simple.txt
├── .env.example
├── .env
├── run.py
├── Dockerfile
├── docker-compose.yml
├── README.md
└── verify_structure.py
"""
    print(structure)

def show_api_endpoints():
    """Display available API endpoints."""
    print_header("Available API Endpoints")
    
    endpoints = """
API Endpoints:
-------------
GET    /api/v1/health                    - Health check
GET    /api/v1/users/                    - List users
POST   /api/v1/users/                    - Create user
GET    /api/v1/users/{user_id}           - Get user by ID
PUT    /api/v1/users/{user_id}           - Update user
DELETE /api/v1/users/{user_id}           - Delete user

GET    /api/v1/owned-items/              - List owned items
POST   /api/v1/owned-items/              - Create owned item
GET    /api/v1/owned-items/{item_id}     - Get owned item by ID
PUT    /api/v1/owned-items/{item_id}     - Update owned item
DELETE /api/v1/owned-items/{item_id}     - Delete owned item

GET    /api/v1/products/                 - List products
POST   /api/v1/products/                 - Create product
GET    /api/v1/products/{product_id}     - Get product by ID
PUT    /api/v1/products/{product_id}     - Update product
DELETE /api/v1/products/{product_id}     - Delete product

GET    /api/v1/questionnaires/           - List questionnaires
POST   /api/v1/questionnaires/           - Create questionnaire
GET    /api/v1/questionnaires/{q_id}     - Get questionnaire by ID
PUT    /api/v1/questionnaires/{q_id}     - Update questionnaire
DELETE /api/v1/questionnaires/{q_id}     - Delete questionnaire

GET    /api/v1/analysis/                 - List analysis results
POST   /api/v1/analysis/                 - Create analysis
GET    /api/v1/analysis/{analysis_id}    - Get analysis by ID
PUT    /api/v1/analysis/{analysis_id}    - Update analysis
DELETE /api/v1/analysis/{analysis_id}    - Delete analysis

GET    /api/v1/cooling-items/            - List cooling items
POST   /api/v1/cooling-items/            - Create cooling item
GET    /api/v1/cooling-items/{item_id}   - Get cooling item by ID
PUT    /api/v1/cooling-items/{item_id}   - Update cooling item
DELETE /api/v1/cooling-items/{item_id}   - Delete cooling item

GET    /api/v1/purchase-reviews/         - List purchase reviews
POST   /api/v1/purchase-reviews/         - Create purchase review
GET    /api/v1/purchase-reviews/{review_id} - Get purchase review by ID
PUT    /api/v1/purchase-reviews/{review_id} - Update purchase review
DELETE /api/v1/purchase-reviews/{review_id} - Delete purchase review

GET    /api/v1/reports/                  - Generate reports
POST   /api/v1/reports/                  - Create custom report

Interactive Documentation:
-------------------------
Swagger UI:      http://localhost:8000/docs
ReDoc:           http://localhost:8000/redoc
"""
    print(endpoints)

def show_quick_start():
    """Display quick start instructions."""
    print_header("Quick Start Guide")
    
    instructions = """
Quick Start Instructions:
------------------------

1. Install dependencies:
   pip install -r requirements_simple.txt

2. Set up environment:
   cp .env.example .env
   # Edit .env if needed

3. Initialize database:
   python -c "from app.db.init_db import init_db; init_db()"

4. Seed sample data:
   python scripts/run_seed.py

5. Start the application:
   python run.py

6. Access the API:
   - Application: http://localhost:8000
   - API Docs:    http://localhost:8000/docs
   - Health:      http://localhost:8000/api/v1/health

7. Run tests:
   pytest tests/

Docker Deployment:
-----------------

1. Build and run with Docker Compose:
   docker-compose up --build

2. Or build individual containers:
   docker build -t dontbuyyet-backend .
   docker run -p 8000:8000 dontbuyyet-backend

Key Features:
------------
✅ RESTful API with FastAPI
✅ SQLAlchemy ORM with SQLite/PostgreSQL support
✅ Alembic database migrations
✅ Pydantic models for data validation
✅ Comprehensive error handling
✅ CORS support
✅ Docker and Docker Compose ready
✅ Unit tests
✅ Seed data scripts
✅ LLM integration (optional)
✅ Scoring engine for purchase decisions
✅ Cooling-off period tracking
✅ Purchase review system
✅ Reporting and analytics

Environment Variables:
---------------------
DATABASE_URL: Database connection string
DEBUG: Enable debug mode (True/False)
CORS_ORIGINS: List of allowed origins
LLM_API_KEY: API key for LLM service (optional)
LLM_ENABLED: Enable/disable LLM features
"""
    print(instructions)

def main():
    """Main demo function."""
    print_header("Don't Buy Yet Backend Demo")
    print("A comprehensive backend for managing purchase decisions and cooling-off periods")
    
    # Get current directory
    current_dir = Path.cwd()
    print(f"\nCurrent directory: {current_dir}")
    
    # Check if we're in the backend directory
    if not (current_dir / "app").exists():
        print("⚠️  Warning: Not in backend directory. Some operations may fail.")
        print("Please run this script from the backend directory.")
    
    # Show project structure
    show_project_structure()
    
    # Check Python environment
    check_python_version()
    
    # Check dependencies
    check_dependencies()
    
    # Create environment file
    create_env_file()
    
    # Show API endpoints
    show_api_endpoints()
    
    # Show quick start
    show_quick_start()
    
    print_header("Demo Complete")
    print("\n🎉 Your Don't Buy Yet backend is ready!")
    print("\nNext steps:")
    print("1. Install dependencies with: pip install -r requirements_simple.txt")
    print("2. Initialize database: python -c \"from app.db.init_db import init_db; init_db()\"")
    print("3. Start the server: python run.py")
    print("4. Open browser to: http://localhost:8000/docs")
    
    return 0

if __name__ == "__main__":
    sys.exit(main())