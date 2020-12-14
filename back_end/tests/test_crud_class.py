from django.http import response
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
        self.tutor = 5

        self.first_name = "Arthur"
        self.last_name = "Takeshi"
        self.email = "takeshi@ufpa.br"
        self.username = "arthur"
        self.password = "123456"
        self.user_role = 1

        self.user_data = {
            "first_name": self.first_name,
            "last_name": self.last_name,
            "email": self.email,
            "username": self.username,
            "password": self.password,
            "user_role": self.user_role
        }

        self.class_data = {
            "title": self.title,
            "grade": self.grade,
            "tutor": self.tutor
        }
        

    def test_class_registration_without_token(self):
        response = self.client.post(self.class_url, self.class_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
        

    def test_class_registration_with_token(self):
        response = self.client.post(self.user_url, self.user_data, format='json')  
        
        response = self.client.post(self.token_url, {"username": self.username, "password": self.password}, format='json')
        token = response.data['token']
        self.client.credentials(HTTP_AUTHORIZATION='Token ' + token)
        
        response = self.client.post(self.class_url, self.class_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)


    def test_class_registration_with_wrong_password(self):
        response = self.client.post(self.user_url, self.user_data, format='json')  
        
        response = self.client.post(self.token_url, {"username": self.username, "password": "this-is-wrong"}, format='json')
        token = response.data['token']
        
        response = self.client.post(self.class_url, self.class_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

class ClassReadTestCase(APITestCase):
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
        self.user_role = 1
        
        self.user_data = {
            "first_name": self.first_name,
            "last_name": self.last_name,
            "email": self.email,
            "username": self.username,
            "password": self.password,
            "user_role": self.user_role
        }

        self.class_data = {
            "title": self.title,
            "grade": self.grade,
            "tutor": self.tutor
        }


    def test_get_classes_without_token(self):
        response = self.client.get(self.class_url)
        self.assertEqual(self.response.status_code, status.HTTP_401_UNAUTHORIZED)


    def test_get_classes_with_token(self):
        response = self.client.get(self.token_url, {"username": self.username, "password": self.password}, format='json')
        token = response.data['token']
        self.client.credentials(HTTP_AUTHORIZATION='Token ' + token)
        response = self.client.get(self.class_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

