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
        self.user = User.objects.create_user(username = 'pedro', password = 'pedro', email = 'pedro@ufpa.br', role = 0)
        self.first_class = Class.objects.create(tutor=self.user, grade=7, title='Class A')
        self.second_class = Class.objects.create(tutor=self.user, grade=9, title='Class B')

    def test_create_students(self):
        token = Token.objects.create(user=self.user)
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(token))
        response = self.client.post(self.student_url_list_create, self.student_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(Student.objects.count(), 1)

    def test_create_student_from_another_class(self):
        self.user_2 = User.objects.create_user(username = 'aian', password = 'shay', email = 'naia@ufpa.br', role = 0)
        token = Token.objects.create(user=self.user_2)
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(token))
        response = self.client.post(self.student_url_list_create, self.student_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(Student.objects.count(), 0)
        self.assertEqual(response.data['detail'], "You do not have the permission to create a student account with a class where you are not the teacher")

    def test_list_students(self):
        self.user = User.objects.create_user(username="aian", email="aian@ufpa.br", password="123", role=1)
        token = Token.objects.create(user=self.user)
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(token))
        response = self.client.get(self.student_url_list_create)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual([], response.data)
    
    def test_update_put_students(self):
        token = Token.objects.create(user=self.user)
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(token))
        Student.objects.create(_class=self.first_class, first_name='Arthur', last_name='Takeshi')
        student_new_data = {
            'first_name': 'Aian',
            'last_name': 'Takeshi',
            '_class': 2
        }
        response = self.client.put(self.student_url_update_delete, student_new_data, format='json')
        response.data.pop('id')
        self.assertEqual(response.data, student_new_data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_update_put_students_from_another_class(self):
        self.user_2 = User.objects.create_user(username = 'aian', password = 'shay', email = 'naia@ufpa.br', role = 0)
        token = Token.objects.create(user=self.user_2)
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(token))
        student_new_data = {
            'first_name': 'Aian',
            'last_name': 'Takeshi',
            '_class': 2
        }
        Student.objects.create(_class=self.first_class, first_name='Arthur', last_name='Takeshi')
        response = self.client.put(self.student_url_update_delete, student_new_data, format='json')
        student_original_first_name = Student.objects.filter(id=1).values_list('first_name', flat=True)[0]
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(response.data['detail'], "You do not have permission to perform this action.")
        self.assertEqual(student_original_first_name, "Arthur")

    def test_update_patch_students(self):
        student_new_data = {
            'first_name': 'Aian'
        }
        token = Token.objects.create(user=self.user)
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(token))
        Student.objects.create(_class=self.first_class, first_name='Arthur', last_name='Takeshi')
        response = self.client.patch(self.student_url_update_delete, student_new_data, format='json')
        self.assertEqual(response.data['first_name'], student_new_data['first_name'])
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_update_patch_students_from_another_class(self):
        self.user_2 = User.objects.create_user(username = 'aian', password = 'shay', email = 'naia@ufpa.br', role = 0)
        token = Token.objects.create(user=self.user_2)
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(token))
        student_new_data = {
            'first_name': 'Aian'
        }
        Student.objects.create(_class=self.first_class, first_name='Arthur', last_name='Takeshi')
        response = self.client.patch(self.student_url_update_delete, student_new_data, format='json')
        student_original_first_name = Student.objects.filter(id=1).values_list('first_name', flat=True)[0]
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(response.data['detail'], "You do not have permission to perform this action.")
        self.assertEqual(student_original_first_name, "Arthur")

    def test_delete_students(self):
        token = Token.objects.create(user=self.user)
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(token))
        Student.objects.create(_class=self.first_class, first_name='Arthur', last_name='Takeshi')
        response = self.client.delete(self.student_url_update_delete, self.student_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        self.assertEqual(Student.objects.count(), 0)

    def test_delete_student_from_another_class(self):
        Student.objects.create(_class=self.first_class, first_name='Arthur', last_name='Takeshi')
        self.user_2 = User.objects.create_user(username = 'aian', password = 'shay', email = 'naia@ufpa.br', role = 0)
        token = Token.objects.create(user=self.user_2)
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(token))
        response = self.client.delete(self.student_url_update_delete, self.student_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(Student.objects.count(), 1)
        self.assertEqual(response.data['detail'], "You do not have permission to perform this action.")