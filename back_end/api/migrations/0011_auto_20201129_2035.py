# Generated by Django 3.1.3 on 2020-11-29 23:35

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('api', '0010_class_school'),
    ]

    operations = [
        migrations.AlterField(
            model_name='class',
            name='grade',
            field=models.IntegerField(),
        ),
        migrations.AlterField(
            model_name='school',
            name='name',
            field=models.CharField(max_length=100),
        ),
        migrations.AlterField(
            model_name='school',
            name='zip_code',
            field=models.IntegerField(),
        ),
        migrations.CreateModel(
            name='Text',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('body', models.CharField(max_length=1000)),
                ('_class', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='api.class')),
                ('writer', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
    ]