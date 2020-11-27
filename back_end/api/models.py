from django.db import models
from django.core.validators import validate_email
from django.contrib.auth.models import User
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
