import json

from rest_framework import generics, mixins, status, permissions, status, serializers, viewsets
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.decorators import api_view
from rest_framework.exceptions import PermissionDenied
from rest_framework.parsers import MultiPartParser, FormParser

from django.http import JsonResponse, Http404
from django.shortcuts import render
from django.contrib.auth.hashers import make_password
from django.core.validators import validate_email
from django.core.exceptions import ValidationError, ObjectDoesNotExist
from django.core.exceptions import ObjectDoesNotExist

from .serializers import ClassSerializer, UserSerializer, TextSerializer, StudentSerializer, AudioFileSerializer
from .models import Text, Class, User, Student, AudioFile
from .permissions import IsClassTutor, IsOwner, IsTeacherOrReadOnly, IsTextCreator


class UserList(generics.ListCreateAPIView):
    """
    Lists all users and creates a new user
    EX: GET /api/users/
        POST /api/users/
    """
    queryset = User.objects.all()
    serializer_class = UserSerializer


class UserDetail(generics.RetrieveUpdateDestroyAPIView):
    """
    Read, Update and Delete an specific user only if the request was made by this user
    EX: GET /api/users/<id>
        PUT or PATCH /api/users/<id>
        DELETE /api/users/<id>
    """
    permission_classes = [permissions.IsAuthenticated, IsOwner]
    queryset = User.objects.all()
    serializer_class = UserSerializer

    def perform_update(self, serializer):
        if('password' in self.request.data):
            password = make_password(self.request.data['password'])
            serializer.save(password=password)
        else:
            serializer.save()


class ClassCreate(generics.ListCreateAPIView):
    """
    List classes of authenticated user or create a new class.
    """
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = ClassSerializer
    
    def get_queryset(self):
        user = self.request.user
        return Class.objects.filter(tutor=user)
    
    def perform_create(self, serializer):
        serializer.save(tutor=self.request.user)


class ClassDetail(generics.RetrieveUpdateDestroyAPIView):
    """
    Retrieve, update or delete a class instance of authenticated tutor.
    EX: GET or PUT or DELETE /api/classes/<int:pk>/
    """
    queryset = Class.objects.all()
    serializer_class = ClassSerializer
    permission_classes = [permissions.IsAuthenticated,
                          IsClassTutor]


class TextList(generics.ListCreateAPIView):
    """
    List texts of authenticated user or create a new text.
    EX: GET or POST /api/texts/
    """
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = TextSerializer
    
    def get_queryset(self):
        classes = Class.objects.filter(tutor=self.request.user.id)
        queryset = Text.objects.filter(_class__in=classes)
        return queryset


class TextDetail(generics.RetrieveUpdateDestroyAPIView):
    """
    Retrieve, update or delete a text instance.
    EX: GET or PUT or DELETE /api/texts/<int:pk>/
    """
    queryset = Text.objects.all()
    serializer_class = TextSerializer
    permission_classes = [permissions.IsAuthenticated,
                          IsTextCreator]


class StudentList(generics.ListCreateAPIView):
    serializer_class = StudentSerializer
    permission_classes = [permissions.IsAuthenticated]
    queryset = Student.objects.all()

    def get_queryset(self):
        classes = Class.objects.filter(tutor=self.request.user.id)
        queryset = Student.objects.filter(_class__in=classes)
        return queryset

    def perform_create(self, serializer):
        classes = Class.objects.filter(tutor=self.request.user.id).values_list('tutor', flat=True)
        if(self.request.user.id in classes):
            serializer.save()
        else:
            raise PermissionDenied("You do not have the permission to create a student account with " +
        "a class where you are not the teacher", 'permission_denied')


class StudentDetail(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = StudentSerializer
    permission_classes = [permissions.IsAuthenticated, IsTeacherOrReadOnly]
    queryset = Student.objects.all()

class AudioFileList(generics.ListCreateAPIView):
    parser_classes = [MultiPartParser, FormParser]
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = AudioFileSerializer
    queryset = AudioFile.objects.all()