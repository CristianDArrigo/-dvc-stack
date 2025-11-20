"""
Pytest configuration and fixtures.
"""
import pytest
from django.contrib.auth import get_user_model

User = get_user_model()


@pytest.fixture
def api_client():
    """
    Returns a DRF APIClient instance.
    """
    from rest_framework.test import APIClient
    return APIClient()


@pytest.fixture
def user(db):
    """
    Creates and returns a test user.
    """
    return User.objects.create_user(
        username="testuser",
        email="test@example.com",
        password="testpass123"
    )


@pytest.fixture
def authenticated_client(api_client, user):
    """
    Returns an authenticated APIClient.
    """
    api_client.force_authenticate(user=user)
    return api_client
