from django.db import models
from django.contrib.auth.models import AbstractUser


class User(AbstractUser):
    ROLE_CHOICES = (
        (0, 'teacher'),
        (1, 'support professional'),
        (2, 'researcher'),
    )

    role = models.PositiveSmallIntegerField(choices=ROLE_CHOICES)
    email = models.EmailField(('email address'), unique=True)

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = []


class School(models.Model):
    name = models.CharField(max_length=100)
    city = models.CharField(max_length=30)
    neighbourhood = models.CharField(max_length=30)
    state = models.CharField(max_length=2)
    zip_code = models.IntegerField()
    TYPE_CHOICES = (
        (0, 'municipal'),
        (1, 'estadual'),
        (2, 'federal'),
        (3, 'privada')
    )
    modality = models.PositiveIntegerField(choices=TYPE_CHOICES)
    creator = models.ForeignKey(User, on_delete=models.CASCADE)

    def __str__(self):
        return self.name


class Class(models.Model):
    tutor = models.ForeignKey(User, on_delete=models.CASCADE)
    school = models.ForeignKey(School, on_delete=models.CASCADE)
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

class Student(models.Model):
    first_name = models.CharField(max_length=50)
    last_name = models.CharField(max_length=50)
    _class = models.ForeignKey(Class, on_delete=models.CASCADE)

    def __str__(self):
        return self.first_name + " " + self.last_name