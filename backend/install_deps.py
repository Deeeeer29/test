#!/usr/bin/env python3
"""
Install dependencies for Don't Buy Yet backend.
This script installs the required packages with error handling.
"""

import subprocess
import sys
import time
from pathlib import Path

def run_command(cmd, description):
    """Run a command and handle output."""
    print(f"\n{description}...")
    print(f"Command: {cmd}")
    
    try:
        result = subprocess.run(
            cmd,
            shell=True,
            capture_output=True,
            text=True,
            timeout=300  # 5 minutes timeout
        )
        
        if result.returncode == 0:
            print("✅ Success")
            if result.stdout.strip():
                print(f"Output: {result.stdout[:200]}...")
            return True
        else:
            print(f"❌ Failed with return code: {result.returncode}")
            if result.stderr:
                print(f"Error: {result.stderr[:500]}")
            return False
            
    except subprocess.TimeoutExpired:
        print("⏰ Timeout after 5 minutes")
        return False
    except Exception as e:
        print(f"⚠️  Error: {e}")
        return False

def check_pip_available():
    """Check if pip is available."""
    print("Checking pip availability...")
    return run_command("pip --version", "Check pip")

def upgrade_pip():
    """Upgrade pip to latest version."""
    print("\nUpgrading pip...")
    return run_command("python -m pip install --upgrade pip", "Upgrade pip")

def install_packages_individual():
    """Install packages one by one."""
    packages = [
        "fastapi==0.104.1",
        "uvicorn[standard]==0.24.0",
        "sqlalchemy==2.0.23",
        "pydantic==2.5.0",
        "pydantic-settings==2.1.0",
        "python-dotenv==1.0.0",
        "httpx==0.25.2",
        "greenlet==3.0.3",
        "alembic==1.12.1",
        "pytest==7.4.3",
    ]
    
    success_count = 0
    failed_packages = []
    
    for package in packages:
        if run_command(f"pip install {package}", f"Installing {package}"):
            success_count += 1
        else:
            failed_packages.append(package)
    
    return success_count, failed_packages

def install_from_requirements():
    """Install from requirements_simple.txt."""
    requirements_file = Path("requirements_simple.txt")
    if requirements_file.exists():
        print(f"\nFound {requirements_file}")
        return run_command(f"pip install -r {requirements_file}", "Install from requirements_simple.txt")
    return False

def verify_installation():
    """Verify that all packages are installed."""
    print("\n" + "=" * 60)
    print("Verifying installation...")
    print("=" * 60)
    
    packages_to_check = [
        "fastapi",
        "uvicorn",
        "sqlalchemy",
        "pydantic",
        "pydantic-settings",
        "python-dotenv",
        "httpx",
        "greenlet",
        "alembic",
        "pytest",
    ]
    
    all_installed = True
    for package in packages_to_check:
        try:
            __import__(package)
            print(f"✅ {package}")
        except ImportError:
            print(f"❌ {package}")
            all_installed = False
    
    return all_installed

def main():
    """Main installation function."""
    print("=" * 60)
    print("Don't Buy Yet - Dependency Installation")
    print("=" * 60)
    
    # Check pip
    if not check_pip_available():
        print("\n❌ pip is not available. Please install pip first.")
        return 1
    
    # Upgrade pip
    upgrade_pip()
    
    print("\n" + "=" * 60)
    print("Starting package installation...")
    print("=" * 60)
    
    # Try installing from requirements file first
    print("\nTrying to install from requirements_simple.txt...")
    if install_from_requirements():
        print("\n✅ Successfully installed from requirements_simple.txt")
    else:
        print("\n⚠️  Could not install from requirements_simple.txt")
        print("Trying individual package installation...")
        
        success_count, failed_packages = install_packages_individual()
        
        if failed_packages:
            print(f"\n⚠️  Failed to install {len(failed_packages)} packages:")
            for pkg in failed_packages:
                print(f"  - {pkg}")
            
            if success_count > 0:
                print(f"\n✅ Successfully installed {success_count} packages")
                print("You may need to manually install the failed packages.")
            else:
                print("\n❌ All installations failed")
                return 1
        else:
            print(f"\n✅ Successfully installed all {success_count} packages")
    
    # Verify installation
    print("\n" + "=" * 60)
    print("Final verification...")
    print("=" * 60)
    
    if verify_installation():
        print("\n🎉 All dependencies installed successfully!")
        print("\nNext steps:")
        print("1. Set up environment: cp .env.example .env")
        print("2. Initialize database: python -c \"from app.db.init_db import init_db; init_db()\"")
        print("3. Start the server: python run.py")
        print("4. Open browser to: http://localhost:8000/docs")
        return 0
    else:
        print("\n⚠️  Some packages are still missing.")
        print("Please try installing them manually:")
        print("pip install fastapi uvicorn sqlalchemy pydantic pydantic-settings python-dotenv httpx greenlet alembic pytest")
        return 1

if __name__ == "__main__":
    sys.exit(main())