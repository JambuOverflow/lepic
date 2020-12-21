from django.urls import include, path
from . import views
from rest_framework.urlpatterns import format_suffix_patterns
from rest_framework.authtoken.views import ObtainAuthToken

urlpatterns = [
  path('students/', views.StudentList.as_view(), name='create-student'),
  path('students/<int:pk>/', views.StudentDetail.as_view(), name='update-delete-students'),
  path('classes/', views.ClassCreate.as_view(), name='create-classes'),
  path('classes/<int:pk>/', views.ClassDetail.as_view(), name='update-delete-class'),
  path('texts/', views.TextList.as_view(), name='create-text'),
  path('texts/<int:pk>/', views.TextDetail.as_view(), name='update-delete-text'),
  path('users/', views.UserList.as_view(), name='list-and-create-users'),
  path('users/<int:pk>/', views.UserDetail.as_view(), name='update-delete-users'),
  path('schools/', views.SchoolList.as_view(), name='create-schools'),
  path('schools/<int:pk>/', views.SchoolDetail.as_view(), name='update-delete-schools'),
  path('token-auth/', ObtainAuthToken.as_view(), name='access-token'),
  path('audio-file/', views.AudioFileList.as_view(), name='upload-file'),
  path('audio-file/<int:pk>', views.AudioFileDetail.as_view(), name='update-delete-file'),
] 

urlpatterns = format_suffix_patterns(urlpatterns)
