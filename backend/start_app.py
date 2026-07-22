#!/usr/bin/env python3
"""
Simple script to start the Don't Buy Yet backend application.
This script handles environment setup and starts the FastAPI server.
"""

import os
import sys
import subprocess
import time
from pathlib import Path

def setup_environment():
    """Set up the environment for the application."""
    print("Setting up environment...")
    
    # Check for .env file
    env_file = Path(".env")
    if not env_file.exists():
        print("Creating .env file from .env.example...")
        env_example = Path(".env.example")
        if env_example.exists():
            content = env_example.read_text()
            env_file.write_text(content)
            print("✅ .env file created")
        else:
            print("⚠️  .env.example not found, using default configuration")
            # Set minimal environment variables
            os.environ["DATABASE_URL"] = "sqlite:///./dontbuyyet.db"
            os.environ["DEBUG"] = "True"
            os.environ["CORS_ORIGINS"] = '["http://localhost:3000", "http://127.0.0.1:3000"]'
    
    # Check if database exists
    db_file = Path("dontbuyyet.db")
    if not db_file.exists():
        print("Database file not found. Initializing database...")
        try:
            # Try to initialize database
            import sys
            sys.path.insert(0, str(Path.cwd()))
            
            from app.db.init_db import init_db
            init_db()
            print("✅ Database initialized successfully")
        except Exception as e:
            print(f"⚠️  Could not initialize database: {e}")
            print("The application will still start, but database operations may fail.")
    
    print("✅ Environment setup complete")

def check_dependencies():
    """Check if required dependencies are installed."""
    print("\nChecking dependencies...")
    
    required_packages = [
        "fastapi",
        "uvicorn",
        "sqlalchemy",
        "pydantic",
        "pydantic-settings",
        "python-dotenv",
    ]
    
    missing_packages = []
    
    for package in required_packages:
        try:
            __import__(package)
            print(f"✅ {package}")
        except ImportError:
            missing_packages.append(package)
            print(f"❌ {package} (missing)")
    
    if missing_packages:
        print(f"\n⚠️  Missing packages: {', '.join(missing_packages)}")
        print("Please install them with: pip install " + " ".join(missing_packages))
        return False
    
    print("✅ All dependencies are installed")
    return True

def start_server():
    """Start the FastAPI server."""
    print("\nStarting FastAPI server...")
    
    # Set environment variables for development
    os.environ["PYTHONPATH"] = str(Path.cwd())
    
    # Start the server
    cmd = [
        sys.executable, "-m", "uvicorn",
        "app.main:app",
        "--host", "0.0.0.0",
        "--port", "8000",
        "--reload"
    ]
    
    print(f"Command: {' '.join(cmd)}")
    print("\n" + "=" * 60)
    print("🚀 Don't Buy Yet Backend Server Starting...")
    print("=" * 60)
    print("\nServer will be available at:")
    print("  • http://localhost:8000")
    print("  • http://127.0.0.1:8000")
    print("\nAPI Documentation:")
    print("  • Swagger UI: http://localhost:8000/docs")
    print("  • ReDoc:      http://localhost:8000/redoc")
    print("\nHealth Check:")
    print("  • http://localhost:8000/api/v1/health")
    print("\n" + "=" * 60)
    print("Press Ctrl+C to stop the server")
    print("=" * 60 + "\n")
    
    try:
        subprocess.run(cmd)
    except KeyboardInterrupt:
        print("\n\nServer stopped by user")
    except Exception as e:
        print(f"\nError starting server: {e}")
        return False
    
    return True

def main():
    """Main function."""
    print("=" * 60)
    print("Don't Buy Yet - Backend Application")
    print("=" * 60)
    
    # Change to script directory
    script_dir = Path(__file__).parent
    os.chdir(script_dir)
    print(f"Working directory: {script_dir}")
    
    # Check dependencies
    if not check_dependencies():
        print("\n⚠️  Some dependencies are missing.")
        print("Please install them and try again.")
        print("You can use: pip install -r requirements_simple.txt")
        return 1
    
    # Setup environment
    setup_environment()
    
    # Start server
    return start_server()

if __name__ == "__main__":
    sys.exit(main())