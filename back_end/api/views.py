import json
from rest_framework import status, serializers
from .serializers import ClassSerializer, UserSerializer, TextSerializer
from django.http import JsonResponse, Http404
from django.core.validators import validate_email
from django.core.exceptions import ValidationError, ObjectDoesNotExist
from .models import Text, Class, User
from django.shortcuts import render
from rest_framework import generics, mixins, status, permissions
from rest_framework.views import APIView
from rest_framework.response import Response
from django.core.exceptions import ObjectDoesNotExist
from rest_framework.decorators import api_view
from .permissions import IsClassTutor, IsOwner, IsTextCreator
from django.contrib.auth.hashers import make_password


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
    