from rest_framework import status
from rest_framework.authtoken.models import Token
from rest_framework.test import APIClient, APITestCase

from django.urls import reverse
from django.utils.encoding import force_bytes
from django.contrib.auth.tokens import default_token_generator, PasswordResetTokenGenerator
from django.utils.http import urlsafe_base64_encode, urlsafe_base64_decode

from api.models import User

class TestCrudUser(APITestCase):

    def test_get_user(self):
        self.client.credentials()

        User.objects.create_user(username="takeshi@ufpa.br", email="takeshi@ufpa.br", password="arthur", role=0)
        url = reverse('access-token')
        data = {
            "username": "takeshi@ufpa.br",
            "password": "arthur"
        }
        response = self.client.post(url, data, format='json')
        token = response.data['token']

        self.client.credentials(HTTP_AUTHORIZATION='Token ' + token)

        url = reverse('list-and-create-users')
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue('email' in response.data)
        self.assertTrue('role' in response.data)
        self.assertTrue('first_name' in response.data)

    def test_create_user(self):
        self.client.credentials()
        url = reverse('list-and-create-users')
        data = {
            "first_name": "Arthur",
            "last_name": "Takeshi",
            "email": "takeshi@ufpa.br",
            "username": "takeshi@ufpa.br",
            "password": "arthur",
            "role": 2
        }
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(User.objects.count(), 1)
        self.assertEqual(User.objects.get().username, 'takeshi@ufpa.br')
        self.assertEqual(User.objects.get().password == 'arthur', False)

    def test_get_token(self):
        self.client.credentials()
        User.objects.create_user(username="takeshi@ufpa.br", email="takeshi@ufpa.br", password="arthur", role=0)
        url = reverse('access-token')
        data = {
            "username": "takeshi@ufpa.br",
            "password": "arthur"
        }
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual('token' in response.data, True)

    def test_update_user_put(self):
        User.objects.create_user(username="takeshi@ufpa.br", email="takeshi@ufpa.br", password="arthur", role=0)

        url = reverse('access-token')
        data = {
            "username": "takeshi@ufpa.br",
            "password": "arthur"
        }
        response = self.client.post(url, data, format='json')
        token = response.data['token']

        self.client.credentials(HTTP_AUTHORIZATION='Token ' + token)
        url = reverse('update-delete-users', args=[1])
        data = {
            "first_name": "Renan",
            "last_name": "Cunha",
            "email": "renan@ufpa.br",
            "username": "renan@ufpa.br",
            "password": "renan",
            "role": 1
        }
        response = self.client.put(url, data, format='json')
        response.data.pop('id')
        response.data.pop('password')
        data.pop('password')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(User.objects.count(), 1)
        self.assertEqual(response.data, data)

    def test_update_user_patch(self):
        self.client.credentials()
        User.objects.create_user(username="takeshi@ufpa.br", email="takeshi@ufpa.br", password="arthur", role=0)
        url = reverse('access-token')
        data = {
            "username": "takeshi@ufpa.br",
            "password": "arthur"
        }
        response = self.client.post(url, data, format='json')
        token = response.data['token']

        self.client.credentials(HTTP_AUTHORIZATION='Token ' + token)
        url = reverse('update-delete-users', args=[1])
        data = {
            "username": "renan@ufpa.br",
            "password": "renan",
            "role": 1
        }
        response = self.client.patch(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(User.objects.count(), 1)
        self.assertEqual(response.data['username'], 'renan@ufpa.br')

    def test_delete_user(self):
        self.client.credentials()
        User.objects.create_user(username="takeshi@ufpa.br", email="takeshi@ufpa.br", password="arthur", role=0)
        url = reverse('access-token')
        data = {
            "username": "takeshi@ufpa.br",
            "password": "arthur"
        }
        response = self.client.post(url, data, format='json')
        token = response.data['token']

        self.client.credentials(HTTP_AUTHORIZATION='Token ' + token)
        url = reverse('update-delete-users', args=[1])
        response = self.client.delete(url, data, format='json')

        self.assertEqual(User.objects.count(), 0)
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)

    def test_email_verification_200(self):
        user = User.objects.create_user(username="takeshi@ufpa.br", email="takeshi@ufpa.br", password="arthur", role=0, is_active=False)
        uidb64 = urlsafe_base64_encode(force_bytes(user.pk))
        token = default_token_generator.make_token(user)
        link = reverse('email-verification', kwargs={'uidb64': uidb64, 'token': token})
        response = self.client.get(link)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_email_verification_202(self):
        user = User.objects.create_user(username="takeshi@ufpa.br", email="takeshi@ufpa.br", password="arthur", role=0, is_active=True)
        uidb64 = urlsafe_base64_encode(force_bytes(user.pk))
        token = default_token_generator.make_token(user)
        link = reverse('email-verification', kwargs={'uidb64': uidb64, 'token': token})
        response = self.client.get(link)
        self.assertEqual(response.status_code, status.HTTP_202_ACCEPTED)

    def test_email_verification_400(self):
        user = User.objects.create_user(username="takeshi@ufpa.br", email="takeshi@ufpa.br", password="arthur", role=0, is_active=False)
        uidb64 = urlsafe_base64_encode(force_bytes(user.pk))
        token = 'fake-token-123'
        link = reverse('email-verification', kwargs={'uidb64': uidb64, 'token': token})
        response = self.client.get(link)
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_forgot_my_password(self):
        user = User.objects.create_user(username="takeshi@ufpa.br", email="takeshi@ufpa.br", password="arthur", role=0)
        user_old_password = user.password
        uidb64 = urlsafe_base64_encode(force_bytes(user.pk))
        token = PasswordResetTokenGenerator().make_token(user)
        link = reverse('reset-password', kwargs={'uidb64': uidb64, 'token': token})
        data = {
            "password": "new_password"
        }
        response = self.client.patch(link, data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertNotEqual(user_old_password, response.data['user']['password'])

    def test_forgot_my_password_400(self):
        user = User.objects.create_user(username="takeshi@ufpa.br", email="takeshi@ufpa.br", password="arthur", role=0)
        uidb64 = urlsafe_base64_encode(force_bytes(user.pk))
        token = 'fake_token_123'
        link = reverse('reset-password', kwargs={'uidb64': uidb64, 'token': token})
        data = {
            "password": "new_password"
        }
        response = self.client.patch(link, data)
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
