from django.urls import reverse
from rest_framework import status
from rest_framework.authtoken.models import Token
from rest_framework.test import APIClient, APITestCase

class TestCRUDText(APITestCase):

    def test_create_text_without_authorization(self):
        self.client = APIClient()
        self.url = reverse('/api/texts/')
        self.data = {
            "title": "Trecho de O Alquimista",
            "body": "Lorem ipsum lorem",
            "_class": 7
        }
        response = self.client.post(self.url, self.data, format='json')
        self.assertEqual(response.status_code, status.HTTP_500_INTERNAL_SERVER_ERROR)


    def test_create_text_with_authorization(self):
        #Create a user
        self.url = reverse('/api/texts/')
        
        #Get token
        self.token_url = reverse('/api/token-auth/')
        self.auth_data = {
            "username": "gugu",
            "password": "771225eu"
        }
        response = self.client.get(self.token_url, self.auth_data, format='json')
        token = response.data['token']
        self.client.credentials(HTTP_AUTHORIZATION='Token ' + token)
        
        #Try auth
        self.class_url = reverse('/api/token-auth/')
        self.class_data = {
            "title": "Trecho de O Alquimista",
            "body": "Lorem ipsum lorem",
            "_class": 7
        }
        response = self.client.post(self.class_url, self.class_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)


    def test_get_texts_without_authorization(self):
        self.client = APIClient()
        self.url = reverse('/api/texts/')
        response = self.client.get(self.url)
        self.assertEqual(response.status_code, status.HTTP_500_INTERNAL_SERVER_ERROR)


    def test_get_texts_with_authorization(self):
        self.client = APIClient()
        self.token_url = reverse('/api/texts/')
        self.auth_data = {
            "username": "gugu",
            "password": "771225eu"
        }
        response = self.client.get(self.token_url, self.auth_data, format='json')
        token = response.data['token']
        self.client.credentials(HTTP_AUTHORIZATION='Token ' + token)
        response = self.client.get(self.url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

