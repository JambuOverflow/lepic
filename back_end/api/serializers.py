from rest_framework import serializers
from .models import Class, User, School, Text, Student


class UserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(required=True)

    class Meta:
        model = User
        fields = ['id', 'first_name', 'last_name', 'username',
                  'email', 'password', 'role']

    def create(self, validated_data):
        return User.objects.create_user(**validated_data)


class SchoolSerializer(serializers.ModelSerializer):
    creator = serializers.ReadOnlyField(source='creator.username')
    class Meta:
        model = School
        fields = ['id', 'name', 'city', 'neighbourhood', 'state', 'zip_code', 'modality', 'creator']


class ClassSerializer(serializers.ModelSerializer):
    tutor = serializers.ReadOnlyField(source='tutor.username')
    class Meta:
        model = Class
        fields = ['id', 'title', 'tutor', 'grade', 'school']


class TextSerializer(serializers.ModelSerializer):
    class Meta:
        model = Text
        fields = ['id', 'title', 'body', '_class']
        
class StudentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Student
        fields = ['first_name', 'last_name', '_class']