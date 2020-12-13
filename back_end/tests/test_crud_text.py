from django.urls import reverse
from rest_framework import status
from rest_framework.authtoken.models import Token
from rest_framework.test import APIClient, APITestCase

class TestCRUDText(APITestCase):

    def test_create_text_without_authorization(self):
        self.client = APIClient()
        self.url = reverse('create-text')
        self.data = {
            "title": "Trecho de O Alquimista",
            "body": "Lorem ipsum lorem",
            "_class": 7
        }
        response = self.client.post(self.url, self.data, format='json')
        self.assertEqual(response.status_code, status.HTTP_500_INTERNAL_SERVER_ERROR)

    def test_create_text_with_authorization(self):
        #Create a user
        self.url = reverse('list-and-create-users')
        self.data = {
            "first_name": "Gugu",
            "last_name": "Liberato",
            "email": "gugu@sbt.com",
            "username" : "gugu",
            "password" : "771225eu",
            "user_role": 1
        }
        response = self.client.post(self.url, self.data, format='json')
        
        #Get token and auth
        self.token_url = reverse('get-user-token')
        self.auth_data = {
            "username": "gugu",
            "password": "771225eu"
        }
        response = self.client.post(self.token_url, self.auth_data, format='json')
        token = response.data['token']
        self.client.credentials(HTTP_AUTHORIZATION='Token ' + token)
        
        #Create text
        self.class_url = reverse('create-text')
        self.class_data = {
            "title": "Trecho de O Alquimista",
            "body": "Lorem ipsum lorem",
            "_class": 7
        }
        response = self.client.post(self.class_url, self.class_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)


    def test_get_texts_without_authorization(self):
        self.client = APIClient()
        self.url = reverse('create-text')
        response = self.client.get(self.url)
        self.assertEqual(response.status_code, status.HTTP_500_INTERNAL_SERVER_ERROR)


    def test_get_texts_with_authorization(self):
        self.url = reverse('list-and-create-users')
        self.data = {
            "first_name": "Gugu",
            "last_name": "Liberato",
            "email": "gugu@sbt.com",
            "username" : "gugu",
            "password" : "771225eu",
            "user_role": 1
        }
        response = self.client.post(self.url, self.data, format='json')

        self.client = APIClient()
        self.token_url = reverse('get-user-token')
        self.auth_data = {
            "username": "gugu",
            "password": "771225eu"
        }
        response = self.client.post(self.token_url, self.auth_data, format='json')
        token = response.data['token']
        self.client.credentials(HTTP_AUTHORIZATION='Token ' + token)

        self.text_url = reverse('create-text')
        response = self.client.get(self.text_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

