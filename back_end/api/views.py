import json
from rest_framework import generics, mixins, status, permissions, serializers
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.decorators import api_view
from rest_framework.exceptions import PermissionDenied
from rest_framework.parsers import MultiPartParser, FormParser
from django.http import JsonResponse, Http404
from django.db import IntegrityError
from django.urls import reverse
from django.shortcuts import render
from django.core.validators import validate_email
from django.core.exceptions import ValidationError, ObjectDoesNotExist
from django.core.mail import EmailMessage
from django.contrib.auth.hashers import make_password
from django.contrib.auth.tokens import default_token_generator, PasswordResetTokenGenerator
from django.contrib.sites.shortcuts import get_current_site
from django.utils.encoding import force_bytes, force_text, DjangoUnicodeDecodeError
from django.utils.http import urlsafe_base64_encode, urlsafe_base64_decode
from .serializers import ClassSerializer, UserSerializer, TextSerializer, StudentSerializer, AudioFileSerializer, SchoolSerializer
from .models import Text, Class, User, Student, AudioFile, School
from .permissions import IsClassTutor, IsOwner, IsTeacherOrReadOnly, IsTextCreator, IsTeacherOrReadOnlyAudioFile, IsCreator, IsTeacher, IsSupportProfessional
from .utils import EmailThread
from datetime import datetime
from django.shortcuts import get_object_or_404
import pytz


class EmailVerification(generics.GenericAPIView):
    """
    Verifies the verification token and user id, if are valid, set user state to active, if not, returns an error message.
    If the user state is already active, it returns a message to alert about it.
    EX: GET /api/email-verification/<base 64 id>/<verification token>
    """
    def get(self, request, uidb64, token):
        try:
            uid = urlsafe_base64_decode(uidb64).decode()
            user = User._default_manager.get(pk=uid)
        except(TypeError, ValueError, OverflowError, User.DoesNotExist):
            user = None
        if user.is_active:
            return Response({'detail': 'Your email was already verified, you do not have to verify it again.'}, status=status.HTTP_202_ACCEPTED)
        if user is not None and default_token_generator.check_token(user, token):
            user.is_active = True
            user.save()
            return Response({'detail': 'Your email was successfully verified!'}, status=status.HTTP_200_OK)
        else:
            return Response({'detail': 'Your email was not successfully verified, please check your verification link.'}, status=status.HTTP_400_BAD_REQUEST)


class ForgotMyPassword(generics.GenericAPIView):
    """
    Sends a valid email for password reset, to the email given inside the request body. If there is no user
    with that email in the database, then returns a Bad Request status with an error message.
    EX: POST /api/forgot-my-password/
    """
    def post(self, request):
        data = request.data
        email = data['email']
        user = User.objects.filter(email=email)

        if user.exists():
            current_domain = get_current_site(self.request).domain
            uidb64 = urlsafe_base64_encode(force_bytes(user[0].pk))
            token = PasswordResetTokenGenerator().make_token(user[0])
            link = reverse('reset-password', kwargs={'uidb64': uidb64, 'token': token})
            reset_url = 'http://' + current_domain + link

            email_subject = 'Password reset instructions'
            email_body = f'Hi {user[0].first_name},\nYou have made a request to reset your password, please use this link to do it:\n\n{reset_url}\n\nIf it were not you, please ignore this email.'
            email = EmailMessage(
                email_subject,
                email_body,
                to=[user[0].email],
            )
            EmailThread(email).start()
            return Response({'success_message': 'We have sent you an email to update your password, please check it out.'}, status=status.HTTP_200_OK)
        else:
            return Response({'error_message': 'This email is not registered in our database, please send an email already registered'}, status=status.HTTP_400_BAD_REQUEST)


class ResetPassword(generics.GenericAPIView):
    """
    Verifies the token and user id validity, and if are valid, reset the user password to the given one inside the request body.
    If are not valid, returns a Bad Request status and an error message.
    EX: PATCH /api/forgot-my-password/<uidb64>/<token>/
    """
    def patch(self, request, uidb64, token):
        try:
            uid = urlsafe_base64_decode(uidb64).decode()
            user = User._default_manager.get(pk=uid)
        except(TypeError, ValueError, OverflowError, User.DoesNotExist):
            user = None
        if user is not None and PasswordResetTokenGenerator().check_token(user, token):
            user.set_password(request.data['password'])
            user.save()
            return Response({'success_message': 'Your password was successfully reseted!',
                            'user': { 'password': user.password } }, status=status.HTTP_200_OK)
        else:
            return Response({'error_message': 'Your password was not successfully reseted, please check your reset link.'}, status=status.HTTP_400_BAD_REQUEST)


class UserList(generics.ListCreateAPIView):
    """
    Lists all users and creates a new user
    EX: GET /api/users/
        POST /api/users/
    """
    queryset = User.objects.all()
    serializer_class = UserSerializer

    def perform_create(self, serializer):
        try:
            user = serializer.save()
            current_domain = get_current_site(self.request).domain
            uidb64 = urlsafe_base64_encode(force_bytes(user.pk))
            token = default_token_generator.make_token(user)
            link = reverse('email-verification', kwargs={'uidb64': uidb64, 'token': token})
            activate_url = 'http://' + current_domain + link

            email_subject = 'Activate your account.'
            email_body = f'Hi {user.first_name},\nPlease use this link to verify your account:\n{activate_url}'
            email = EmailMessage(
                email_subject,
                email_body,
                to=[user.email],
            )
            EmailThread(email).start()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        except IntegrityError as exception:
            return Response({"email": ["user with this email address already exists."],
                            'exception_message': exception}, status.HTTP_400_BAD_REQUEST)


    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.initial_data['email'] = serializer.initial_data['email'].lower()
        serializer.is_valid(raise_exception=True)
        response = self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        return Response(response.data, response.status_code, headers=headers)


class UserDetail(generics.RetrieveUpdateDestroyAPIView):
    """
    Read, Update and Delete an specific user only if the request was made by this user
    EX: GET /api/users/<id>/
        PUT or PATCH /api/users/<id>/
        DELETE /api/users/<id>/
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
    For last_sync GET use /api/classes/?last_sync=[TIME]
    EX: GET or POST /api/classes/
    """
    permission_classes = [permissions.IsAuthenticated,
                          IsTeacher]
    serializer_class = ClassSerializer

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data, many=True)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)


    def get_queryset(self):
        user = self.request.user   
        last_sync = self.request.query_params.get('last_sync')
        if last_sync:
            return Class.objects.filter(tutor=user, deleted=0, 
                                        last_update__gte=last_sync)
        return Class.objects.filter(tutor=user, deleted=0)


    def perform_create(self, serializer):
        serializer.save(tutor=self.request.user, last_update=datetime.now(tz=pytz.utc))


class ClassDetail(generics.RetrieveUpdateAPIView):
    """
    Retrieve or update a class of authenticated tutor.
    EX: GET or PUT or PATCH /api/classes/<int:local_id>/
    """
    queryset = Class.objects.all()
    serializer_class = ClassSerializer
    permission_classes = [permissions.IsAuthenticated,
                          IsClassTutor]
    
    def get_object(self, **kwargs):
        queryset = self.get_queryset()
        obj = get_object_or_404(queryset, ('local_id', self.kwargs['local_id']))
        self.check_object_permissions(self.request, obj)
        return obj

    
    def perform_update(self, serializer):
        serializer.save(last_update=datetime.now(tz=pytz.utc))


class TextList(generics.ListCreateAPIView):
    """
    List texts of authenticated user or create a new text.
    For last_sync GET use /api/texts/?last_sync=[TIME]
    EX: GET or POST /api/texts/
    """
    permission_classes = [permissions.IsAuthenticated,
                          IsTeacher|IsSupportProfessional]
    serializer_class = TextSerializer

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data, many=True)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)


    def get_queryset(self):
        user = self.request.user   
        classes = Class.objects.filter(tutor=user)
        last_sync = self.request.query_params.get('last_sync')
        if last_sync:
            return Text.objects.filter(_class__in=classes, deleted=0,
                                       last_update__gte=last_sync)
        return Text.objects.filter(_class__in=classes, deleted=0)


    def perform_create(self, serializer):
        serializer.save(last_update=datetime.now(tz=pytz.utc))



class TextDetail(generics.RetrieveUpdateAPIView):
    """
    Retrieve or update a text of authenticated user.
    EX: GET or PUT or PATCH /api/texts/<int:local_id>/
    """
    queryset = Text.objects.all()
    serializer_class = TextSerializer
    permission_classes = [permissions.IsAuthenticated,
                          IsTextCreator]

    def get_object(self, **kwargs):
        queryset = self.get_queryset()
        obj = get_object_or_404(queryset, ('local_id', self.kwargs['local_id']))
        self.check_object_permissions(self.request, obj)
        return obj

    
    def perform_update(self, serializer):
        serializer.save(last_update=datetime.now(tz=pytz.utc))


class SchoolList(generics.ListCreateAPIView):
    """
    List schools of authenticated user or create a new school.
    For last_sync GET use /api/schools/?last_sync=[TIME]
    EX: GET or POST /api/schools/
    """
    queryset = School.objects.all()
    serializer_class = SchoolSerializer
    permission_classes = [permissions.IsAuthenticated,
                          IsTeacher|IsSupportProfessional]

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data, many=True)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)


    def get_queryset(self):
        user = self.request.user   
        last_sync = self.request.query_params.get('last_sync')
        if last_sync:
            return School.objects.filter(creator=user, deleted=0, 
                                         last_update__gte=last_sync)
        return School.objects.filter(creator=user, deleted=0)
                          

    def perform_create(self, serializer):
        serializer.save(creator=self.request.user, last_update=datetime.now(tz=pytz.utc))


class SchoolDetail(generics.RetrieveUpdateAPIView):
    """
    Retrieve or update a school.
    EX: GET or PUT or PATCH /api/schools/<int:local_id>/
    """
    queryset = School.objects.all()
    serializer_class = SchoolSerializer
    permission_classes = [permissions.IsAuthenticated,
                          IsCreator]

    def get_object(self, **kwargs):
        queryset = self.get_queryset()
        obj = get_object_or_404(queryset, ('local_id', self.kwargs['local_id']))
        self.check_object_permissions(self.request, obj)
        return obj

    
    def perform_update(self, serializer):
        serializer.save(last_update=datetime.now(tz=pytz.utc))
    
    
class StudentList(generics.ListCreateAPIView):
    """
    List students of authenticated user or create a new student.
    For last_sync GET use /api/students/?last_sync=[TIME]
    EX: GET or POST or PATCH /api/students/
    """
    serializer_class = StudentSerializer
    permission_classes = [permissions.IsAuthenticated, 
                          IsTeacher|IsSupportProfessional]

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data, many=True)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)


    def get_queryset(self):
        classes = Class.objects.filter(tutor=self.request.user.id)
        last_sync = self.request.query_params.get('last_sync')
        if last_sync:
            return Student.objects.filter(_class__in=classes, deleted=0, 
                                          last_update__gte=last_sync)
        return Student.objects.filter(_class__in=classes, deleted=0)


    def perform_create(self, serializer):
        for class_ in self.request.data:
            class_tutor = Class.objects.filter(id=class_['_class']).values_list('tutor', flat=True)
            if(self.request.user.id in class_tutor):
                serializer.save(last_update=datetime.now(tz=pytz.utc))
            else:
                raise PermissionDenied("You do not have the permission to create a student account with " +
            "a class where you are not the teacher", 'permission_denied')


class StudentDetail(generics.RetrieveUpdateAPIView):
    """
    Retrieve or update a student of an authenticated user.
    EX: GET or PUT or PATCH /api/students/<int:local_id>/
    """
    serializer_class = StudentSerializer
    permission_classes = [permissions.IsAuthenticated, 
                          IsTeacherOrReadOnly|IsSupportProfessional]
    queryset = Student.objects.all()

    def get_object(self, **kwargs):
        queryset = self.get_queryset()
        obj = get_object_or_404(queryset, ('local_id', self.kwargs['local_id']))
        self.check_object_permissions(self.request, obj)
        return obj

    
    def perform_update(self, serializer):
        serializer.save(last_update=datetime.now(tz=pytz.utc))


class AudioFileList(generics.ListCreateAPIView):
    """
    List all audio files or create a new audio file.
    For last_sync GET use /api/audio-files/?last_sync=[TIME]
    EX: GET or POST /api/audio-files/
    """
    parser_classes = [MultiPartParser, FormParser]
    permission_classes = [permissions.IsAuthenticated,
                          IsTeacher|IsSupportProfessional]
    serializer_class = AudioFileSerializer

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)


    def get_queryset(self):
        last_sync = self.request.query_params.get('last_sync')

        if last_sync:
            return AudioFile.objects.filter(deleted=0, last_update__gte=last_sync)
        return AudioFile.objects.filter(deleted=0)


    def perform_create(self, serializer):
        student_class = Student.objects.filter(id=self.request.data['student']).values_list('_class', flat=True)
        class_tutor = Class.objects.filter(id=student_class[0]).values_list('tutor', flat=True)
        if(self.request.user.id in class_tutor):
            serializer.save(last_update=datetime.now(tz=pytz.utc))
        else:
            raise PermissionDenied("You do not have the permission to upload students audio files from another class",
        'permission_denied')

        
class AudioFileDetail(generics.RetrieveUpdateAPIView):
    """
    Retrieve or update an audio file.
    EX: GET or PUT or PATCH /api/students/<int:local_id>/
    """
    parser_classes = [MultiPartParser, FormParser]
    permission_classes = [permissions.IsAuthenticated,
                          IsTeacherOrReadOnlyAudioFile|IsSupportProfessional]
    serializer_class = AudioFileSerializer
    queryset = AudioFile.objects.all()

    def get_object(self, **kwargs):
        queryset = self.get_queryset()
        obj = get_object_or_404(queryset, ('local_id', self.kwargs['local_id']))
        self.check_object_permissions(self.request, obj)
        return obj

    
    def perform_update(self, serializer):
        serializer.save(last_update=datetime.now(tz=pytz.utc))