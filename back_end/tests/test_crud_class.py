from django.http import response
from django.test import client
from api.models import User, Class, School
from django.urls import reverse
from rest_framework import status
from rest_framework.authtoken.models import Token
from rest_framework.test import APIClient, APITestCase
from datetime import datetime
import pytz

class TestCRUDClass(APITestCase):
    def setUp(self):
        self.class_url = reverse('create-classes')
        user = User.objects.create_user(username="tak", password="123", email="tak@gmail.com", role=0)
        self.token = Token.objects.create(user=user)
        school = School.objects.create(name='Escola Municipal', city='Belem', neighbourhood='Cremacao', 
                                            state='PA', zip_code=66087600, modality=0, creator=user, local_id=0,
                                            last_update=datetime.now(tz=pytz.utc))
        self.class_data = [{
            "title": "Turma A",
            "grade": 3,
            "school":school.id,
            "local_id": 0
        }]
        self.class_data_deleted = {
            "title": "Turma A",
            "grade": 3,
            "school":school.id,
            "local_id": 0,
            "deleted":1
        }
        class_ = Class.objects.create(tutor=user, title="Turma C", grade=2, school=school, local_id=1, last_update=datetime.now(tz=pytz.utc))
        self.update_delete_url = reverse('update-delete-class', kwargs={'local_id':class_.local_id})
        self.class_update ={
            'title':'Turma B',
            'grade':2,
            "school":school.id,
            "local_id":2
        }

        
    def test_class_registration_without_token(self):
        response = self.client.post(self.class_url, self.class_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
        

    def test_class_registration_with_token(self):
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(self.token))
        response = self.client.post(self.class_url, self.class_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)


    def test_get_classes_without_token(self):
        response = self.client.get(self.class_url)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)


    def test_get_classes_with_token(self):
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(self.token))
        response = self.client.get(self.class_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)


    def test_update_class_without_token(self):
        response = self.client.put(self.update_delete_url, self.class_update, format='json')
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)


    def test_update_class_with_token(self):
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(self.token))
        response = self.client.patch(self.update_delete_url, self.class_update, format='json')
        self.assertEqual(response.data['title'], 'Turma B')
        self.assertEqual(response.data['grade'], 2)
        self.assertEqual(response.status_code, status.HTTP_200_OK)


    def test_delete_class_without_token(self):
        response = self.client.put(self.update_delete_url, self.class_data_deleted)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
    
    
    def test_delete_class_with_token(self):
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(self.token))
        response = self.client.put(self.update_delete_url, self.class_data_deleted)
        self.assertEqual(response.status_code, status.HTTP_200_OK)




