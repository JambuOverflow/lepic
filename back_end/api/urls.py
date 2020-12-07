from django.urls import include, path
from . import views
from rest_framework.urlpatterns import format_suffix_patterns

urlpatterns = [
  path('create_user', views.create_user),
  path('get_users', views.get_users),
  path('update_user/<int:profile_id>', views.update_user),
  path('test/<int:primary_key>', views.LepicUser.as_view()),
  path('classes/', views.ClassCreate.as_view()),
  path('classes/<int:pk>/', views.ClassDetail.as_view()),
  path('texts/', views.TextCreate.as_view()),
  path('texts/<int:pk>', views.TextDetail.as_view()),
  path('tutor/<int:pk_tutor>/texts', views.ListTutorTexts.as_view()),
  path('tutor/<int:pk_tutor>/classes', views.ListTutorClasses.as_view()),
  path('users/', views.UserList.as_view()),
  path('users/<int:pk>/', views.UserDetail.as_view()),
] 

urlpatterns = format_suffix_patterns(urlpatterns)

urlpatterns += [
    path('auth/', include('rest_framework.urls')),
]
