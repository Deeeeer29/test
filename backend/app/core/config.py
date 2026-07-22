from typing import Optional
from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Application settings"""

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
    )
    
    # Database Configuration
    database_url: str = "sqlite:///./don_t_buy_yet.db"
    database_echo: bool = False
    
    # Model API Configuration
    model_api_base_url: str = "https://api.openai.com/v1"
    model_api_key: str = "your_api_key_here"
    model_name: str = "gpt-3.5-turbo"
    model_timeout_seconds: int = 30
    model_max_retries: int = 3
    
    # CORS Configuration
    cors_origins: str = "http://localhost:3000,http://127.0.0.1:3000,http://localhost:8000"
    cors_allow_credentials: bool = True
    cors_allow_methods: str = "GET,POST,PUT,DELETE,OPTIONS"
    cors_allow_headers: str = "*"
    
    # Security Configuration
    secret_key: str = "your-secret-key-here-change-in-production"
    algorithm: str = "HS256"
    access_token_expire_minutes: int = 30
    
    # Application Configuration
    debug: bool = True
    environment: str = "development"
    log_level: str = "DEBUG"
    host: str = "0.0.0.0"
    port: int = 8000
    workers: int = 4
    
    # Rate Limiting
    rate_limit_enabled: bool = False
    rate_limit_requests: int = 100
    rate_limit_period: int = 60
    
    # Cache Configuration
    cache_enabled: bool = False
    cache_ttl: int = 300
    
    # Email Configuration (optional)
    smtp_server: Optional[str] = None
    smtp_port: Optional[str] = None
    smtp_username: Optional[str] = None
    smtp_password: Optional[str] = None
    email_from: Optional[str] = None
    
    # File Upload Configuration
    max_upload_size: int = 10485760  # 10MB
    allowed_file_types: str = "image/jpeg,image/png,image/gif,application/pdf"
    
    # Application Specific
    default_cooling_hours: int = 24
    max_cooling_hours: int = 168  # 7 days
    min_purchase_amount: float = 0.01
    max_purchase_amount: float = 1000000.00
    
    # Application Configuration (additional)
    app_name: str = "Don't Buy Yet"
    app_version: str = "1.0.0"
    api_v1_str: str = "/api/v1"
    
    # LLM Configuration
    llm_api_key: str = ""
    llm_base_url: str = "http://localhost:11434"
    llm_model: str = "llama3.2"
    llm_enabled: bool = False
    
    # Scoring Configuration
    scoring_weights: dict = Field(default_factory=lambda: {"price": 0.3, "need": 0.4, "urgency": 0.3})
    
    # Monitoring
    sentry_dsn: Optional[str] = None
    prometheus_enabled: bool = False


# Global settings instance
settings = Settings()


def get_settings() -> Settings:
    """Get settings instance for dependency injection"""
    return settings


# Environment specific settings
def is_development() -> bool:
    """Check if running in development environment"""
    return settings.environment.lower() == "development"


def is_production() -> bool:
    """Check if running in production environment"""
    return settings.environment.lower() == "production"


def is_testing() -> bool:
    """Check if running in testing environment"""
    return settings.environment.lower() == "testing"


# Database configuration helpers
def get_database_config() -> dict:
    """Get database configuration dictionary"""
    return {
        "url": settings.database_url,
        "echo": settings.database_echo,
        "pool_pre_ping": True,
        "pool_recycle": 3600,
    }


# CORS configuration helpers
def get_cors_config() -> dict:
    """Get CORS configuration dictionary"""
    # Parse comma-separated strings into lists
    origins = [origin.strip() for origin in settings.cors_origins.split(",")] if settings.cors_origins else []
    methods = [method.strip() for method in settings.cors_allow_methods.split(",")] if settings.cors_allow_methods else []
    headers = [header.strip() for header in settings.cors_allow_headers.split(",")] if settings.cors_allow_headers else []
    
    return {
        "allow_origins": origins,
        "allow_credentials": settings.cors_allow_credentials,
        "allow_methods": methods,
        "allow_headers": headers,
    }


# Model API configuration helpers
def get_model_api_config() -> dict:
    """Get model API configuration dictionary"""
    return {
        "base_url": settings.model_api_base_url,
        "api_key": settings.model_api_key,
        "model_name": settings.model_name,
        "timeout_seconds": settings.model_timeout_seconds,
        "max_retries": settings.model_max_retries,
    }


# Security configuration helpers
def get_security_config() -> dict:
    """Get security configuration dictionary"""
    return {
        "secret_key": settings.secret_key,
        "algorithm": settings.algorithm,
        "access_token_expire_minutes": settings.access_token_expire_minutes,
    }
