"""
Tests for health check endpoints.
"""


def test_health_check(test_client):
    """Test health check endpoint."""
    response = test_client.get("/api/v1/health")
    
    assert response.status_code == 200
    data = response.json()
    
    assert data["success"] is True
    assert "message" in data
    assert "data" in data
    assert data["data"]["status"] == "healthy"
    assert "timestamp" in data["data"]
    assert "database" in data["data"]


def test_root_endpoint(test_client):
    """Test root endpoint."""
    response = test_client.get("/")
    
    assert response.status_code == 200
    data = response.json()
    
    assert "message" in data
    assert "version" in data
    assert "docs" in data
    assert "health" in data
    assert data["message"] == "消费决策辅助系统 API"


def test_api_docs_available(test_client):
    """Test that API documentation is available in development mode."""
    response = test_client.get("/docs")
    
    # Should return 200 OK with HTML content
    assert response.status_code == 200
    assert "text/html" in response.headers["content-type"]


def test_openapi_schema(test_client):
    """Test OpenAPI schema endpoint."""
    response = test_client.get("/openapi.json")
    
    assert response.status_code == 200
    data = response.json()
    
    assert "openapi" in data
    assert "info" in data
    assert "paths" in data
    assert "components" in data
    
    # Check API info
    assert data["info"]["title"] == "消费决策辅助系统 API"
    assert data["info"]["version"] == "1.0.0"
    
    # Check some expected paths
    assert "/api/v1/health" in data["paths"]
    assert "/api/v1/user-profiles" in data["paths"]
    assert "/api/v1/products" in data["paths"]