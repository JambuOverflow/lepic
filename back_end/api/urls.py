from django.urls import include, path
from . import views

urlpatterns = [
  path('create_user', views.create_user),
  path('get_users', views.get_users),
  path('update_user/<int:profile_id>', views.update_user),

]