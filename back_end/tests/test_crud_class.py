from api.models import User
from django.urls import reverse
from rest_framework import status
from rest_framework.authtoken.models import Token
from rest_framework.test import APIClient, APITestCase

class TestCRUDClass(APITestCase):

    def test_create_class_without_authorization(self):
        self.client = APIClient()
        self.url = reverse('create-classes')
        self.data = {
            "title": "TurmaA",
            "grade": 3,
            "tutor": 5
        }
        response = self.client.post(self.url, self.data, format='json')
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)


    def test_create_class_with_authorization(self):
        #Create a user
        self.url = reverse('list-and-create-users')
        self.data = {
            "first_name": "Arthur",
            "last_name": "Takeshi",
            "email": "takeshi@ufpa.br",
            "username" : "arthur",
            "password" : "123456",
            "user_role": 1
        }
        response = self.client.post(self.url, self.data, format='json')
        
        #Get token
        self.token_url = reverse('get-user-token')
        self.auth_data = {
            "username": "arthur",
            "password": "123456"
        }
        response = self.client.post(self.token_url, self.auth_data, format='json')
        token = response.data['token']
        self.client.credentials(HTTP_AUTHORIZATION='Token ' + token)
        
        #Try auth
        self.class_url = reverse('create-classes')
        self.class_data = {
            "title": "TurmaA",
            "grade": 3,
        }
        response = self.client.post(self.class_url, self.class_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)


    def test_get_classes_without_authorization(self):
        self.client = APIClient()
        self.url = reverse('/api/classes/')
        response = self.client.get(self.url)
        self.assertEqual(response.status_code, status.HTTP_500_INTERNAL_SERVER_ERROR)


    def test_get_classes_with_authorization(self):
        self.client = APIClient()
        self.token_url = reverse('/api/token-auth/')
        self.auth_data = {
            "username": "gugu",
            "password": "771225eu"
        }
        response = self.client.get(self.token_url, self.auth_data, format='json')
        token = response.data['token']
        self.client.credentials(HTTP_AUTHORIZATION='Token ' + token)
        response = self.client.get(self.url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

