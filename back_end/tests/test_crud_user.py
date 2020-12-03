from api.views import get_users, create_user, update_user
from rest_framework.test import APIRequestFactory
import pytest

class TestCrudUser:

    @pytest.mark.django_db
    def test_get_users(self):
        rest_request_factory = APIRequestFactory()
        request = rest_request_factory.get('/api/get_users/')
        response = get_users(request)
        assert response.status_code == 200

    @pytest.mark.django_db
    def test_create_user(self):
        new_user = {
            "first_name": "Renan",
            "last_name": "Cunha",
            "email": "renan@ufpa.br",
            "username" : "renancunha",
            "password" : "cunharenan",
            "role": 0
        }
        rest_request_factory = APIRequestFactory()
        request = rest_request_factory.post('/api/create_user/', new_user, format='json')
        response = create_user(request)
        assert response.status_code == 201

    @pytest.mark.django_db
    def test_update_user(self):
        rest_request_factory = APIRequestFactory()
        new_user = {
            "first_name": "Renan",
            "last_name": "Cunha",
            "email": "renan@ufpa.br",
            "username" : "renancunha",
            "password" : "cunharenan",
            "role": 0
        }
        request_create = rest_request_factory.post('/api/create_user/', new_user, format='json')
        create_user(request_create)
        updated_user = {
            "first_name": "Vitor",
            "last_name": "Cantinho",
            "email": "vitor@ufpa.br",
            "username" : "renancunha",
            "password" : "cunharenan",
            "role": 2
        }
        request_update = rest_request_factory.put('/api/update_user/1', updated_user, format='json')
        response_update = update_user(request_update, 1)
        assert response_update.status_code == 200