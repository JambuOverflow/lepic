from rest_framework.test import APITestCase, APIClient
from django.urls import reverse
from rest_framework import status
from rest_framework.authtoken.models import Token
from api.models import User, Student, Class

class TestCRUDStudent(APITestCase):
    
    def setUp(self):
        self.student_url_list_create = reverse('create-student')
        self.student_url_update_delete = reverse('update-delete-students', args=[1])
        self.class_url = reverse('create-classes')
        self.student_data = {
            'first_name': 'Arthur',
            'last_name': 'Shay',
            '_class': 1
        }
        self.class_data = {
            "title": "Turma A",
            "grade": 3
        }

    def test_create_students(self):
        self.user = User.objects.create_user(username="aian", email="aian@ufpa.br", password="123", role=1)
        token = Token.objects.create(user=self.user)
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(token))
        self.client.post(self.class_url, self.class_data, format='json')
        response = self.client.post(self.student_url_list_create, self.student_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

    def test_list_students(self):
        self.user = User.objects.create_user(username="aian", email="aian@ufpa.br", password="123", role=1)
        token = Token.objects.create(user=self.user)
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(token))
        response = self.client.get(self.student_url_list_create)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual([], response.data)
    
    def test_update_put_students(self):
        self.user = User.objects.create_user(username="aian", email="aian@ufpa.br", password="123", role=1)
        token = Token.objects.create(user=self.user)
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(token))
        self.client.post(self.class_url, self.class_data, format='json')
        self.client.post(self.student_url_list_create, self.student_data, format='json')
        self.class_data_2 = {
            "title": "Turma B",
            "grade": 7
        }
        self.client.post(self.class_url, self.class_data_2, format='json')
        student_new_data = {
            'first_name': 'Aian',
            'last_name': 'Takeshi',
            '_class': 2
        }
        response = self.client.put(self.student_url_update_delete, student_new_data, format='json')
        self.assertEqual(response.data, student_new_data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_update_patch_students(self):
        self.user = User.objects.create_user(username="aian", email="aian@ufpa.br", password="123", role=1)
        token = Token.objects.create(user=self.user)
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(token))
        self.client.post(self.class_url, self.class_data, format='json')
        self.client.post(self.student_url_list_create, self.student_data, format='json')
        student_new_data = {
            'first_name': 'Aian'
        }
        response = self.client.patch(self.student_url_update_delete, student_new_data, format='json')
        self.assertEqual(response.data['first_name'], student_new_data['first_name'])
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_delete_students(self):
        self.user = User.objects.create_user(username="aian", email="aian@ufpa.br", password="123", role=1)
        token = Token.objects.create(user=self.user)
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(token))
        self.client.post(self.class_url, self.class_data, format='json')
        self.client.post(self.student_url_list_create, self.student_data, format='json')
        response = self.client.delete(self.student_url_update_delete, self.student_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        self.assertEqual(Student.objects.count(), 0)