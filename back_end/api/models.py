from django.db import models
from django.core.validators import validate_email
from django.contrib.auth.models import User
from django.db.models.deletion import CASCADE
from django.db.models.fields import CharField
from django.db.models.signals import post_save
from django.dispatch import receiver


class Profile(models.Model):
    owner = models.ForeignKey('auth.User', on_delete=models.CASCADE)

    ROLES = (
        (0, 'teacher'),
        (1, 'professional'),
        (2, 'researcher'),
    )
    role = models.SmallIntegerField(choices=ROLES, default=0)

    def __str__(self):
        return {
            "role": self.role
            }


class School(models.Model):
    name = models.CharField(max_length=200)
    city = models.CharField(max_length=30)
    neighbourhood = models.CharField(max_length=30)
    state = models.CharField(max_length=2)
    zip_code = models.IntegerField(max_length=8)
    flag_private = models.BooleanField()


class Class(models.Model):
    tutor = models.ForeignKey(User, on_delete=models.CASCADE)
    school = models.ForeignKey(School, on_delete=CASCADE)
    grade = models.IntegerField(max_length=1)