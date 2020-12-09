from api.models import User
from django.urls import reverse
from rest_framework import status
from rest_framework.authtoken.models import Token
from rest_framework.test import APIClient, APITestCase

# Create your tests here.


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
            "username" : "arthur",
            "password" : "arthur",
            "user_role": 3
        }
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(User.objects.count(), 1)
        self.assertEqual(User.objects.get().username, 'arthur')
        self.assertEqual(User.objects.get().password == 'arthur', False)

    def test_get_token(self):
        self.client.credentials()
        url = reverse('list-and-create-users')
        data = {
            "first_name": "Arthur",
            "last_name": "Takeshi",
            "email": "takeshi@ufpa.br",
            "username" : "arthur",
            "password" : "arthur",
            "user_role": 3
        }
        response = self.client.post(url, data, format='json')
        url = reverse('get-user-token')
        data = {
            "username": "arthur",
            "password": "arthur"
        }
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual('token' in response.data, True)

    def test_update_user_put(self):
        self.client.credentials()
        url = reverse('list-and-create-users')
        data = {
            "first_name": "Arthur",
            "last_name": "Takeshi",
            "email": "takeshi@ufpa.br",
            "username" : "arthur",
            "password" : "arthur",
            "user_role": 3
        }
        response = self.client.post(url, data, format='json')
        old_username = response.data['username']
        old_password = response.data['password']

        url = reverse('get-user-token')
        data = {
            "username": "arthur",
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
            "username" : "renan",
            "password" : "renan",
            "user_role": 1
        }
        response = self.client.put(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(User.objects.count(), 1)
        self.assertEqual(User.objects.get().username == old_username, False)
        self.assertEqual(User.objects.get().password == old_password, False)

    def test_update_user_patch(self):
        self.client.credentials()
        url = reverse('list-and-create-users')
        data = {
            "first_name": "Arthur",
            "last_name": "Takeshi",
            "email": "takeshi@ufpa.br",
            "username" : "arthur",
            "password" : "arthur",
            "user_role": 3
        }
        response = self.client.post(url, data, format='json')
        old_username = response.data['username']
        old_password = response.data['password']

        url = reverse('get-user-token')
        data = {
            "username": "arthur",
            "password": "arthur"
        }
        response = self.client.post(url, data, format='json')
        token = response.data['token']

        self.client.credentials(HTTP_AUTHORIZATION='Token ' + token)
        url = reverse('update-delete-users', args=[1])
        data = {
            "username" : "renan",
            "password" : "renan",
            "user_role": 1
        }
        response = self.client.patch(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(User.objects.count(), 1)
        self.assertEqual(User.objects.get().username == old_username, False)
        self.assertEqual(User.objects.get().password == old_password, False)
