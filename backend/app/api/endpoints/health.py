from datetime import datetime

from fastapi import APIRouter, Depends
from sqlalchemy import text
from sqlalchemy.orm import Session

from app.db.base import get_db
from app.schemas.error import SuccessResponse

router = APIRouter()


@router.get("/health", response_model=SuccessResponse)
async def health_check(db: Session = Depends(get_db)):
    try:
        db.execute(text("SELECT 1"))
        return SuccessResponse(
            success=True,
            message="API service is healthy",
            data={
                "status": "healthy",
                "timestamp": datetime.now().isoformat(),
                "database": "connected",
            },
        )
    except Exception as exc:
        return SuccessResponse(
            success=False,
            message=f"Database connection failed: {exc}",
            data={
                "status": "unhealthy",
                "timestamp": datetime.now().isoformat(),
                "database": "disconnected",
            },
        )


@router.get("/version")
async def get_version():
    return {
        "name": "Don't Buy Yet API",
        "version": "1.0.0",
        "description": "Backend API for purchase decisions",
    }
