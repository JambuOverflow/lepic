from django.urls import reverse
from rest_framework import status
from api.models import Class, User, Text, School
from rest_framework.authtoken.models import Token
from rest_framework.test import APIClient, APITestCase
from datetime import datetime
import pytz

class TestCRUDText(APITestCase):
    def setUp(self):
        self.text_url = reverse('create-text')
        user = User.objects.create_user(username="usertest", password="123456", email="user@test.com", role=0)
        self.token = Token.objects.create(user=user)
        school = School.objects.create(name='Escola Municipal', city='Belem', neighbourhood='Cremacao', 
                                            state='PA', zip_code=66087600, modality=0, creator=user, local_id=0,
                                            last_update=datetime.now(tz=pytz.utc))
        class_ = Class.objects.create(tutor=user, grade=7, title='Turma do Ideal', school=school, local_id=0,
                                            last_update=datetime.now(tz=pytz.utc))
        self.text_data = [{
            "title": "Trecho de O Alquimista",
            "body": "Lorem ipsum lorem 3",
            "_class":class_.id,
            "local_id": 0
        }]
        self.text_data_deleted = {
            "title": "Trecho de O Alquimista",
            "body": "Lorem ipsum lorem 3",
            "_class":class_.id,
            "local_id": 0,
            "deleted": 1
        }
        self.updated_text = {
            "title":"Trecho de Sertao Veredas",
            "body": "Lorem ipsum lorem 3",
            "_class":class_.id,
            "local_id": 1
        }
        text = Text.objects.create(title='Texto 2', body='Lorem ipsum', _class=class_, local_id=5,
                                            last_update=datetime.now(tz=pytz.utc))
        self.update_delete_url = reverse('update-delete-text', kwargs={'local_id': text.local_id})


    def test_create_text_without_authorization(self):
        response = self.client.post(self.text_url, self.text_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)


    def test_create_text_with_authorization(self):
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(self.token))
        response = self.client.post(self.text_url, self.text_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)


    def test_get_texts_without_authorization(self):
        response = self.client.get(self.text_url)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)


    def test_get_texts_with_authorization(self):
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(self.token))
        response = self.client.get(self.text_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)


    def test_update_text_without_authorization(self):
        response = self.client.put(self.update_delete_url, self.updated_text, format='json')
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)


    def test_update_text_with_authorization(self):
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(self.token))
        response = self.client.patch(self.update_delete_url, self.updated_text, format='json')
        self.assertEqual(response.data['title'], "Trecho de Sertao Veredas")
        self.assertEqual(response.status_code, status.HTTP_200_OK)


    def test_delete_text_without_authorization(self):
        response = self.client.put(self.update_delete_url, self.text_data_deleted)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)


    def test_delete_text_with_authorization(self):
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(self.token))
        response = self.client.put(self.update_delete_url, self.text_data_deleted)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
