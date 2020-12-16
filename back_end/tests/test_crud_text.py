from django.urls import reverse
from rest_framework import status
from api.models import Class, User
from rest_framework.authtoken.models import Token
from rest_framework.test import APIClient, APITestCase

class TestCRUDText(APITestCase):
    class_url = reverse('create-classes')
    user_url = reverse('list-and-create-users')
    text_url = reverse('create-text')
    auth_url = reverse('access-token')

    def setUp(self):
        self.email = "user@test.com"
        self.username = "usertest"
        self.password = "123456"
        self.role = 1

        self.class_data = {
                'grade':7, 
                'title':'Turma do Ideal'
                }


    def test_create_text_without_authorization(self):
        text = {
            "title": "Trecho de O Alquimista",
            "body": "Lorem ipsum lorem 3",
            "_class": 7
        }
        response = self.client.post(self.text_url, text, format='json')
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)


    def test_create_text_with_authorization(self):
        self.user = User.objects.create_user(username=self.username, password=self.password, email=self.email, role=self.role)
        token = Token.objects.create(user=self.user)
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(token))
        response = self.client.post(self.class_url, self.class_data, format='json')
        class_id = response.data['id']
        
        text_data = {
            "title": "Trecho de O Alquimista",
            "body": "Lorem ipsum lorem 3",
            "_class":class_id
            }

        response = self.client.post(self.text_url, text_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)


    def test_get_texts_without_authorization(self):
        response = self.client.get(self.text_url)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)


    def test_get_texts_with_authorization(self):
        self.user = User.objects.create_user(username=self.username, password=self.password, email=self.email, role=self.role)
        token = Token.objects.create(user=self.user)
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(token))
        response = self.client.get(self.text_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

