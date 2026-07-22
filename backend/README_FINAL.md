# Don't Buy Yet - Backend Application

A comprehensive FastAPI backend for managing purchase decisions, cooling-off periods, and purchase reviews. This application helps users make better buying decisions by providing analysis, scoring, and tracking tools.

## 🚀 Quick Start

### Prerequisites
- Python 3.8+
- pip (Python package manager)

### Installation

1. **Clone and navigate to the project:**
   ```bash
   cd backend
   ```

2. **Install dependencies:**
   ```bash
   # Method 1: Using the installation script
   python install_deps.py
   
   # Method 2: Using requirements file
   pip install -r requirements_simple.txt
   
   # Method 3: Manual installation
   pip install fastapi uvicorn sqlalchemy pydantic pydantic-settings python-dotenv httpx greenlet alembic pytest
   ```

3. **Set up environment:**
   ```bash
   # Copy environment file
   cp .env.example .env
   
   # Or create a basic .env file
   echo "DATABASE_URL=sqlite:///./dontbuyyet.db" > .env
   echo "DEBUG=True" >> .env
   echo 'CORS_ORIGINS=["http://localhost:3000", "http://127.0.0.1:3000"]' >> .env
   ```

4. **Initialize database:**
   ```bash
   python -c "from app.db.init_db import init_db; init_db()"
   ```

5. **Seed sample data (optional):**
   ```bash
   python scripts/run_seed.py
   ```

6. **Start the server:**
   ```bash
   # Method 1: Using the start script
   python start_app.py
   
   # Method 2: Direct uvicorn command
   python run.py
   
   # Method 3: Manual start
   uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
   ```

7. **Access the application:**
   - **API Documentation:** http://localhost:8000/docs
   - **ReDoc Documentation:** http://localhost:8000/redoc
   - **Health Check:** http://localhost:8000/api/v1/health

## 📁 Project Structure

```
backend/
├── app/                          # Main application package
│   ├── api/                      # API endpoints
│   │   ├── endpoints/            # All endpoint modules
│   │   │   ├── health.py         # Health check endpoints
│   │   │   ├── user_profiles.py  # User profile management
│   │   │   ├── owned_items.py    # Owned items management
│   │   │   ├── products.py       # Product management
│   │   │   ├── questionnaires.py # Questionnaire management
│   │   │   ├── analysis.py       # Analysis results
│   │   │   ├── cooling_items.py  # Cooling-off items
│   │   │   ├── purchase_reviews.py # Purchase reviews
│   │   │   └── reports.py        # Reporting endpoints
│   │   └── deps.py               # Dependency injection
│   ├── core/                     # Core application logic
│   │   ├── config.py             # Configuration management
│   │   ├── exceptions.py         # Custom exceptions
│   │   └── error_handler.py      # Error handling middleware
│   ├── db/                       # Database layer
│   │   ├── base.py               # SQLAlchemy base models
│   │   ├── session.py            # Database session management
│   │   └── init_db.py            # Database initialization
│   ├── models/                   # SQLAlchemy models
│   │   ├── user_profile.py       # User profile model
│   │   ├── product.py            # Product model
│   │   ├── questionnaire.py      # Questionnaire model
│   │   ├── analysis_result.py    # Analysis result model
│   │   ├── cooling_item.py       # Cooling item model
│   │   ├── purchase_review.py    # Purchase review model
│   │   └── owned_item.py         # Owned item model
│   ├── schemas/                  # Pydantic schemas
│   │   ├── user_profile.py       # User profile schemas
│   │   ├── product.py            # Product schemas
│   │   ├── questionnaire.py      # Questionnaire schemas
│   │   ├── analysis_result.py    # Analysis result schemas
│   │   ├── cooling_item.py       # Cooling item schemas
│   │   ├── purchase_review.py    # Purchase review schemas
│   │   ├── owned_item.py         # Owned item schemas
│   │   ├── error.py              # Error response schemas
│   │   └── report.py             # Report schemas
│   ├── services/                 # Business logic services
│   │   ├── scoring_engine.py     # Purchase scoring engine
│   │   ├── reason_generator.py   # Reason generation service
│   │   └── llm_explainer.py      # LLM explanation service
│   └── main.py                   # FastAPI application instance
├── alembic/                      # Database migrations
│   ├── versions/                 # Migration versions
│   ├── env.py                    # Alembic environment
│   └── alembic.ini               # Alembic configuration
├── tests/                        # Test suite
│   ├── test_health.py            # Health endpoint tests
│   ├── test_user_profiles.py     # User profile tests
│   ├── test_products.py          # Product tests
│   └── conftest.py               # Test configuration
├── scripts/                      # Utility scripts
│   ├── seed_data.py              # Seed data generation
│   └── run_seed.py               # Seed data runner
├── requirements.txt              # Full requirements
├── requirements_simple.txt       # Simplified requirements
├── .env.example                  # Environment example
├── .env                          # Environment variables
├── run.py                        # Application runner
├── Dockerfile                    # Docker configuration
├── docker-compose.yml            # Docker Compose configuration
├── README.md                     # This file
├── demo.py                       # Demo script
├── start_app.py                  # Start script
├── install_deps.py               # Dependency installer
└── verify_structure.py           # Structure verification
```

## 🎯 Core Features

### 1. **User Management**
- Create, read, update, delete user profiles
- Track user preferences and purchase history

### 2. **Product Management**
- Add products with details (price, category, features)
- Product categorization and filtering
- Price tracking and comparison

### 3. **Purchase Decision Engine**
- **Scoring Engine**: Calculates purchase scores based on multiple factors
- **Reason Generator**: Provides reasons for/against purchases
- **LLM Integration**: AI-powered explanations (optional)

### 4. **Cooling-Off System**
- Track items in cooling-off period
- Set custom cooling durations
- Get reminders and notifications

### 5. **Questionnaire System**
- Dynamic questionnaires for purchase evaluation
- Customizable question sets
- Response analysis and scoring

### 6. **Analysis & Reporting**
- Generate purchase analysis reports
- Track decision outcomes
- Statistical insights and trends

### 7. **Purchase Reviews**
- Review completed purchases
- Rate decision quality
- Learn from past decisions

## 🔧 API Endpoints

### Health
- `GET /api/v1/health` - Health check endpoint

### User Profiles
- `GET /api/v1/users/` - List all users
- `POST /api/v1/users/` - Create new user
- `GET /api/v1/users/{user_id}` - Get user by ID
- `PUT /api/v1/users/{user_id}` - Update user
- `DELETE /api/v1/users/{user_id}` - Delete user

### Owned Items
- `GET /api/v1/owned-items/` - List owned items
- `POST /api/v1/owned-items/` - Create owned item
- `GET /api/v1/owned-items/{item_id}` - Get owned item by ID
- `PUT /api/v1/owned-items/{item_id}` - Update owned item
- `DELETE /api/v1/owned-items/{item_id}` - Delete owned item

### Products
- `GET /api/v1/products/` - List all products
- `POST /api/v1/products/` - Create new product
- `GET /api/v1/products/{product_id}` - Get product by ID
- `PUT /api/v1/products/{product_id}` - Update product
- `DELETE /api/v1/products/{product_id}` - Delete product

### Questionnaires
- `GET /api/v1/questionnaires/` - List questionnaires
- `POST /api/v1/questionnaires/` - Create questionnaire
- `GET /api/v1/questionnaires/{q_id}` - Get questionnaire by ID
- `PUT /api/v1/questionnaires/{q_id}` - Update questionnaire
- `DELETE /api/v1/questionnaires/{q_id}` - Delete questionnaire

### Analysis Results
- `GET /api/v1/analysis/` - List analysis results
- `POST /api/v1/analysis/` - Create analysis
- `GET /api/v1/analysis/{analysis_id}` - Get analysis by ID
- `PUT /api/v1/analysis/{analysis_id}` - Update analysis
- `DELETE /api/v1/analysis/{analysis_id}` - Delete analysis

### Cooling Items
- `GET /api/v1/cooling-items/` - List cooling items
- `POST /api/v1/cooling-items/` - Create cooling item
- `GET /api/v1/cooling-items/{item_id}` - Get cooling item by ID
- `PUT /api/v1/cooling-items/{item_id}` - Update cooling item
- `DELETE /api/v1/cooling-items/{item_id}` - Delete cooling item

### Purchase Reviews
- `GET /api/v1/purchase-reviews/` - List purchase reviews
- `POST /api/v1/purchase-reviews/` - Create purchase review
- `GET /api/v1/purchase-reviews/{review_id}` - Get purchase review by ID
- `PUT /api/v1/purchase-reviews/{review_id}` - Update purchase review
- `DELETE /api/v1/purchase-reviews/{review_id}` - Delete purchase review

### Reports
- `GET /api/v1/reports/` - Generate reports
- `POST /api/v1/reports/` - Create custom report

## ⚙️ Configuration

### Environment Variables
Create a `.env` file in the project root:

```env
# Database Configuration
DATABASE_URL=sqlite:///./dontbuyyet.db
# For PostgreSQL: postgresql://user:password@localhost/dontbuyyet

# Application Configuration
APP_NAME=Don't Buy Yet
APP_VERSION=1.0.0
DEBUG=True

# CORS Configuration
CORS_ORIGINS=["http://localhost:3000", "http://127.0.0.1:3000"]

# API Configuration
API_V1_STR=/api/v1

# LLM Configuration (optional)
LLM_API_KEY=your_api_key_here
LLM_BASE_URL=http://localhost:11434
LLM_MODEL=llama3.2
LLM_ENABLED=False

# Scoring Configuration
SCORING_WEIGHTS={"price": 0.3, "need": 0.4, "urgency": 0.3}
```

### Database Setup
The application supports SQLite (default) and PostgreSQL:

1. **SQLite (Default):**
   ```env
   DATABASE_URL=sqlite:///./dontbuyyet.db
   ```

2. **PostgreSQL:**
   ```env
   DATABASE_URL=postgresql://user:password@localhost/dontbuyyet
   ```

## 🐳 Docker Deployment

### Using Docker Compose
```bash
# Start all services
docker-compose up --build

# Start in background
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### Manual Docker Build
```bash
# Build the image
docker build -t dontbuyyet-backend .

# Run the container
docker run -p 8000:8000 dontbuyyet-backend

# Run with environment variables
docker run -p 8000:8000 \
  -e DATABASE_URL=postgresql://user:password@host/db \
  -e DEBUG=False \
  dontbuyyet-backend
```

## 🧪 Testing

Run the test suite:

```bash
# Run all tests
pytest tests/

# Run specific test file
pytest tests/test_health.py

# Run with verbose output
pytest tests/ -v

# Run with coverage
pytest tests/ --cov=app
```

## 📊 Database Migrations

The project uses Alembic for database migrations:

```bash
# Initialize migrations (first time)
alembic init alembic

# Create new migration
alembic revision --autogenerate -m "description"

# Apply migrations
alembic upgrade head

# Rollback migration
alembic downgrade -1

# Show migration history
alembic history
```

## 🔍 Development

### Code Structure Guidelines
- **Models**: SQLAlchemy ORM models in `app/models/`
- **Schemas**: Pydantic validation schemas in `app/schemas/`
- **Endpoints**: API route handlers in `app/api/endpoints/`
- **Services**: Business logic in `app/services/`
- **Core**: Configuration and utilities in `app/core/`

### Adding New Features
1. Create model in `app/models/`
2. Create schemas in `app/schemas/`
3. Add service logic in `app/services/`
4. Create endpoints in `app/api/endpoints/`
5. Add tests in `tests/`

### Error Handling
The application uses a centralized error handling system:
- Custom exceptions in `app/core/exceptions.py`
- Error handlers in `app/core/error_handler.py`
- Standardized error responses

## 🚀 Production Deployment

### Environment Setup
1. Set `DEBUG=False` in production
2. Use PostgreSQL in production
3. Configure proper CORS origins
4. Set up HTTPS with reverse proxy (Nginx/Apache)

### Performance Considerations
- Enable database connection pooling
- Implement caching (Redis)
- Use background tasks for long-running operations
- Monitor with application performance monitoring (APM)

### Security Best Practices
- Use environment variables for secrets
- Implement rate limiting
- Add request validation
- Use HTTPS in production
- Regular security updates

## 📈 Monitoring & Logging

### Built-in Monitoring
- Health check endpoint: `/api/v1/health`
- Automatic request logging
- Error tracking and reporting

### Adding Custom Logging
```python
import logging
from app.core.config import settings

logger = logging.getLogger(__name__)

def some_function():
    logger.info("Processing request")
    logger.error("Error occurred", exc_info=True)
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Run the test suite
6. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Built with [FastAPI](https://fastapi.tiangolo.com/)
- Database ORM with [SQLAlchemy](https://www.sqlalchemy.org/)
- Data validation with [Pydantic](https://docs.pydantic.dev/)
- Database migrations with [Alembic](https://alembic.sqlalchemy.org/)
- Testing with [pytest](https://docs.pytest.org/)

## 🆘 Support

For issues and questions:
1. Check the [API Documentation](http://localhost:8000/docs)
2. Review the [FAQ section](#)
3. Open an issue on GitHub
4. Contact the development team

---

**Happy Coding! 🎉**