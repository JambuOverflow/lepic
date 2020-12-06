from django.contrib import admin
from .models import User, School, Class, Text
# Register your models here.

admin.site.register(School)
admin.site.register(Class)
admin.site.register(User)
admin.site.register(Text)