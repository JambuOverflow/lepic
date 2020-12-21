from rest_framework.test import APITestCase, APIClient
from django.urls import reverse
from rest_framework import status
from rest_framework.authtoken.models import Token
from api.models import User, Student, Class, AudioFile, Text, School
from pathlib import Path
from django.core.files import File
import re

class TestCRUDAudioFile(APITestCase):

    def setUp(self):
        self.url_create_audio = reverse('upload-file')
        self.url_update_delete_audio = reverse('update-delete-file', args=[1])
        self.test_audio_file = open(Path(__file__).absolute().parent.parent / 'test_files/bensound-jazzyfrenchy.mp3', 'rb')
        self.test_audio_file_2 = open(Path(__file__).absolute().parent.parent / 'test_files/test-audiofile2.mp3', 'rb')
        self.audio_file_data = {
            'title': 'Test audio',
            'student': 1,
            'text': 1,
            'file': self.test_audio_file
        }
        self.user = User.objects.create_user(username = 'pedro', password = 'pedro', email = 'pedro@ufpa.br', role = 0)
        self.user_2 = User.objects.create_user(username = 'renan', password = 'renan', email = 'renan@ufpa.br', role = 0)
        self.school = School.objects.create(name="Escola Municipal", city="Sao Paulo", neighbourhood="Itaim Bibi",
                                       state="SP", zip_code=60000000, modality=1, creator=self.user)
        self.first_class = Class.objects.create(tutor=self.user, grade=7, title='Class A', school=self.school)
        self.student_1 = Student.objects.create(_class=self.first_class, first_name='Arthur', last_name='Takeshi')
        self.student_2 = Student.objects.create(_class=self.first_class, first_name='Aian', last_name='Shay')
        self.text_1 = Text.objects.create(title='Excerpt from The Little Prince', body='"Anything essential is invisible to the eyes," ' +
                                        'the little prince repeated, in order to remember. "It’s the time you spend on your rose that makes your rose so important." ' + 
                                        '"It’s the time I spent on my rose…," the little prince repeated, in order to remember.',
                                        _class=self.first_class)
        self.text_2 = Text.objects.create(title='Puss in Boots summary', body='A miller died and left his three sons all he had: he left ' + 
                                        'his mill to his eldest son, an ass to the middle son, and to the youngest son, he left his cat.',
                                        _class=self.first_class)
    
    def test_get_audio_file(self):
        token = Token.objects.create(user=self.user)
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(token))
        response = self.client.get(self.url_create_audio)
        self.assertEqual(response.data, [])
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_create_audio_file(self):
        token = Token.objects.create(user=self.user)
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(token))
        response = self.client.post(self.url_create_audio, self.audio_file_data, format='multipart')
        response.data.pop('id')
        audio_link = response.data.pop('file')
        regex_match = re.compile('http://.*/media/.*.mp3').match(audio_link).group()
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(response.data, {
            'title': 'Test audio',
            'student': 1,
            'text': 1
        })
        self.assertEqual(audio_link, regex_match)

    def test_create_audio_file_from_another_class(self):
        token = Token.objects.create(user=self.user_2)
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(token))
        response = self.client.post(self.url_create_audio, self.audio_file_data, format='multipart')
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(response.data['detail'], "You do not have the permission to upload students audio files from another class")
        self.assertEqual(AudioFile.objects.count(), 0)
    
    def test_update_audio_file_put(self):
        token = Token.objects.create(user=self.user)
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(token))
        self.client.post(self.url_create_audio, self.audio_file_data, format='multipart')
        file_new_data = {
            'title': 'Test audio 2',
            'student': 2,
            'text': 2,
            'file': self.test_audio_file_2
        }
        response = self.client.put(self.url_update_delete_audio, file_new_data, format='multipart')
        file_new_data.pop('file')
        response.data.pop('id')
        audio_link = response.data.pop('file')
        regex_match = re.compile('http://.*/media/.*.mp3').match(audio_link).group()
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data, file_new_data)
        self.assertEqual(audio_link, regex_match)

    def test_update_audio_file_put_from_another_class(self):
        token = Token.objects.create(user=self.user)
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(token))
        self.client.post(self.url_create_audio, self.audio_file_data, format='multipart')
        file_new_data = {
            'title': 'Test audio 2',
            'student': 2,
            'text': 2,
            'file': self.test_audio_file_2
        }
        token = Token.objects.create(user=self.user_2)
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(token))
        response = self.client.put(self.url_update_delete_audio, file_new_data, format='multipart')
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertTrue('Test audio' in AudioFile.objects.filter(id=1).values_list('title', flat=True))
        self.assertEqual(response.data['detail'], "You do not have permission to perform this action.")

    def test_update_audio_file_patch(self):
        token = Token.objects.create(user=self.user)
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(token))
        self.client.post(self.url_create_audio, self.audio_file_data, format='multipart')
        file_new_data = {
            'file': self.test_audio_file_2
        }
        response = self.client.patch(self.url_update_delete_audio, file_new_data, format='multipart')
        response.data.pop('id')
        audio_link = response.data.pop('file')
        regex_match = re.compile('http://.*/media/.*.mp3').match(audio_link).group()
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(audio_link, regex_match)

    def test_update_audio_file_patch_from_another_class(self):
        token = Token.objects.create(user=self.user)
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(token))
        self.client.post(self.url_create_audio, self.audio_file_data, format='multipart')
        file_new_data = {
            'file': self.test_audio_file_2
        }
        token = Token.objects.create(user=self.user_2)
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(token))
        response = self.client.patch(self.url_update_delete_audio, file_new_data, format='multipart')
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(response.data['detail'], "You do not have permission to perform this action.")

    def test_update_audio_file_delete(self):
        token = Token.objects.create(user=self.user)
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(token))
        self.client.post(self.url_create_audio, self.audio_file_data, format='multipart')
        response = self.client.delete(self.url_update_delete_audio, format='multipart')
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        self.assertEqual(AudioFile.objects.count(), 0)

    def test_update_audio_file_delete_from_another_class(self):
        token = Token.objects.create(user=self.user)
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(token))
        self.client.post(self.url_create_audio, self.audio_file_data, format='multipart')
        token = Token.objects.create(user=self.user_2)
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(token))
        response = self.client.delete(self.url_update_delete_audio, format='multipart')
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(response.data['detail'], "You do not have permission to perform this action.")
        self.assertEqual(AudioFile.objects.count(), 1)