#!/usr/bin/env python3
"""
Application entry point for the consumption decision assistance system.
"""

import uvicorn
from app.core.config import settings


def main():
    """Main application entry point"""
    uvicorn.run(
        "app.main:app",
        host=settings.host,
        port=settings.port,
        reload=settings.debug,
        workers=settings.workers if not settings.debug else 1,
        log_level=settings.log_level.lower(),
        access_log=True if settings.debug else False,
    )


if __name__ == "__main__":
    main()