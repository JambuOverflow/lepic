from .views import create_class, get_classes
from rest_framework.test import APIRequestFactory
import pytest

# Create your tests here.


class TestCRUDClass:
    def test_create_class(self):
        new_class = {
            "grade": 3,
            "tutor": 5,
        }
        factory = APIRequestFactory()
        response = factory.post('/api/classes', new_class, format='json')
        assert response.status_code == 200



