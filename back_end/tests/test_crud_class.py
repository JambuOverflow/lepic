from django.http import response
from django.test import client
from api.models import User, Class
from django.urls import reverse
from rest_framework import status
from rest_framework.authtoken.models import Token
from rest_framework.test import APIClient, APITestCase

class ClassCreateTestCase(APITestCase):
    class_url = reverse('create-classes')
    user_url = reverse('list-and-create-users')
    token_url = reverse('access-token')
    
    def setUp(self):
        self.title = "TurmaA"
        self.grade = 3
        self.first_name = "Arthur"
        self.last_name = "Takeshi"
        self.email = "takeshi@ufpa.br"
        self.username = "arthur"
        self.password = "123456"
        self.role = 1

        self.user_data = {
            "first_name": "Arthur",
            "last_name": "Takeshi",
            "email": "takeshi@ufpa.br",
            "username": "arthur",
            "password": "123456",
            "role": 1
        }

        self.class_data = {
            "title": self.title,
            "grade": self.grade
        }
        

    def test_class_registration_without_token(self):
        response = self.client.post(self.class_url, self.class_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
        

    def test_class_registration_with_token(self):
        self.user = User.objects.create_user(username="tak", password="123", email="tak@gmail.com", role=1)
        token = Token.objects.create(user=self.user)
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(token))
        response = self.client.post(self.class_url, self.class_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)


    def test_class_registration_with_wrong_password(self):
        response = self.client.post(self.user_url, self.user_data, format='json')  
        response = self.client.post(self.token_url, {"username": self.username, "password": "this-is-wrong"}, format='json')
        response = self.client.post(self.class_url, self.class_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)


class ClassReadTestCase(APITestCase):
    class_url = reverse('create-classes')
    user_url = reverse('list-and-create-users')
    token_url = reverse('access-token')
    client = APIClient()

    user_credentials = {
            "username":"usertest",
            "password":"123456"
        }

    def setUp(self):

        self.class_data = {
            "title": "TurmaA",
            "grade": 3
        }

        self.user_data = {
            "email": "gugu@sbt.com",
            "password": "123456eu"
        }

    def test_get_classes_without_token(self):
        response = self.client.get(self.class_url)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)


    def test_get_classes_with_token(self):
        response = self.client.post(self.token_url, self.user_credentials, format='json')
        token = response.data['token']
        self.client.credentials(HTTP_AUTHORIZATION='Token ' + token)
        response = self.client.get(self.class_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

