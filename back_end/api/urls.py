from django.urls import include, path
from . import views

urlpatterns = [
  path('create_user', views.create_user),
  path('get_users', views.get_users),
  path('update_user/<int:profile_id>', views.update_user),
  path('createclass', views.create_class),
  path('getclasses/<int:user_id>', views.get_classes),
  path('updateclass/<int:class_id>', views.update_class),
  path('deleteclass/<int:class_id>', views.delete_class),
]