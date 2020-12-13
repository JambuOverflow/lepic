from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import User, School, Class, Text

# Register your models here.

admin.site.register(School)
admin.site.register(Class)
admin.site.register(User, UserAdmin)
admin.site.register(Text)