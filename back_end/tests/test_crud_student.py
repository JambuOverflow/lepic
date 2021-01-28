from rest_framework.test import APITestCase, APIClient
from django.urls import reverse
from rest_framework import status
from rest_framework.authtoken.models import Token
from api.models import User, Student, Class, School
from datetime import datetime
import pytz

class TestCRUDStudent(APITestCase):
    
    def setUp(self):
        user = User.objects.create_user(username = 'pedro', password = 'pedro', email = 'pedro@ufpa.br', role = 0)
        self.token = Token.objects.create(user=user)

        user_2 = User.objects.create_user(username = 'aian', password = 'shay', email = 'naia@ufpa.br', role = 0)
        self.token_2 = Token.objects.create(user=user_2)

        school = School.objects.create(name="Escola Municipal", city="Sao Paulo", neighbourhood="Itaim Bibi",
                                        state="SP", zip_code=60000000, modality=1, creator=user, local_id=0,
                                        last_update=datetime.now(tz=pytz.utc))

        class_ = Class.objects.create(tutor=user, grade=7, title='Class A', school=school, local_id=0,
                                            last_update=datetime.now(tz=pytz.utc))

        student = Student.objects.create(first_name='Test', last_name='Student', _class=class_, local_id=2, last_update=datetime.now(tz=pytz.utc))
        self.student_url_list_create = reverse('create-student')
        self.student_url_update_delete = reverse('update-delete-students', kwargs={'local_id': student.local_id})

        self.student_data = [{
            'first_name': 'Arthur',
            'last_name': 'Shay',
            '_class': class_.id,
            'local_id': 0
        }]
        self.student_update_data = {
            'first_name': 'Aian',
            'last_name': 'Takeshi',
            '_class': class_.id,
            'local_id': 1
        }
        self.student_data_deleted = {
            'first_name': 'Arthur',
            'last_name': 'Shay',
            '_class': class_.id,
            'local_id': 0,
            'deleted': 1
        }

    def test_create_students(self):
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(self.token))
        response = self.client.post(self.student_url_list_create, self.student_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

    def test_create_student_from_another_class(self):
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(self.token_2))
        response = self.client.post(self.student_url_list_create, self.student_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(response.data['detail'], "You do not have the permission to create a student account with a class where you are not the teacher")

    def test_list_students(self):
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(self.token))
        response = self.client.get(self.student_url_list_create)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
    
    def test_update_students(self):
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(self.token))
        response = self.client.put(self.student_url_update_delete, self.student_update_data, format='json')
        response.data.pop('id')
        response.data.pop('deleted')
        response.data.pop('last_update')
        self.assertEqual(response.data, self.student_update_data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_update_students_from_another_class(self):
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(self.token_2))
        response = self.client.put(self.student_url_update_delete, self.student_update_data, format='json')
        student_original_first_name = Student.objects.filter(id=1).values_list('first_name', flat=True)[0]
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(response.data['detail'], "You do not have permission to perform this action.")
        self.assertEqual(student_original_first_name, "Test")

    def test_delete_students(self):
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(self.token))
        response = self.client.put(self.student_url_update_delete, self.student_data_deleted, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_delete_student_from_another_class(self):
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(self.token_2))
        response = self.client.put(self.student_url_update_delete, self.student_data_deleted, format='json')
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(response.data['detail'], "You do not have permission to perform this action.")