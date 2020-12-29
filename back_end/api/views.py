import json
from rest_framework import generics, mixins, status, permissions, serializers
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
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
from .permissions import IsClassTutor, IsOwner, IsTeacherOrReadOnly, IsTextCreator, IsTeacherOrReadOnlyAudioFile, IsCreator, IsTeacher
from .utils import EmailThread
from django.shortcuts import get_object_or_404


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


class UserCreate(generics.CreateAPIView,
                 generics.RetrieveAPIView):
    """
    Get authenticated user data or create a new user.
    EX: GET or POST /api/users/
    """
    serializer_class = UserSerializer
    queryset = User.objects.all()
    
    def get_object(self):
        return get_object_or_404(self.queryset, ('id', self.request.user.id))


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


class SchoolList(generics.ListCreateAPIView):
    """
    List texts of authenticated user or create a new text.
    EX: GET or POST /api/schools/
    """
    queryset = School.objects.all()
    serializer_class = SchoolSerializer
    permission_classes = [permissions.IsAuthenticated,
                          IsTeacher]
                          
    def perform_create(self, serializer):
        serializer.save(creator=self.request.user)


class SchoolDetail(generics.RetrieveUpdateDestroyAPIView):
    """
    Retrieve, update or delete a text instance.
    EX: GET or PUT or DELETE /api/schools/<int:pk>/
    """
    queryset = School.objects.all()
    serializer_class = SchoolSerializer
    permission_classes = [permissions.IsAuthenticated,
                          IsCreator]
    
    
class StudentList(generics.ListCreateAPIView):
    """
    List all students instances or create a new student instance.
    EX: GET or POST /api/students/
    """
    serializer_class = StudentSerializer
    permission_classes = [permissions.IsAuthenticated]
    queryset = Student.objects.all()

    def get_queryset(self):
        classes = Class.objects.filter(tutor=self.request.user.id)
        queryset = Student.objects.filter(_class__in=classes)
        return queryset

    def perform_create(self, serializer):
        class_tutor = Class.objects.filter(id=self.request.data['_class']).values_list('tutor', flat=True)
        if(self.request.user.id in class_tutor):
            serializer.save()
        else:
            raise PermissionDenied("You do not have the permission to create a student account with " +
        "a class where you are not the teacher", 'permission_denied')


class StudentDetail(generics.RetrieveUpdateDestroyAPIView):
    """
    Retrieve, update or delete a student instance.
    EX: GET, PUT, PATCH or DELETE /api/students/
    """
    serializer_class = StudentSerializer
    permission_classes = [permissions.IsAuthenticated, IsTeacherOrReadOnly]
    queryset = Student.objects.all()


class AudioFileList(generics.ListCreateAPIView):
    """
    List all audio file instances or create a new audio file instance.
    EX: GET or POST /api/audio-files/
    """
    parser_classes = [MultiPartParser, FormParser]
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = AudioFileSerializer
    queryset = AudioFile.objects.all()

    def perform_create(self, serializer):
        student_class = Student.objects.filter(id=self.request.data['student']).values_list('_class', flat=True)
        class_tutor = Class.objects.filter(id=student_class[0]).values_list('tutor', flat=True)
        if(self.request.user.id in class_tutor):
            serializer.save()
        else:
            raise PermissionDenied("You do not have the permission to upload students audio files from another class",
        'permission_denied')
        

class AudioFileDetail(generics.RetrieveUpdateDestroyAPIView):
    """
    Retrieve, update or delete a student instance.
    EX: GET, PUT, PATCH or DELETE /api/students/
    """
    parser_classes = [MultiPartParser, FormParser]
    permission_classes = [permissions.IsAuthenticated,IsTeacherOrReadOnlyAudioFile]
    serializer_class = AudioFileSerializer
    queryset = AudioFile.objects.all()