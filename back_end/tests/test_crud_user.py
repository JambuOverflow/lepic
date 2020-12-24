from django.urls import reverse
from rest_framework import status
from rest_framework.authtoken.models import Token
from rest_framework.test import APIClient, APITestCase
from api.models import User


class TestCrudUser(APITestCase):

    def test_list_users(self):
        self.client.credentials()
        url = reverse('list-and-create-users')
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual([], response.data)

    def test_create_user(self):
        self.client.credentials()
        url = reverse('list-and-create-users')
        data = {
            "first_name": "Arthur",
            "last_name": "Takeshi",
            "email": "takeshi@ufpa.br",
            "username": "takeshi@ufpa.br",
            "password": "arthur",
            "role": 2
        }
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(User.objects.count(), 1)
        self.assertEqual(User.objects.get().username, 'takeshi@ufpa.br')
        self.assertEqual(User.objects.get().password == 'arthur', False)

    def test_get_token(self):
        self.client.credentials()
        User.objects.create_user(username="takeshi@ufpa.br", email="takeshi@ufpa.br", password="arthur", role=0)
        url = reverse('access-token')
        data = {
            "username": "takeshi@ufpa.br",
            "password": "arthur"
        }
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual('token' in response.data, True)

    def test_update_user_put(self):
        User.objects.create_user(username="takeshi@ufpa.br", email="takeshi@ufpa.br", password="arthur", role=0)

        url = reverse('access-token')
        data = {
            "username": "takeshi@ufpa.br",
            "password": "arthur"
        }
        response = self.client.post(url, data, format='json')
        token = response.data['token']

        self.client.credentials(HTTP_AUTHORIZATION='Token ' + token)
        url = reverse('update-delete-users', args=[1])
        data = {
            "first_name": "Renan",
            "last_name": "Cunha",
            "email": "renan@ufpa.br",
            "username": "renan@ufpa.br",
            "password": "renan",
            "role": 1
        }
        response = self.client.put(url, data, format='json')
        response.data.pop('id')
        response.data.pop('password')
        data.pop('password')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(User.objects.count(), 1)
        self.assertEqual(response.data, data)

    def test_update_user_patch(self):
        self.client.credentials()
        User.objects.create_user(username="takeshi@ufpa.br", email="takeshi@ufpa.br", password="arthur", role=0)
        url = reverse('access-token')
        data = {
            "username": "takeshi@ufpa.br",
            "password": "arthur"
        }
        response = self.client.post(url, data, format='json')
        token = response.data['token']

        self.client.credentials(HTTP_AUTHORIZATION='Token ' + token)
        url = reverse('update-delete-users', args=[1])
        data = {
            "username": "renan@ufpa.br",
            "password": "renan",
            "role": 1
        }
        response = self.client.patch(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(User.objects.count(), 1)
        self.assertEqual(response.data['username'], 'renan@ufpa.br')

    def test_delete_user(self):
        self.client.credentials()
        User.objects.create_user(username="takeshi@ufpa.br", email="takeshi@ufpa.br", password="arthur", role=0)
        url = reverse('access-token')
        data = {
            "username": "takeshi@ufpa.br",
            "password": "arthur"
        }
        response = self.client.post(url, data, format='json')
        token = response.data['token']

        self.client.credentials(HTTP_AUTHORIZATION='Token ' + token)
        url = reverse('update-delete-users', args=[1])
        response = self.client.delete(url, data, format='json')

        self.assertEqual(User.objects.count(), 0)
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        
