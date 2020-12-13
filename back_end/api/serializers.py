from rest_framework import serializers
from .models import Class, User, School, Text


class UserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(required=True)

    class Meta:
        model = User
        fields = ['id', 'local_id', 'first_name', 'last_name', 'username',
                  'email', 'password', 'role']

    def create(self, validated_data):
        return User.objects.create_user(**validated_data)


class SchoolSerializer(serializers.ModelSerializer):
    class Meta:
        model = School
        fields = ['id', 'name', 'city', 'neighbourhood', 'state', 'zip_code', 'flag_private']


class ClassSerializer(serializers.ModelSerializer):
    tutor = serializers.ReadOnlyField(source='tutor.username')
    
    class Meta:
        model = Class
        fields = ['id', 'title', 'tutor', 'grade']


class TextSerializer(serializers.ModelSerializer):
    class Meta:
        model = Text
        fields = ['body', '_class']
