# Generated by Django 3.1.3 on 2020-11-27 20:51

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0006_profile_role'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='profile',
            name='user',
        ),
    ]
