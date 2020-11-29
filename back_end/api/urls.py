from django.urls import include, path
from . import views

urlpatterns = [
  path('create_user', views.create_user),
  path('get_users', views.get_users),
  path('update_user/<int:profile_id>', views.update_user),
  path('create_class', views.create_class),
  path('get_classes', views.get_classes),
  path('update_class/<int:class_id>', views.update_class),
  path('delete_class/<int:class_id>', views.delete_class),
]