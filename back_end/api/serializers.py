from rest_framework import serializers
from django.db import IntegrityError
from .models import Class, User, School, Text, Student, AudioFile


class UserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(required=True)
    local_id = serializers.IntegerField(required=True)

    class Meta:
        model = User
        fields = ['id', 'local_id', 'first_name', 'last_name', 'username',
                  'email', 'password', 'role']

    def create(self, validated_data):
        try:
            return User.objects.create_user(**validated_data, is_active=False)
        except IntegrityError as exception:
            raise exception


class SchoolSerializer(serializers.ModelSerializer):
    creator = serializers.ReadOnlyField(source='creator.username')
    local_id = serializers.IntegerField(required=True)

    class Meta:
        model = School
        fields = ['id', 'local_id', 'name', 'city', 'neighbourhood', 'state', 'zip_code',
                  'modality', 'creator']


class ClassSerializer(serializers.ModelSerializer):
    tutor = serializers.ReadOnlyField(source='tutor.username')
    local_id = serializers.IntegerField(required=True)

    class Meta:
        model = Class
        fields = ['id', 'local_id', 'title', 'tutor', 'grade', 'school']


class TextSerializer(serializers.ModelSerializer):
    local_id = serializers.IntegerField(required=True)

    class Meta:
        model = Text
        fields = ['id', 'local_id', 'title', 'body', '_class']


class StudentSerializer(serializers.ModelSerializer):
    local_id = serializers.IntegerField(required=True)

    class Meta:
        model = Student
        fields = ['id', 'local_id', 'first_name', 'last_name', '_class']


class AudioFileSerializer(serializers.ModelSerializer):
    local_id = serializers.IntegerField(required=True)

    class Meta:
        model = AudioFile
        fields = ['id', 'local_id', 'title', 'file', 'student', 'text']
