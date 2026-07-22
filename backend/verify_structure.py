#!/usr/bin/env python3
"""
Verify the project structure without importing problematic modules.
"""

import os
import sys

def check_file_exists(path, description):
    """Check if a file exists."""
    if os.path.exists(path):
        print(f"✓ {description}: {path}")
        return True
    else:
        print(f"✗ {description}: {path} (NOT FOUND)")
        return False

def check_directory_exists(path, description):
    """Check if a directory exists."""
    if os.path.exists(path) and os.path.isdir(path):
        print(f"✓ {description}: {path}")
        return True
    else:
        print(f"✗ {description}: {path} (NOT FOUND)")
        return False

def count_files_in_dir(path, pattern="*.py"):
    """Count files matching pattern in directory."""
    if not os.path.exists(path):
        return 0
    
    count = 0
    for root, dirs, files in os.walk(path):
        for file in files:
            if file.endswith('.py'):
                count += 1
    return count

def main():
    """Check project structure."""
    print("=" * 60)
    print("Verifying Don't Buy Yet Backend Project Structure")
    print("=" * 60)
    
    base_dir = os.path.dirname(os.path.abspath(__file__))
    
    # Check essential files
    print("\nEssential Files:")
    print("-" * 40)
    
    essential_files = [
        ("app/main.py", "Main application file"),
        ("requirements.txt", "Dependencies file"),
        (".env.example", "Environment variables template"),
        ("run.py", "Application runner"),
        ("Dockerfile", "Docker configuration"),
        ("docker-compose.yml", "Docker Compose configuration"),
        ("README.md", "Project documentation"),
    ]
    
    essential_ok = True
    for file_path, description in essential_files:
        full_path = os.path.join(base_dir, file_path)
        if not check_file_exists(full_path, description):
            essential_ok = False
    
    # Check directories
    print("\nDirectory Structure:")
    print("-" * 40)
    
    directories = [
        ("app", "Application source code"),
        ("app/api", "API layer"),
        ("app/api/endpoints", "API endpoints"),
        ("app/core", "Core modules"),
        ("app/db", "Database modules"),
        ("app/models", "Data models"),
        ("app/schemas", "Pydantic schemas"),
        ("app/services", "Business logic services"),
        ("alembic", "Database migrations"),
        ("alembic/versions", "Migration versions"),
        ("tests", "Test files"),
        ("scripts", "Utility scripts"),
    ]
    
    directories_ok = True
    for dir_path, description in directories:
        full_path = os.path.join(base_dir, dir_path)
        if not check_directory_exists(full_path, description):
            directories_ok = False
    
    # Count files in key directories
    print("\nFile Counts:")
    print("-" * 40)
    
    key_dirs = [
        ("app/api/endpoints", "API endpoint files"),
        ("app/models", "Model files"),
        ("app/schemas", "Schema files"),
        ("app/services", "Service files"),
        ("tests", "Test files"),
    ]
    
    for dir_path, description in key_dirs:
        full_path = os.path.join(base_dir, dir_path)
        count = count_files_in_dir(full_path)
        print(f"  {description}: {count} files")
    
    # Check API endpoints
    print("\nAPI Endpoints:")
    print("-" * 40)
    
    endpoint_files = [
        "health.py",
        "user_profiles.py", 
        "owned_items.py",
        "products.py",
        "questionnaires.py",
        "analysis.py",
        "cooling_items.py",
        "purchase_reviews.py",
        "reports.py",
    ]
    
    endpoints_dir = os.path.join(base_dir, "app/api/endpoints")
    for endpoint in endpoint_files:
        file_path = os.path.join(endpoints_dir, endpoint)
        if os.path.exists(file_path):
            print(f"✓ {endpoint}")
        else:
            print(f"✗ {endpoint} (MISSING)")
    
    # Check models
    print("\nData Models:")
    print("-" * 40)
    
    model_files = [
        "user_profile.py",
        "product.py",
        "questionnaire.py",
        "analysis_result.py",
        "cooling_item.py",
        "purchase_review.py",
        "owned_item.py",
    ]
    
    models_dir = os.path.join(base_dir, "app/models")
    for model in model_files:
        file_path = os.path.join(models_dir, model)
        if os.path.exists(file_path):
            print(f"✓ {model}")
        else:
            print(f"✗ {model} (MISSING)")
    
    # Check schemas
    print("\nPydantic Schemas:")
    print("-" * 40)
    
    schema_files = [
        "user_profile.py",
        "product.py",
        "questionnaire.py",
        "analysis_result.py",
        "cooling_item.py",
        "purchase_review.py",
        "owned_item.py",
        "error.py",
        "report.py",
    ]
    
    schemas_dir = os.path.join(base_dir, "app/schemas")
    for schema in schema_files:
        file_path = os.path.join(schemas_dir, schema)
        if os.path.exists(file_path):
            print(f"✓ {schema}")
        else:
            print(f"✗ {schema} (MISSING)")
    
    # Check services
    print("\nBusiness Services:")
    print("-" * 40)
    
    service_files = [
        "scoring_engine.py",
        "reason_generator.py",
        "llm_explainer.py",
    ]
    
    services_dir = os.path.join(base_dir, "app/services")
    for service in service_files:
        file_path = os.path.join(services_dir, service)
        if os.path.exists(file_path):
            print(f"✓ {service}")
        else:
            print(f"✗ {service} (MISSING)")
    
    # Summary
    print("\n" + "=" * 60)
    print("Project Structure Verification Complete")
    print("=" * 60)
    
    if essential_ok and directories_ok:
        print("\n✅ Project structure looks good!")
        print("\nNext steps:")
        print("1. Install dependencies: pip install -r requirements.txt")
        print("2. Set up environment: cp .env.example .env")
        print("3. Initialize database: python init_db.py")
        print("4. Run the application: python run.py")
        print("\nThe application should be available at: http://localhost:8000")
        print("API documentation: http://localhost:8000/docs")
    else:
        print("\n⚠️  Some issues found in project structure.")
        print("Please check the missing files/directories above.")
    
    return 0 if essential_ok and directories_ok else 1

if __name__ == "__main__":
    sys.exit(main())