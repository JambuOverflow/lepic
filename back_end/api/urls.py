from django.urls import include, path
from . import views
from rest_framework.urlpatterns import format_suffix_patterns
from rest_framework.authtoken.views import obtain_auth_token

urlpatterns = [
  path('classes/', views.ClassCreate.as_view()),
  path('classes/<int:pk>/', views.ClassDetail.as_view()),
  path('texts/', views.TextCreate.as_view()),
  path('texts/<int:pk>', views.TextDetail.as_view()),
  path('tutor/<int:pk_tutor>/texts', views.ListTutorTexts.as_view()),
  path('tutor/<int:pk_tutor>/classes', views.ListTutorClasses.as_view()),
  path('users/', views.UserList.as_view(), name='list-and-create-users'),
  path('users/<int:pk>/', views.UserDetail.as_view(), name='update-delete-users'),
  path('token-auth/', obtain_auth_token, name='get-user-token'),
] 

urlpatterns = format_suffix_patterns(urlpatterns)

'''urlpatterns += [
    path('auth/', include('rest_framework.urls')),
]'''
