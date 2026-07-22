#!/usr/bin/env python3
"""
Initialize database by creating all tables.
"""

import sys
import os

# Add the current directory to the path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from app.db.base import Base, engine


def init_database():
    """Initialize the database by creating all tables."""
    print("Creating database tables...")
    
    try:
        # Create all tables
        Base.metadata.create_all(bind=engine)
        print("Database tables created successfully!")
        
        # Count tables
        from sqlalchemy import inspect
        inspector = inspect(engine)
        tables = inspector.get_table_names()
        print(f"Created {len(tables)} tables: {', '.join(tables)}")
        
    except Exception as e:
        print(f"Error creating database tables: {e}")
        sys.exit(1)


if __name__ == "__main__":
    init_database()