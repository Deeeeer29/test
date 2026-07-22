"""
Tests for products endpoints.
"""

import pytest


def test_create_product(test_client, create_test_user, test_product_data):
    """Test creating a new product."""
    user = create_test_user
    product_data = test_product_data.copy()
    product_data["user_id"] = user.id
    
    response = test_client.post("/api/v1/products", json=product_data)
    
    assert response.status_code == 200
    data = response.json()
    
    assert data["success"] is True
    assert "data" in data
    product_response = data["data"]
    
    # Check response data
    assert product_response["name"] == product_data["name"]
    assert product_response["price"] == product_data["price"]
    assert product_response["category"] == product_data["category"]
    assert product_response["description"] == product_data["description"]
    assert product_response["purchase_urgency"] == product_data["purchase_urgency"]
    assert product_response["user_id"] == user.id
    assert "id" in product_response
    assert "created_at" in product_response
    assert "updated_at" in product_response


def test_create_product_invalid_user(test_client, test_product_data):
    """Test creating a product with invalid user ID."""
    product_data = test_product_data.copy()
    product_data["user_id"] = 99999  # Non-existent user
    
    response = test_client.post("/api/v1/products", json=product_data)
    
    assert response.status_code == 404
    data = response.json()
    
    assert data["success"] is False
    assert "error" in data
    assert "User with ID 99999 not found" in data["error"]["message"]


def test_create_product_invalid_data(test_client, create_test_user):
    """Test creating a product with invalid data."""
    user = create_test_user
    
    invalid_data = {
        "user_id": user.id,
        "name": "",  # Empty name
        "price": -100.00,  # Negative price
        "category": "",  # Empty category
        "purchase_urgency": 10  # Out of range (1-5)
    }
    
    response = test_client.post("/api/v1/products", json=invalid_data)
    
    assert response.status_code == 422
    data = response.json()
    
    assert "detail" in data
    assert len(data["detail"]) > 0


def test_get_product(test_client, create_test_product):
    """Test getting a product by ID."""
    product = create_test_product
    
    response = test_client.get(f"/api/v1/products/{product.id}")
    
    assert response.status_code == 200
    data = response.json()
    
    assert data["success"] is True
    assert "data" in data
    product_response = data["data"]
    
    assert product_response["id"] == product.id
    assert product_response["name"] == product.name
    assert product_response["price"] == product.price
    assert product_response["category"] == product.category
    assert product_response["user_id"] == product.user_id


def test_get_nonexistent_product(test_client):
    """Test getting a product that doesn't exist."""
    response = test_client.get("/api/v1/products/99999")
    
    assert response.status_code == 404
    data = response.json()
    
    assert data["success"] is False
    assert "error" in data
    assert "Product with ID 99999 not found" in data["error"]["message"]


def test_get_user_products(test_client, create_test_product):
    """Test getting products for a specific user."""
    product = create_test_product
    user_id = product.user_id
    
    response = test_client.get(f"/api/v1/products/user/{user_id}")
    
    assert response.status_code == 200
    data = response.json()
    
    assert data["success"] is True
    assert "data" in data
    assert isinstance(data["data"], list)
    
    # Should have at least the created product
    assert len(data["data"]) >= 1
    
    # Check that our product is in the list
    product_ids = [p["id"] for p in data["data"]]
    assert product.id in product_ids


def test_get_products_by_nonexistent_user(test_client):
    """Test getting products for a user that doesn't exist."""
    response = test_client.get("/api/v1/products/user/99999")
    
    assert response.status_code == 200
    data = response.json()
    
    assert data["success"] is True
    assert "data" in data
    assert isinstance(data["data"], list)
    assert len(data["data"]) == 0  # Should return empty list, not error


def test_update_product(test_client, create_test_product):
    """Test updating a product."""
    product = create_test_product
    
    update_data = {
        "name": "更新后的商品名",
        "price": 799.99,
        "category": "更新后的类别",
        "description": "更新后的描述",
        "purchase_urgency": 4
    }
    
    response = test_client.put(f"/api/v1/products/{product.id}", json=update_data)
    
    assert response.status_code == 200
    data = response.json()
    
    assert data["success"] is True
    assert "data" in data
    updated_product = data["data"]
    
    # Check updated fields
    assert updated_product["name"] == update_data["name"]
    assert updated_product["price"] == update_data["price"]
    assert updated_product["category"] == update_data["category"]
    assert updated_product["description"] == update_data["description"]
    assert updated_product["purchase_urgency"] == update_data["purchase_urgency"]
    
    # Check that user_id remains unchanged
    assert updated_product["user_id"] == product.user_id


def test_update_nonexistent_product(test_client):
    """Test updating a product that doesn't exist."""
    update_data = {
        "name": "不存在的商品",
        "price": 100.00
    }
    
    response = test_client.put("/api/v1/products/99999", json=update_data)
    
    assert response.status_code == 404
    data = response.json()
    
    assert data["success"] is False
    assert "error" in data
    assert "Product with ID 99999 not found" in data["error"]["message"]


def test_delete_product(test_client, create_test_product):
    """Test deleting a product."""
    product = create_test_product
    
    # First, delete the product
    response = test_client.delete(f"/api/v1/products/{product.id}")
    
    assert response.status_code == 200
    data = response.json()
    
    assert data["success"] is True
    assert data["message"] == "Product deleted successfully"
    
    # Then, try to get the deleted product
    response = test_client.get(f"/api/v1/products/{product.id}")
    
    assert response.status_code == 404
    data = response.json()
    
    assert data["success"] is False
    assert "Product with ID" in data["error"]["message"]


def test_delete_nonexistent_product(test_client):
    """Test deleting a product that doesn't exist."""
    response = test_client.delete("/api/v1/products/99999")
    
    assert response.status_code == 404
    data = response.json()
    
    assert data["success"] is False
    assert "error" in data
    assert "Product with ID 99999 not found" in data["error"]["message"]


def test_product_search(test_client, create_test_product):
    """Test searching products."""
    product = create_test_product
    
    # Search by name
    response = test_client.get(f"/api/v1/products?search={product.name}")
    
    assert response.status_code == 200
    data = response.json()
    
    assert data["success"] is True
    assert "data" in data
    assert isinstance(data["data"], list)
    
    # Should find our product
    found = any(p["id"] == product.id for p in data["data"])
    assert found, f"Product with name '{product.name}' should be found"
    
    # Search by category
    response = test_client.get(f"/api/v1/products?category={product.category}")
    
    assert response.status_code == 200
    data = response.json()
    
    assert data["success"] is True
    assert "data" in data
    
    # Should find our product
    found = any(p["id"] == product.id for p in data["data"])
    assert found, f"Product with category '{product.category}' should be found"


def test_product_filtering(test_client, create_test_product):
    """Test filtering products."""
    product = create_test_product
    
    # Filter by price range
    min_price = product.price - 100
    max_price = product.price + 100
    
    response = test_client.get(
        f"/api/v1/products?min_price={min_price}&max_price={max_price}"
    )
    
    assert response.status_code == 200
    data = response.json()
    
    assert data["success"] is True
    assert "data" in data
    
    # Should find our product within price range
    found = any(
        p["id"] == product.id and min_price <= p["price"] <= max_price
        for p in data["data"]
    )
    assert found, f"Product with price {product.price} should be within range {min_price}-{max_price}"
    
    # Filter by purchase urgency
    response = test_client.get(f"/api/v1/products?purchase_urgency={product.purchase_urgency}")
    
    assert response.status_code == 200
    data = response.json()
    
    assert data["success"] is True
    assert "data" in data
    
    # Should find our product with matching urgency
    found = any(
        p["id"] == product.id and p["purchase_urgency"] == product.purchase_urgency
        for p in data["data"]
    )
    assert found, f"Product with urgency {product.purchase_urgency} should be found"


def test_product_pagination(test_client, create_test_user):
    """Test product pagination."""
    user = create_test_user
    
    # Create multiple products
    products = []
    for i in range(15):
        product_data = {
            "user_id": user.id,
            "name": f"Test Product {i}",
            "price": 100.00 + i * 10,
            "category": "Test Category",
            "description": f"Test Description {i}",
            "purchase_urgency": (i % 5) + 1
        }
        
        response = test_client.post("/api/v1/products", json=product_data)
        assert response.status_code == 200
        products.append(response.json()["data"])
    
    # Test with default pagination
    response = test_client.get("/api/v1/products")
    
    assert response.status_code == 200
    data = response.json()
    
    assert data["success"] is True
    assert "data" in data
    assert "pagination" in data
    assert "total" in data
    
    # Test with custom pagination
    response = test_client.get("/api/v1/products?skip=5&limit=5")
    
    assert response.status_code == 200
    data = response.json()
    
    assert data["success"] is True
    assert "data" in data
    assert len(data["data"]) <= 5  # Should have at most 5 items
    assert "pagination" in data
    assert data["pagination"]["skip"] == 5
    assert data["pagination"]["limit"] == 5