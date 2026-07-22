from typing import Any, Dict, Optional
from fastapi import HTTPException, status
from app.schemas.error import ErrorCodes, ErrorResponse


class AppException(Exception):
    """Base exception for application errors"""
    
    def __init__(
        self,
        message: str,
        code: str = ErrorCodes.INTERNAL_ERROR,
        status_code: int = status.HTTP_500_INTERNAL_SERVER_ERROR,
        details: Optional[Dict[str, Any]] = None
    ):
        self.message = message
        self.code = code
        self.status_code = status_code
        self.details = details or {}
        super().__init__(self.message)


class NotFoundException(AppException):
    """Resource not found exception"""
    
    def __init__(
        self,
        message: str,
        code: str = ErrorCodes.NOT_FOUND,
        details: Optional[Dict[str, Any]] = None
    ):
        super().__init__(
            message=message,
            code=code,
            status_code=status.HTTP_404_NOT_FOUND,
            details=details
        )


class ValidationException(AppException):
    """Validation error exception"""
    
    def __init__(
        self,
        message: str,
        code: str = ErrorCodes.VALIDATION_ERROR,
        details: Optional[Dict[str, Any]] = None
    ):
        super().__init__(
            message=message,
            code=code,
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            details=details
        )


class BusinessException(AppException):
    """Business logic exception"""
    
    def __init__(
        self,
        message: str,
        code: str = ErrorCodes.BAD_REQUEST,
        details: Optional[Dict[str, Any]] = None
    ):
        super().__init__(
            message=message,
            code=code,
            status_code=status.HTTP_400_BAD_REQUEST,
            details=details
        )


class UnauthorizedException(AppException):
    """Unauthorized access exception"""
    
    def __init__(
        self,
        message: str = "Unauthorized access",
        code: str = ErrorCodes.UNAUTHORIZED,
        details: Optional[Dict[str, Any]] = None
    ):
        super().__init__(
            message=message,
            code=code,
            status_code=status.HTTP_401_UNAUTHORIZED,
            details=details
        )


class ForbiddenException(AppException):
    """Forbidden access exception"""
    
    def __init__(
        self,
        message: str = "Forbidden access",
        code: str = ErrorCodes.FORBIDDEN,
        details: Optional[Dict[str, Any]] = None
    ):
        super().__init__(
            message=message,
            code=code,
            status_code=status.HTTP_403_FORBIDDEN,
            details=details
        )


class ConflictException(AppException):
    """Resource conflict exception"""
    
    def __init__(
        self,
        message: str,
        code: str = ErrorCodes.CONFLICT,
        details: Optional[Dict[str, Any]] = None
    ):
        super().__init__(
            message=message,
            code=code,
            status_code=status.HTTP_409_CONFLICT,
            details=details
        )


class ServiceUnavailableException(AppException):
    """External service unavailable exception"""
    
    def __init__(
        self,
        message: str,
        code: str = ErrorCodes.SERVICE_UNAVAILABLE,
        details: Optional[Dict[str, Any]] = None
    ):
        super().__init__(
            message=message,
            code=code,
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            details=details
        )


# Business specific exceptions
class UserNotFoundException(NotFoundException):
    """User not found exception"""
    
    def __init__(self, user_id: int):
        super().__init__(
            message=f"User with ID {user_id} not found",
            code=ErrorCodes.USER_NOT_FOUND,
            details={"user_id": user_id}
        )


class ProductNotFoundException(NotFoundException):
    """Product not found exception"""
    
    def __init__(self, product_id: int):
        super().__init__(
            message=f"Product with ID {product_id} not found",
            code=ErrorCodes.PRODUCT_NOT_FOUND,
            details={"product_id": product_id}
        )


class QuestionnaireNotFoundException(NotFoundException):
    """Questionnaire not found exception"""
    
    def __init__(self, questionnaire_id: int):
        super().__init__(
            message=f"Questionnaire with ID {questionnaire_id} not found",
            code=ErrorCodes.QUESTIONNAIRE_NOT_FOUND,
            details={"questionnaire_id": questionnaire_id}
        )


class AnalysisNotFoundException(NotFoundException):
    """Analysis not found exception"""
    
    def __init__(self, analysis_id: int):
        super().__init__(
            message=f"Analysis with ID {analysis_id} not found",
            code=ErrorCodes.ANALYSIS_NOT_FOUND,
            details={"analysis_id": analysis_id}
        )


class CoolingItemNotFoundException(NotFoundException):
    """Cooling item not found exception"""
    
    def __init__(self, cooling_item_id: int):
        super().__init__(
            message=f"Cooling item with ID {cooling_item_id} not found",
            code=ErrorCodes.COOLING_ITEM_NOT_FOUND,
            details={"cooling_item_id": cooling_item_id}
        )


class PurchaseReviewNotFoundException(NotFoundException):
    """Purchase review not found exception"""
    
    def __init__(self, review_id: int):
        super().__init__(
            message=f"Purchase review with ID {review_id} not found",
            code=ErrorCodes.PURCHASE_REVIEW_NOT_FOUND,
            details={"review_id": review_id}
        )


# Business logic exceptions
class InsufficientBudgetException(BusinessException):
    """Insufficient budget exception"""
    
    def __init__(self, user_id: int, required: float, available: float):
        super().__init__(
            message=f"Insufficient budget for user {user_id}. Required: {required}, Available: {available}",
            code=ErrorCodes.INSUFFICIENT_BUDGET,
            details={
                "user_id": user_id,
                "required_amount": required,
                "available_amount": available
            }
        )


class ItemAlreadyInCoolingException(BusinessException):
    """Item already in cooling pool exception"""
    
    def __init__(self, product_id: int, user_id: int):
        super().__init__(
            message=f"Product {product_id} is already in cooling pool for user {user_id}",
            code=ErrorCodes.ITEM_ALREADY_IN_COOLING,
            details={
                "product_id": product_id,
                "user_id": user_id
            }
        )


class CoolingPeriodNotExpiredException(BusinessException):
    """Cooling period not expired exception"""
    
    def __init__(self, cooling_item_id: int, remaining_hours: float):
        super().__init__(
            message=f"Cooling period for item {cooling_item_id} not expired. Remaining: {remaining_hours:.1f} hours",
            code=ErrorCodes.COOLING_PERIOD_NOT_EXPIRED,
            details={
                "cooling_item_id": cooling_item_id,
                "remaining_hours": remaining_hours
            }
        )


class InvalidRecommendationException(BusinessException):
    """Invalid recommendation exception"""
    
    def __init__(self, recommendation: str):
        super().__init__(
            message=f"Invalid recommendation: {recommendation}",
            code=ErrorCodes.INVALID_RECOMMENDATION,
            details={"recommendation": recommendation}
        )


class AnalysisAlreadyExistsException(ConflictException):
    """Analysis already exists exception"""
    
    def __init__(self, product_id: int, user_id: int):
        super().__init__(
            message=f"Analysis already exists for product {product_id} and user {user_id}",
            code=ErrorCodes.ANALYSIS_ALREADY_EXISTS,
            details={
                "product_id": product_id,
                "user_id": user_id
            }
        )


# External service exceptions
class LLMServiceUnavailableException(ServiceUnavailableException):
    """LLM service unavailable exception"""
    
    def __init__(self, service_name: str):
        super().__init__(
            message=f"LLM service '{service_name}' is currently unavailable",
            code=ErrorCodes.LLM_SERVICE_UNAVAILABLE,
            details={"service_name": service_name}
        )


class LLMTimeoutException(ServiceUnavailableException):
    """LLM timeout exception"""
    
    def __init__(self, service_name: str, timeout_seconds: int):
        super().__init__(
            message=f"LLM service '{service_name}' timed out after {timeout_seconds} seconds",
            code=ErrorCodes.LLM_TIMEOUT,
            details={
                "service_name": service_name,
                "timeout_seconds": timeout_seconds
            }
        )


class LLMInvalidResponseException(BusinessException):
    """LLM invalid response exception"""
    
    def __init__(self, service_name: str, response: str):
        super().__init__(
            message=f"LLM service '{service_name}' returned invalid response",
            code=ErrorCodes.LLM_INVALID_RESPONSE,
            details={
                "service_name": service_name,
                "response": response
            }
        )