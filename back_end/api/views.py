import json
from .serializers import UserSerializer, ProfileSerializer
from django.http import JsonResponse
from django.shortcuts import render
from rest_framework import status
from django.core.exceptions import ObjectDoesNotExist
from rest_framework.decorators import api_view
from django.contrib.auth.models import User
from django.core.validators import validate_email
from django.core.exceptions import ValidationError
from .models import Profile
from .enum_roles import Roles


@api_view(["GET"])
def get_users(request):
    users = User.objects.all()
    profiles = Profile.objects.all()
    user_serializer = UserSerializer(users, many=True)
    profile_serializer = ProfileSerializer(profiles, many=True)
    result = []
    for user_data, profile_data in zip(user_serializer.data, profile_serializer.data):
        current_value = {**user_data, **profile_data}
        result.append(current_value)
    return JsonResponse({'users': result}, safe=False, status=status.HTTP_200_OK)


@api_view(["POST"])
def create_user(request):
    """
    ## Creates a user account, it performs automatic e-mail validation.

    ### Parameters:
        * username: string,
        * first_name: string,
        * last_name: string,
        * password: string,
        * email: string,
        * role: {0 for teacher, 1 for support professional and 2 for researcher}

    ### Request Example:
        ```curl -X POST -H "Content-Type: application/json" 
        -d '{"first_name":"testuserded", "le":"efef",  "role":0, 
        "email":"fala@gmail.com", "username":"oloco", "password":"343"}' 
        localhost:8000/api/create_user```
    
    """
    payload = json.loads(request.body)

    email = payload['email']
    try:
        validate_email(email)
    except ValidationError:
        return JsonResponse({'error': "Invalid E-mail"}, safe=False, 
                                status=status.HTTP_400_BAD_REQUEST)

    
    try:
        user = User.objects.create_user(
            first_name = payload['first_name'],
            last_name = payload['last_name'],
            email = email,
            username = payload['username'],
            password = payload['password'],
        )

        profile = Profile.objects.create(
            owner=user,
            role=Roles(payload['role']).name,
        )

        user_serializer = UserSerializer(user)
        profile_serializer = ProfileSerializer(profile)
        return JsonResponse({'user': {**user_serializer.data, **profile_serializer.data}}, safe=False, 
                            status=status.HTTP_201_CREATED)
    except ObjectDoesNotExist as e:
        return JsonResponse({'error': str(e)}, safe=False, status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
        return JsonResponse({'error': f'Something terrible went wrong: {str(e)}'}, safe=False, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


    """
    ## Updates a user account, using the profile_id in the link.

    ### Request Example:
        ```curl -X PUT -H "Content-Type: application/json" 
        -d '{"first_name":"testuserded", "role":0, "password":"343"}' 
        localhost:8000/api/update_user/1```
    
    ### The api receives a integer number from the form and changes it
        to a human-readable role inside the Enum Roles ['TEACHER', 'PROFESSIONAL'
        and 'RESEARCHER']
    """
@api_view(["PUT"])
def update_user(request, profile_id):
    payload = json.loads(request.body)

    if "email" in payload.keys():
        email = payload['email']
        try:
            validate_email(email)
        except ValidationError:
            return JsonResponse({'error': "Invalid E-mail"}, safe=False, 
                                status=status.HTTP_400_BAD_REQUEST)
    
    try:
        profile = Profile.objects.get(id=profile_id)
        profile_item = Profile.objects.filter(id=profile_id)
        user_item = User.objects.filter(id=profile.owner.id)
        if 'role' in payload.keys():
            profile_item.update(role=Roles(payload['role']).name)
            payload.pop('role')
        if 'password' in payload.keys():
            user = User.objects.get(id=profile.owner.id)
            user.set_password(payload['password'])
            payload['password'] = user.password
            
        user_item.update(**payload)

        profile = Profile.objects.get(id=profile_id)
        profile_serializer = ProfileSerializer(profile)
        user = User.objects.get(id=profile.owner.id)
        user_serializer = UserSerializer(user)
        return JsonResponse({'user': {**user_serializer.data, **profile_serializer.data}}, safe=False, status=status.HTTP_200_OK)
    except ObjectDoesNotExist as e:
        return JsonResponse({'error': str(e)}, safe=False, status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
        return JsonResponse({'error': f'Something terrible went wrong: {str(e)}'}, safe=False, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
