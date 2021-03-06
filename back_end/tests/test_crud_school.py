from django.http import response
from django.test import client
from api.models import User, School
from django.urls import reverse
from rest_framework import status
from rest_framework.authtoken.models import Token
from rest_framework.test import APIClient, APITestCase
from datetime import datetime
import pytz


class TestCRUDSchool(APITestCase):
    def setUp(self):
        self.create_url = reverse('create-schools')
        user = User.objects.create_user(username="usertest", password="123456eu", email="user@test.com", role=0)
        self.token = Token.objects.create(user=user)
        self.school_data = [{
            "name":"Escola Federal Dr Orlando",
            "city":"Belem",
            "neighbourhood":"Umarizal",
            "state":"PA",
            "zip_code":66000000,
            "modality":2,
            "local_id":0
        }]
        self.school_data_deleted = {
            "name":"Escola Federal Dr Orlando",
            "city":"Belem",
            "neighbourhood":"Umarizal",
            "state":"PA",
            "zip_code":66000000,
            "modality":2,
            "local_id":0,
            "deleted":1
        }
        self.updated_school = {
            "city":"Rio de Janeiro",
            "neighbourhood":"Lapa",
            "name":"Escola Federal Dr Orlando",
            "state":"PA",
            "zip_code":66000000,
            "modality":2,
            "local_id":0
        }
        school = School.objects.create(name="Escola Municipal", city="Sao Paulo", neighbourhood="Itaim Bibi",
                                       state="SP", zip_code=60000000, modality=1, creator=user, local_id=1,
                                       last_update=datetime(2020, 12, 28, 23, 00, 00, 00, pytz.utc))
        self.update_delete_url = reverse('update-delete-schools', kwargs={'local_id': school.local_id})


    def test_school_registration_without_token(self):
        response = self.client.post(self.create_url, self.school_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

        
    def test_school_registration_with_token(self):
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(self.token))
        response = self.client.post(self.create_url, self.school_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)


    def test_get_schools_without_token(self):
        response = self.client.get(self.create_url)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)


    def test_get_schools_with_token(self):
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(self.token))
        response = self.client.get(self.create_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)


    def test_update_school_without_token(self):
        response = self.client.put(self.update_delete_url, self.updated_school, format='json')
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)


    def test_update_school_with_token(self):
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(self.token))
        response = self.client.put(self.update_delete_url, self.updated_school, format='json')
        self.assertEqual(response.data['city'], "Rio de Janeiro")
        self.assertEqual(response.data['neighbourhood'], "Lapa")
        self.assertEqual(response.status_code, status.HTTP_200_OK)


    def test_delete_school_without_token(self):
        response = self.client.put(self.update_delete_url, self.school_data_deleted)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
    
    
    def test_delete_school_with_token(self):
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(self.token))
        response = self.client.put(self.update_delete_url, self.school_data_deleted)
        response.data.pop('id')
        response.data.pop('creator')
        response.data.pop('last_update')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data, self.school_data_deleted)




