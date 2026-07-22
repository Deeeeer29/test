#!/usr/bin/env python3
"""
Script to run database seeding.
"""

import sys
import os

# Add the parent directory to the path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

if __name__ == "__main__":
    print("Running database seeding...")
    
    try:
        from seed_data import main
        main()
        print("\nSeeding completed successfully!")
    except ImportError as e:
        print(f"Import error: {e}")
        print("Make sure you're running from the correct directory and all dependencies are installed.")
        sys.exit(1)
    except Exception as e:
        print(f"Error during seeding: {e}")
        sys.exit(1)