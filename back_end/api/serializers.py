from rest_framework import serializers
from .models import Class, User, School, Text


class UserSerializer(serializers.ModelSerializer):

    class Meta:
        model = User
        fields = ['id', 'first_name', 'last_name', 'email', 'username', 'password', 'user_role']


class SchoolSerializer(serializers.ModelSerializer):
    class Meta:
        model = School
        fields = ['id', 'name', 'city', 'neighbourhood', 'state', 'zip_code', 'flag_private']


class ClassSerializer(serializers.ModelSerializer):
    class Meta:
        model = Class
        fields = ['id', 'title', 'tutor', 'grade']


class TextSerializer(serializers.ModelSerializer):
    class Meta:
        model = Text
        fields = ['body', '_class']
