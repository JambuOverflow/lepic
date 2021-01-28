from django.urls import path
from . import views
from rest_framework.urlpatterns import format_suffix_patterns
from rest_framework.authtoken.views import ObtainAuthToken

urlpatterns = [
  path('students/', views.StudentList.as_view(), name='create-student'),
  path('students/<int:local_id>/', views.StudentDetail.as_view(), name='update-delete-students'),
  path('classes/', views.ClassCreate.as_view(), name='create-classes'),
  path('classes/<int:local_id>/', views.ClassDetail.as_view(), name='update-delete-class'),
  path('texts/', views.TextList.as_view(), name='create-text'),
  path('texts/<int:local_id>/', views.TextDetail.as_view(), name='update-delete-text'),
  path('users/', views.UserCreate.as_view(), name='list-and-create-users'),
  path('users/<int:pk>/', views.UserDetail.as_view(), name='update-delete-users'),
  path('schools/', views.SchoolList.as_view(), name='create-schools'),
  path('schools/<int:local_id>/', views.SchoolDetail.as_view(), name='update-delete-schools'),
  path('token-auth/', ObtainAuthToken.as_view(), name='access-token'),
  path('audio-file/', views.AudioFileList.as_view(), name='upload-file'),
  path('audio-file/<int:local_id>', views.AudioFileDetail.as_view(), name='update-delete-file'),
  path('verification/<str:uidb64>/<str:token>', views.EmailVerification.as_view(), name='email-verification'),
  path('forgot-my-password/', views.ForgotMyPassword.as_view(), name='request-reset-password'),
  path('forgot-my-password/<str:uidb64>/<str:token>/', views.ResetPassword.as_view(), name='reset-password')
] 

urlpatterns = format_suffix_patterns(urlpatterns)
