from sqlalchemy import Column, Integer, String, Float, DateTime, Enum
from sqlalchemy.sql import func
import enum

from app.db.base import Base


class PersonalityType(str, enum.Enum):
    GENTLE = "gentle"
    SHARP = "sharp"
    ACCOUNTANT = "accountant"
    REVERSE_SALES = "reverse_sales"
    RATIONAL = "rational"
    FRUGAL = "frugal"


class UserProfile(Base):
    __tablename__ = "user_profiles"

    id = Column(Integer, primary_key=True, index=True)
    nickname = Column(String(100), nullable=False)
    age = Column(Integer)
    gender = Column(String(20))
    monthly_disposable_budget = Column(Float, nullable=False, default=3000.0)
    current_month_spending = Column(Float, nullable=False, default=0.0)
    default_cooling_hours = Column(Integer, nullable=False, default=24)
    personality_type = Column(
        Enum(PersonalityType),
        nullable=False,
        default=PersonalityType.GENTLE
    )
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    @property
    def remaining_budget(self) -> float:
        """Calculate remaining budget for the month"""
        return max(0.0, self.monthly_disposable_budget - self.current_month_spending)
