"""
Tests for user profiles endpoints.
"""

import pytest


def test_create_user_profile(test_client, test_user_data):
    """Test creating a new user profile."""
    response = test_client.post("/api/v1/user-profiles", json=test_user_data)
    
    assert response.status_code == 200
    data = response.json()
    
    assert data["success"] is True
    assert "data" in data
    user_data = data["data"]
    
    # Check response data
    assert user_data["nickname"] == test_user_data["nickname"]
    assert user_data["age"] == test_user_data["age"]
    assert user_data["gender"] == test_user_data["gender"]
    assert user_data["monthly_disposable_budget"] == test_user_data["monthly_disposable_budget"]
    assert user_data["current_month_spending"] == test_user_data["current_month_spending"]
    assert user_data["personality_type"] == test_user_data["personality_type"]
    assert user_data["default_cooling_hours"] == test_user_data["default_cooling_hours"]
    assert "id" in user_data
    assert "created_at" in user_data
    assert "updated_at" in user_data


def test_create_user_profile_invalid_data(test_client):
    """Test creating a user profile with invalid data."""
    invalid_data = {
        "nickname": "",  # Empty nickname
        "age": -5,  # Negative age
        "gender": "unknown",  # Invalid gender
        "monthly_disposable_budget": -1000.00,  # Negative budget
        "personality_type": "invalid_type"  # Invalid personality type
    }
    
    response = test_client.post("/api/v1/user-profiles", json=invalid_data)
    
    # Should return 422 Unprocessable Entity
    assert response.status_code == 422
    data = response.json()
    
    assert "detail" in data
    assert data["detail"][0]["type"] == "value_error"


def test_get_user_profile(test_client, create_test_user):
    """Test getting a user profile by ID."""
    user = create_test_user
    
    response = test_client.get(f"/api/v1/user-profiles/{user.id}")
    
    assert response.status_code == 200
    data = response.json()
    
    assert data["success"] is True
    assert "data" in data
    user_data = data["data"]
    
    assert user_data["id"] == user.id
    assert user_data["nickname"] == user.nickname
    assert user_data["age"] == user.age
    assert user_data["gender"] == user.gender


def test_get_nonexistent_user_profile(test_client):
    """Test getting a user profile that doesn't exist."""
    response = test_client.get("/api/v1/user-profiles/99999")
    
    assert response.status_code == 404
    data = response.json()
    
    assert data["success"] is False
    assert "error" in data
    assert "User with ID 99999 not found" in data["error"]["message"]


def test_get_all_user_profiles(test_client, create_test_user):
    """Test getting all user profiles."""
    # Create multiple users
    user1 = create_test_user
    
    response = test_client.get("/api/v1/user-profiles")
    
    assert response.status_code == 200
    data = response.json()
    
    assert data["success"] is True
    assert "data" in data
    assert isinstance(data["data"], list)
    
    # Should have at least the created user
    assert len(data["data"]) >= 1
    
    # Check that our user is in the list
    user_ids = [user["id"] for user in data["data"]]
    assert user1.id in user_ids


def test_update_user_profile(test_client, create_test_user):
    """Test updating a user profile."""
    user = create_test_user
    
    update_data = {
        "nickname": "更新后的昵称",
        "age": 35,
        "monthly_disposable_budget": 6000.00,
        "personality_type": "frugal"
    }
    
    response = test_client.put(f"/api/v1/user-profiles/{user.id}", json=update_data)
    
    assert response.status_code == 200
    data = response.json()
    
    assert data["success"] is True
    assert "data" in data
    updated_user = data["data"]
    
    # Check updated fields
    assert updated_user["nickname"] == update_data["nickname"]
    assert updated_user["age"] == update_data["age"]
    assert updated_user["monthly_disposable_budget"] == update_data["monthly_disposable_budget"]
    assert updated_user["personality_type"] == update_data["personality_type"]
    
    # Check that other fields remain unchanged
    assert updated_user["gender"] == user.gender
    assert updated_user["default_cooling_hours"] == user.default_cooling_hours


def test_update_nonexistent_user_profile(test_client):
    """Test updating a user profile that doesn't exist."""
    update_data = {
        "nickname": "不存在的用户",
        "age": 30
    }
    
    response = test_client.put("/api/v1/user-profiles/99999", json=update_data)
    
    assert response.status_code == 404
    data = response.json()
    
    assert data["success"] is False
    assert "error" in data
    assert "User with ID 99999 not found" in data["error"]["message"]


def test_delete_user_profile(test_client, create_test_user):
    """Test deleting a user profile."""
    user = create_test_user
    
    # First, delete the user
    response = test_client.delete(f"/api/v1/user-profiles/{user.id}")
    
    assert response.status_code == 200
    data = response.json()
    
    assert data["success"] is True
    assert data["message"] == "User profile deleted successfully"
    
    # Then, try to get the deleted user
    response = test_client.get(f"/api/v1/user-profiles/{user.id}")
    
    assert response.status_code == 404
    data = response.json()
    
    assert data["success"] is False
    assert "User with ID" in data["error"]["message"]


def test_delete_nonexistent_user_profile(test_client):
    """Test deleting a user profile that doesn't exist."""
    response = test_client.delete("/api/v1/user-profiles/99999")
    
    assert response.status_code == 404
    data = response.json()
    
    assert data["success"] is False
    assert "error" in data
    assert "User with ID 99999 not found" in data["error"]["message"]


def test_user_profile_validation(test_client):
    """Test user profile validation with various edge cases."""
    test_cases = [
        {
            "data": {
                "nickname": "A" * 101,  # Too long nickname
                "age": 30,
                "gender": "male",
                "monthly_disposable_budget": 5000.00,
                "personality_type": "rational"
            },
            "expected_status": 422,
            "description": "Nickname too long"
        },
        {
            "data": {
                "nickname": "Valid Name",
                "age": 150,  # Too old
                "gender": "male",
                "monthly_disposable_budget": 5000.00,
                "personality_type": "rational"
            },
            "expected_status": 422,
            "description": "Age too high"
        },
        {
            "data": {
                "nickname": "Valid Name",
                "age": 30,
                "gender": "invalid_gender",  # Invalid gender
                "monthly_disposable_budget": 5000.00,
                "personality_type": "rational"
            },
            "expected_status": 422,
            "description": "Invalid gender"
        },
        {
            "data": {
                "nickname": "Valid Name",
                "age": 30,
                "gender": "male",
                "monthly_disposable_budget": -100.00,  # Negative budget
                "personality_type": "rational"
            },
            "expected_status": 422,
            "description": "Negative budget"
        },
        {
            "data": {
                "nickname": "Valid Name",
                "age": 30,
                "gender": "male",
                "monthly_disposable_budget": 5000.00,
                "personality_type": "invalid_type"  # Invalid personality type
            },
            "expected_status": 422,
            "description": "Invalid personality type"
        }
    ]
    
    for test_case in test_cases:
        response = test_client.post("/api/v1/user-profiles", json=test_case["data"])
        
        assert response.status_code == test_case["expected_status"], \
            f"Failed test case: {test_case['description']}"
        
        if test_case["expected_status"] == 422:
            data = response.json()
            assert "detail" in data
            assert len(data["detail"]) > 0


def test_user_profile_pagination(test_client, create_test_user):
    """Test user profiles pagination."""
    # Create multiple users by calling the fixture multiple times
    users = []
    for _ in range(15):
        user = create_test_user
        users.append(user)
    
    # Test with default pagination
    response = test_client.get("/api/v1/user-profiles")
    
    assert response.status_code == 200
    data = response.json()
    
    assert data["success"] is True
    assert "data" in data
    assert "pagination" in data
    assert "total" in data
    
    # Test with custom pagination
    response = test_client.get("/api/v1/user-profiles?skip=5&limit=5")
    
    assert response.status_code == 200
    data = response.json()
    
    assert data["success"] is True
    assert "data" in data
    assert len(data["data"]) <= 5  # Should have at most 5 items
    assert "pagination" in data
    assert data["pagination"]["skip"] == 5
    assert data["pagination"]["limit"] == 5