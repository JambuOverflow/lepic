from django.urls import include, path
from . import views
from rest_framework.urlpatterns import format_suffix_patterns
from rest_framework.authtoken.views import ObtainAuthToken

urlpatterns = [
  path('classes/', views.ClassCreate.as_view(), name='create-classes'),
  path('classes/<int:pk>/', views.ClassDetail.as_view()),
  path('texts/', views.TextList.as_view(), name='create-text'),
  path('texts/<int:pk>/', views.TextDetail.as_view()),
  path('users/', views.UserList.as_view(), name='list-and-create-users'),
  path('users/<int:pk>/', views.UserDetail.as_view(), name='update-delete-users'),
  path('token-auth/', ObtainAuthToken.as_view(), name='access-token'),
] 

urlpatterns = format_suffix_patterns(urlpatterns)
