from rest_framework.test import APITestCase, APIClient
from django.urls import reverse
from rest_framework import status
from rest_framework.authtoken.models import Token
from api.models import User, Student, Class, AudioFile, Text, School
from pathlib import Path
from django.core.files import File
import re
from datetime import datetime
import pytz

class TestCRUDAudioFile(APITestCase):

    def setUp(self):
        user = User.objects.create_user(username = 'pedro', password = 'pedro', email = 'pedro@ufpa.br', role = 0)
        self.token = Token.objects.create(user=user)

        user_2 = User.objects.create_user(username = 'aian', password = 'shay', email = 'naia@ufpa.br', role = 0)
        self.token_2 = Token.objects.create(user=user_2)

        school = School.objects.create(name="Escola Municipal", city="Sao Paulo", neighbourhood="Itaim Bibi",
                                        state="SP", zip_code=60000000, modality=1, creator=user, local_id=0, last_update=datetime.now(tz=pytz.utc))
        _class = Class.objects.create(tutor=user, grade=7, title='Class A', school=school, local_id=0, last_update=datetime.now(tz=pytz.utc))
        Student.objects.create(_class=_class, first_name='Arthur', last_name='Takeshi', local_id=0, last_update=datetime.now(tz=pytz.utc))
        Text.objects.create(title='Excerpt from The Little Prince', body='"Anything essential is invisible to the eyes," ' +
                            'the little prince repeated, in order to remember. "It’s the time you spend on your rose that makes your rose so important." ' + 
                            '"It’s the time I spent on my rose…," the little prince repeated, in order to remember.',
                            _class=_class, local_id=0, last_update=datetime.now(tz=pytz.utc))

        self.test_audio_file = open(Path(__file__).absolute().parent.parent / 'test_files/bensound-jazzyfrenchy.mp3', 'rb')
        self.test_audio_file_2 = open(Path(__file__).absolute().parent.parent / 'test_files/test-audiofile2.mp3', 'rb')
        test_audio_file_deleted = open(Path(__file__).absolute().parent.parent / 'test_files/bensound-jazzyfrenchy.mp3', 'rb')

        self.url_create_audio = reverse('upload-file')
        self.url_update_delete_audio = reverse('update-delete-file', kwargs={'local_id': 1})
        
        self.audio_file_data = {
            'title': 'Test audio',
            'student': 1,
            'text': 1,
            'local_id': 1,
            'file': self.test_audio_file,
            'reading_time':'00:01:21',
            'words_per_minute':15
        }

        self.audio_file_data_deleted = {
            'title': 'Test audio',
            'student': 1,
            'text': 1,
            'file': test_audio_file_deleted,
            'deleted': 1,
            'local_id': 1,
            'reading_time':'00:00:57',
            'words_per_minute':23
        }

        self.audio_file_data_update = {
            'title': 'Test audio 2',
            'student': 1,
            'text': 1,
            'file': self.test_audio_file_2,
            'local_id': 2,
            'reading_time':'00:01:15',
            'words_per_minute':27,
            'correct_words':48,
            'mispelled_words':9
        }
    
    def test_get_audio_file(self):
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(self.token))
        response = self.client.get(self.url_create_audio)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_create_audio_file(self):
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(self.token))
        response = self.client.post(self.url_create_audio, self.audio_file_data, format='multipart')
        response.data.pop('id')
        response.data.pop('deleted')
        response.data.pop('last_update')
        audio_link = response.data.pop('file')
        regex_match = re.compile('http://.*/media/.*.mp3').match(audio_link).group()
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(response.data, {
            'title': 'Test audio',
            'student': 1,
            'text': 1,
            'local_id': 1,
            'reading_time':'00:01:21',
            'words_per_minute':15,
            'correct_words': None,
            'mispelled_words': None
        })
        self.assertEqual(audio_link, regex_match)

    def test_create_audio_file_from_another_class(self):
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(self.token_2))
        response = self.client.post(self.url_create_audio, self.audio_file_data, format='multipart')
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(response.data['detail'], "You do not have the permission to upload students audio files from another class")
    
    def test_update_audio_file(self):
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(self.token))
        self.client.post(self.url_create_audio, self.audio_file_data, format='multipart')
        response = self.client.put(self.url_update_delete_audio, self.audio_file_data_update, format='multipart')
        self.audio_file_data_update.pop('file')
        response.data.pop('id')
        response.data.pop('deleted')
        response.data.pop('last_update')
        audio_link = response.data.pop('file')
        regex_match = re.compile('http://.*/media/.*.mp3').match(audio_link).group()
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data, self.audio_file_data_update)
        self.assertEqual(audio_link, regex_match)

    def test_update_audio_file_from_another_class(self):
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(self.token))
        self.client.post(self.url_create_audio, self.audio_file_data, format='multipart')
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(self.token_2))
        response = self.client.put(self.url_update_delete_audio, self.audio_file_data_update, format='multipart')
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(response.data['detail'], "You do not have permission to perform this action.")

    def test_delete_audio_file(self):
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(self.token))
        self.client.post(self.url_create_audio, self.audio_file_data, format='multipart')
        response = self.client.put(self.url_update_delete_audio, self.audio_file_data_deleted, format='multipart')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_delete_audio_file_from_another_class(self):
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(self.token))
        self.client.post(self.url_create_audio, self.audio_file_data, format='multipart')
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(self.token_2))
        response = self.client.put(self.url_update_delete_audio, self.audio_file_data_deleted, format='multipart')
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(response.data['detail'], "You do not have permission to perform this action.")