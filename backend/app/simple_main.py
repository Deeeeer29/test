#!/usr/bin/env python3
"""
Simplified main module for testing FastAPI app without SQLAlchemy imports.
"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import get_cors_config

# Create FastAPI application
app = FastAPI(
    title="Don't Buy Yet API",
    description="Backend API for Don't Buy Yet application",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
)

# Add CORS middleware
cors_config = get_cors_config()
app.add_middleware(
    CORSMiddleware,
    **cors_config
)

# Health check endpoint
@app.get("/")
async def root():
    return {
        "message": "Don't Buy Yet API",
        "version": "1.0.0",
        "status": "running"
    }

@app.get("/health")
async def health_check():
    return {
        "status": "healthy",
        "timestamp": "2024-01-01T00:00:00.000000",
        "version": "1.0.0"
    }

@app.get("/api/v1/health")
async def api_health_check():
    return {
        "status": "healthy",
        "service": "Don't Buy Yet API",
        "version": "1.0.0"
    }

if __name__ == "__main__":
    import uvicorn
    from app.core.config import settings
    
    print("🚀 Starting Don't Buy Yet API...")
    print(f"📝 Documentation: http://{settings.host}:{settings.port}/docs")
    print(f"🌐 Health check: http://{settings.host}:{settings.port}/health")
    print(f"🔧 Debug mode: {settings.debug}")
    
    uvicorn.run(
        "app.simple_main:app",
        host=settings.host,
        port=settings.port,
        reload=settings.debug,
        log_level="info"
    )