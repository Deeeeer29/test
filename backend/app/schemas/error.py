from typing import Optional, Dict, Any, List, Union
from pydantic import BaseModel
from fastapi import status


class ErrorResponse(BaseModel):
    """Standard error response format"""
    code: str
    message: str
    details: Optional[Dict[str, Any]] = None


class ValidationErrorDetail(BaseModel):
    """Validation error detail"""
    field: str
    message: str
    type: str


class ValidationErrorResponse(ErrorResponse):
    """Validation error response with field details"""
    details: Dict[str, List[ValidationErrorDetail]] = {}  # type: ignore


class SuccessResponse(BaseModel):
    """Standard success response format"""
    success: bool = True
    message: Optional[str] = None
    data: Optional[Union[Dict[str, Any], List[Any], Any]] = None


class PaginatedResponse(BaseModel):
    """Paginated response format"""
    success: bool = True
    message: Optional[str] = None
    data: List[Any]
    pagination: Dict[str, Any]
    total: int
    page: int
    per_page: int


# Common error codes
class ErrorCodes:
    """Standard error codes for the application"""
    VALIDATION_ERROR = "VALIDATION_ERROR"
    NOT_FOUND = "NOT_FOUND"
    UNAUTHORIZED = "UNAUTHORIZED"
    FORBIDDEN = "FORBIDDEN"
    INTERNAL_ERROR = "INTERNAL_ERROR"
    BAD_REQUEST = "BAD_REQUEST"
    CONFLICT = "CONFLICT"
    SERVICE_UNAVAILABLE = "SERVICE_UNAVAILABLE"
    
    # Business specific error codes
    USER_NOT_FOUND = "USER_NOT_FOUND"
    PRODUCT_NOT_FOUND = "PRODUCT_NOT_FOUND"
    QUESTIONNAIRE_NOT_FOUND = "QUESTIONNAIRE_NOT_FOUND"
    ANALYSIS_NOT_FOUND = "ANALYSIS_NOT_FOUND"
    COOLING_ITEM_NOT_FOUND = "COOLING_ITEM_NOT_FOUND"
    PURCHASE_REVIEW_NOT_FOUND = "PURCHASE_REVIEW_NOT_FOUND"
    
    # Business logic errors
    INSUFFICIENT_BUDGET = "INSUFFICIENT_BUDGET"
    ITEM_ALREADY_IN_COOLING = "ITEM_ALREADY_IN_COOLING"
    COOLING_PERIOD_NOT_EXPIRED = "COOLING_PERIOD_NOT_EXPIRED"
    INVALID_RECOMMENDATION = "INVALID_RECOMMENDATION"
    ANALYSIS_ALREADY_EXISTS = "ANALYSIS_ALREADY_EXISTS"
    
    # External service errors
    LLM_SERVICE_UNAVAILABLE = "LLM_SERVICE_UNAVAILABLE"
    LLM_TIMEOUT = "LLM_TIMEOUT"
    LLM_INVALID_RESPONSE = "LLM_INVALID_RESPONSE"


# HTTP status code to error code mapping
ERROR_CODE_MAPPING = {
    status.HTTP_400_BAD_REQUEST: ErrorCodes.BAD_REQUEST,
    status.HTTP_401_UNAUTHORIZED: ErrorCodes.UNAUTHORIZED,
    status.HTTP_403_FORBIDDEN: ErrorCodes.FORBIDDEN,
    status.HTTP_404_NOT_FOUND: ErrorCodes.NOT_FOUND,
    status.HTTP_409_CONFLICT: ErrorCodes.CONFLICT,
    status.HTTP_422_UNPROCESSABLE_CONTENT: ErrorCodes.VALIDATION_ERROR,
    status.HTTP_500_INTERNAL_SERVER_ERROR: ErrorCodes.INTERNAL_ERROR,
    status.HTTP_503_SERVICE_UNAVAILABLE: ErrorCodes.SERVICE_UNAVAILABLE,
}