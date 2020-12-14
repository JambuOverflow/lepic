from django.urls import reverse
from rest_framework import status
from api.models import Class
from rest_framework.authtoken.models import Token
from rest_framework.test import APIClient, APITestCase

class TestCRUDText(APITestCase):
    class_url = reverse('create-classes')
    user_url = reverse('list-and-create-users')
    text_url = reverse('create-text')
    auth_url = reverse('access-token')
    auth_data = {
            "username":"usertest",
            "password":"123456"
        }

    def setUp(self):
        user_data = {
            "first_name": "Test",
            "last_name": "User",
            "email": "user@test.com",
            "username": "usertest",
            "password": "123456",
            "user_role": 1  # teacher
        }
        self.client.post(self.user_url, user_data, format='json')


    def test_create_text_without_authorization(self):
        text = {
            "title": "Trecho de O Alquimista",
            "body": "Lorem ipsum lorem 3",
            "_class": 7
        }
        response = self.client.post(self.text_url, text, format='json')
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)


    def test_create_text_with_authorization(self):
        response = self.client.post(self.auth_url, self.auth_data, format='json')
        token = response.data['token']
        self.client.credentials(HTTP_AUTHORIZATION='Token ' + token)

        #Create class
        class_ = {
                'grade':7, 
                'title':'Turma do Ideal'
                }
        response = self.client.post(self.class_url, class_, format='json')
        class_id = response.data['id']

        #Create text
        text = {
            "title": "Trecho de O Alquimista",
            "body": "Lorem ipsum lorem 3",
            "_class":class_id
            }
        response = self.client.post(self.text_url, text, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)


    def test_get_texts_without_authorization(self):
        response = self.client.get(self.text_url)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)


    def test_get_texts_with_authorization(self):
        response = self.client.post(self.auth_url, self.auth_data, format='json')
        token = response.data['token']
        self.client.credentials(HTTP_AUTHORIZATION='Token ' + token)
        response = self.client.get(self.text_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

