from django.http import response
from django.test import client
from api.models import User, Class
from django.urls import reverse
from rest_framework import status
from rest_framework.authtoken.models import Token
from rest_framework.test import APIClient, APITestCase

class ClassCreateTestCase(APITestCase):
    def setUp(self):
        self.class_url = reverse('create-classes')
        self.class_data = {
            "title": "Turma A",
            "grade": 3
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


class ClassReadTestCase(APITestCase):
    def setUp(self):
        self.class_url = reverse('create-classes')
        self.username = "usertest"
        self.password = "123456"
        self.email = "user@user.com"
        self.role = 1
        self.class_data = {
            "title": "TurmaA",
            "grade": 3
        }

        self.user = User.objects.create_user(username=self.username, password=self.password, 
                                             role=self.role)


    def test_get_classes_without_token(self):
        response = self.client.get(self.class_url)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)


    def test_get_classes_with_token(self):
        token = Token.objects.create(user=self.user)
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(token))
        response = self.client.get(self.class_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)


class ClassUpdateTestCase(APITestCase):
    def setUp(self):
        #User
        self.username = "usertest"
        self.password = "123456"
        self.email = "user@user.com"
        self.role = 1
        #Class
        self.title = 'Turma A'
        self.grade = 3

        self.user = User.objects.create_user(username=self.username, password=self.password, 
                                             role=self.role)
        self._class = Class.objects.create(tutor=self.user, grade=self.grade, title=self.title)
        self.class_url = '/api/classes/' + str(self._class.id) + '/'
        self.class_update ={
            'title':'Turma B',
            'grade':2
        }


    def test_update_class_without_token(self):
        response = self.client.put(self.class_url, self.class_update, format='json')
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)


    def test_update_class_with_token(self):
        token = Token.objects.create(user=self.user)
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(token))
        response = self.client.put(self.class_url, self.class_update, format='json')
        self.assertEqual(response.data['title'], 'Turma B')
        self.assertEqual(response.data['grade'], 2)
        self.assertEqual(response.status_code, status.HTTP_200_OK)


class ClassDeleteTestCase(APITestCase):
    def setUp(self):
        #User
        self.username = "usertest"
        self.password = "123456"
        self.email = "user@user.com"
        self.role = 1
        #Class
        self.title = 'Turma A'
        self.grade = 3

        self.user = User.objects.create_user(username=self.username, password=self.password, 
                                             role=self.role)
        self._class = Class.objects.create(tutor=self.user, grade=self.grade, title=self.title)
        self.class_url = '/api/classes/' + str(self._class.id) + '/'


    def test_delete_class_without_token(self):
        response = self.client.delete(self.class_url)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)


    def test_delete_class_with_token(self):
        token = Token.objects.create(user=self.user)
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(token))
        response = self.client.delete(self.class_url)
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)


