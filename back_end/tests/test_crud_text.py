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
            "body": "Lorem ipsum lorem 3",
            "_class": 7
        }
        response = self.client.post(self.url, self.data, format='json')
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_create_text_with_authorization(self):
        #Get token and auth
        self.client.credentials()
        token_url = reverse('access-token')
        auth_data = {
            "username": "gugu",
            "password": "123456eu"
        }
        response = self.client.post(token_url, auth_data, format='json')
        token = response.data["token"]
        self.client.credentials(HTTP_AUTHORIZATION='Token ' + token)
        
        #Create text
        class_url = reverse('create-text')
        class_data = {
            "title": "Trecho de O Alquimista",
            "body": "Lorem ipsum lorem 3",
            "_class": 7
        }
        response = self.client.post(class_url, class_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)


    def test_get_texts_without_authorization(self):
        self.client = APIClient()
        self.url = reverse('create-text')
        response = self.client.get(self.url)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)


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
        self.token_url = reverse('access-token')
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

