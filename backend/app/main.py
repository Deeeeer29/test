from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api.endpoints import (
    health, user_profiles, owned_items, products, 
    questionnaires, analysis, cooling_items, purchase_reviews, reports
)
from app.core.error_handler import setup_exception_handlers
from app.core.config import settings, get_cors_config
from app.db.base import Base, engine
from app.models import *  # noqa: F401,F403


@asynccontextmanager
async def lifespan(app: FastAPI):
    Base.metadata.create_all(bind=engine)
    yield


# Create FastAPI application
app = FastAPI(
    title="消费决策辅助系统 API",
    description="基于大模型的消费决策辅助系统后端API",
    version="1.0.0",
    docs_url="/docs" if settings.debug else None,
    redoc_url="/redoc" if settings.debug else None,
    openapi_url="/openapi.json" if settings.debug else None,
    lifespan=lifespan,
)

# Setup CORS
cors_config = get_cors_config()
app.add_middleware(
    CORSMiddleware,
    allow_origins=cors_config["allow_origins"],
    allow_credentials=cors_config["allow_credentials"],
    allow_methods=cors_config["allow_methods"],
    allow_headers=cors_config["allow_headers"],
)

# Setup exception handlers
setup_exception_handlers(app)


# Include routers
app.include_router(health.router, prefix="/api/v1", tags=["health"])
app.include_router(user_profiles.router, prefix="/api/v1/user-profiles", tags=["user-profiles"])
app.include_router(owned_items.router, prefix="/api/v1/owned-items", tags=["owned-items"])
app.include_router(products.router, prefix="/api/v1/products", tags=["products"])
app.include_router(questionnaires.router, prefix="/api/v1/questionnaires", tags=["questionnaires"])
app.include_router(analysis.router, prefix="/api/v1/analysis", tags=["analysis"])
app.include_router(cooling_items.router, prefix="/api/v1/cooling-items", tags=["cooling-items"])
app.include_router(purchase_reviews.router, prefix="/api/v1/purchase-reviews", tags=["purchase-reviews"])
app.include_router(reports.router, prefix="/api/v1/reports", tags=["reports"])

# Root endpoint
@app.get("/")
async def root():
    return {
        "message": "消费决策辅助系统 API",
        "version": "1.0.0",
        "docs": "/docs",
        "health": "/api/v1/health"
    }
