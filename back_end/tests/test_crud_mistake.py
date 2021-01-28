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

class TestCRUDMistake(APITestCase):

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

        audio = open(Path(__file__).absolute().parent.parent / 'test_files/bensound-jazzyfrenchy.mp3', 'rb')
        #AudioFile.objects.create(title="Audio Test", text=text, student=student, file=audio_file, local_id=1, last_update=datetime.now(tz=pytz.utc))


        self.url_create_mistake = reverse('create-list-mistake')
        self.url_create_audio = reverse('upload-file')
        #self.url_update_delete_audio = reverse('update-delete-file', kwargs={'local_id': 1})
        
        self.mistake_data = [{
            'audio_file': 1,
            'word_index': 32,
            'commentary': 'text commentary',
            'local_id': 1
        }]

        self.audio_file_data = {
            'title': 'Test audio',
            'student': 1,
            'text': 1,
            'file': audio,
            'local_id': 1
        }

        '''self.audio_file_data_update = {
            'title': 'Test audio 2',
            'student': 1,
            'text': 1,
            'file': self.test_audio_file_2,
            'local_id': 2
        }'''
    
    def test_get_mistake(self):
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(self.token))
        response = self.client.get(self.url_create_mistake)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_create_mistake(self):
        self.client.credentials(HTTP_AUTHORIZATION='Token {}'.format(self.token))
        self.client.post(self.url_create_audio, self.audio_file_data, format='multipart')
        response = self.client.post(self.url_create_mistake, self.mistake_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)