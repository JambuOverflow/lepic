from rest_framework import serializers
from django.db import IntegrityError
from .models import Class, User, School, Text, Student, AudioFile


class UserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(required=True)

    class Meta:
        model = User
        fields = ['id', 'first_name', 'last_name', 'username',
                  'email', 'password', 'role']

    def create(self, validated_data):
        try:
            return User.objects.create_user(**validated_data, is_active=False)
        except IntegrityError as exception:
            raise exception


class SchoolSerializer(serializers.ModelSerializer):
    creator = serializers.ReadOnlyField(source='creator.username')
    last_update = serializers.ReadOnlyField()

    class Meta:
        model = School
        fields = ['id', 'name', 'city', 'neighbourhood', 'state', 'zip_code', 
                  'modality', 'creator', 'local_id', 'deleted', 'last_update']


class ClassSerializer(serializers.ModelSerializer):
    tutor = serializers.ReadOnlyField(source='tutor.username')
    last_update = serializers.ReadOnlyField()

    class Meta:
        model = Class
        fields = ['id', 'title', 'tutor', 'grade', 'school', 'local_id',
                  'deleted', 'last_update']


class TextSerializer(serializers.ModelSerializer):
    last_update = serializers.ReadOnlyField()

    class Meta:
        model = Text
        fields = ['id', 'title', 'body', '_class', 'local_id', 'deleted', 
                 'last_update']

        
class StudentSerializer(serializers.ModelSerializer):
    last_update = serializers.ReadOnlyField()

    class Meta:
        model = Student
        fields = ['id', 'first_name', 'last_name', '_class', 'local_id', 
                  'deleted', 'last_update']


class AudioFileSerializer(serializers.ModelSerializer):
    last_update = serializers.ReadOnlyField()

    class Meta:
        model = AudioFile
        fields = ['id', 'title', 'file', 'student', 'text', 'local_id', 
                  'deleted', 'last_update']