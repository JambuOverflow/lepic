from .views import create_class, get_classes
from rest_framework.test import APIRequestFactory
import pytest

# Create your tests here.


class TestCRUDClass:
    def test_create_class(self):
        new_class = {
            "grade": 3,
            "id_tutor": 5,
            "tutor_role": 0
        }
        factory = APIRequestFactory()
        request = factory.post('/api/createclass', new_class, format='json')
        response = create_class(request)
        assert response.status_code == 201


    def test_get_classes(self):
        user_id = 5

