from django.db import models
from django.core.validators import validate_email
from django.contrib.auth.models import AbstractUser
from django.db.models.deletion import CASCADE
from django.db.models.fields import CharField
from django.db.models.signals import post_save
from django.dispatch import receiver


class User(AbstractUser):
    USER_ROLE_CHOICES = (
        (1, 'teacher'),
        (2, 'support professional'),
        (3, 'researcher'),
    )

    user_role = models.PositiveSmallIntegerField(choices=USER_ROLE_CHOICES)

class School(models.Model):
    name = models.CharField(max_length=100)
    city = models.CharField(max_length=30)
    neighbourhood = models.CharField(max_length=30)
    state = models.CharField(max_length=2)
    zip_code = models.IntegerField()
    flag_private = models.BooleanField()


class Class(models.Model):
    tutor = models.ForeignKey(User, on_delete=models.CASCADE)
    # school = models.ForeignKey(School, on_delete=CASCADE)
    grade = models.IntegerField()
    title = models.CharField(max_length=50)

    def __str__(self):
        return self.title


class Text(models.Model):
    title = models.CharField(max_length=50)
    body = models.CharField(max_length=1000)
    _class = models.ForeignKey(Class, on_delete=models.CASCADE)

    def __str__(self):
        return self.title