import json
from rest_framework import status, serializers
from .serializers import ClassSerializer, UserSerializer, ProfileSerializer, TextSerializer
from django.http import JsonResponse
from django.contrib.auth.models import User
from django.core.validators import validate_email
from django.core.exceptions import ValidationError, ObjectDoesNotExist
from .models import *
from django.shortcuts import render
from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from django.http import Http404
from django.core.exceptions import ObjectDoesNotExist
from rest_framework.decorators import api_view
from django.contrib.auth.models import User
from django.core.validators import validate_email
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


def check_role(role):
    """
    Checks if the user is a professor or support professional.
    """
    return role in [0, 1]


@api_view(["POST"])
def create_class(request):
    payload = json.loads(request.body)

    if check_role(payload["role"]):
        try:
            user = User.objects.get(id=payload["id_tutor"])
            _class = Class.objects.create(
                tutor=user,
                # school=payload["school"],
                grade=payload["grade"]
            )
            class_serializer = ClassSerializer(_class)
            return JsonResponse({'class': class_serializer.data}, safe=False, status=status.HTTP_201_CREATED)
            
        except ObjectDoesNotExist as e:
            return JsonResponse({'error': str(e)}, safe=False, status=status.HTTP_404_NOT_FOUND)
        
        except Exception as e:
            return JsonResponse({'error': f'Something terrible went wrong: {str(e)}'}, safe=False, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    else:
        return JsonResponse({'error': 'Permission denied'}, safe=False, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(["GET"])
def get_classes(request, user_id):
    try:
        user = User.objects.get(id=user_id)
        classes = Class.objects.filter(tutor=user)
        serializer = ClassSerializer(classes, many=True)
        return JsonResponse({'classes': serializer.data}, safe=False, status=status.HTTP_200_OK)
    except ObjectDoesNotExist as e:
        return JsonResponse({'error': 'User has no associated classes.'}, safe=False, status=status.HTTP_204_NO_CONTENT)


@api_view(["PUT"])
def update_class(request, class_id):
    user = request.user.id
    payload = json.loads(request.body)

    if check_role(payload["role"]):
        try:
            class_item = Class.objects.filter(tutor=user, id=class_id)
            class_item.update(**payload)
            _class = Class.objects.get(id=class_id)
            serializer = ClassSerializer(_class)
            return JsonResponse({'classes': serializer.data}, safe=False, status=status.HTTP_200_OK)
        except ObjectDoesNotExist as e:
            return JsonResponse({'error': str(e)}, safe=False, status=status.HTTP_404_NOT_FOUND)
        except Exception:
            return JsonResponse({'error': 'Something terrible went wrong'}, safe=False, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    else:
        return JsonResponse({'error': 'Permission denied'}, safe=False, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(["DELETE"])
def delete_class(request, class_id):
    user = request.user.id
    payload = json.loads(request.body)

    if check_role(payload["role"]):
        try:
            _class = Class.objects.get(tutor=user, id=class_id)
            _class.delete()
            return JsonResponse(status=status.HTTP_204_NO_CONTENT)
        except ObjectDoesNotExist as e:
            return JsonResponse({'error': str(e)}, safe=False, status=status.HTTP_404_NOT_FOUND)
        except Exception:
            return JsonResponse({'error': 'Something went wrong'}, safe=False, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    else:
        return JsonResponse({'error': 'Permission denied'}, safe=False, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(["POST"])
def create_text(request, class_id):
    payload = json.loads(request.body)

    if check_role(payload["role"]):
        try:
            user = User.objects.get(id=payload["id"])
            _class = Class.objects.get(id=class_id)
            text = Text.objects.create(
                writer = user,
                _class = _class,
                text = payload["text"]
            )
            text_serializer = TextSerializer(text)
            return JsonResponse({'Text': text_serializer.data}, safe=False, status=status.HTTP_200_OK)
            
        except ObjectDoesNotExist as e:
            return JsonResponse({'error': str(e)}, safe=False, status=status.HTTP_404_NOT_FOUND)
        
        except Exception as e:
            return JsonResponse({'error': f'Something terrible went wrong: {str(e)}'}, safe=False, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    else:
        return JsonResponse({'error': 'Permission denied'}, safe=False, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(["PUT"])
def update_text(request, text_id):
    payload = json.loads(request.body)
    user = User.objects.get(id=payload["id"])

    if check_role(payload["role"]):
        try:
            text_item = Text.objects.filter(writer=user, id=text_id)
            text_item.update(**payload)
            text = Text.objects.get(id=text_id)
            serializer = TextSerializer(text)
            return JsonResponse({'text': serializer.data}, safe=False, status=status.HTTP_200_OK)
        except ObjectDoesNotExist as e:
            return JsonResponse({'error': str(e)}, safe=False, status=status.HTTP_404_NOT_FOUND)
        except Exception:
            return JsonResponse({'error': 'Something terrible went wrong'}, safe=False, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    else:
        return JsonResponse({'error': 'Permission denied'}, safe=False, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(["GET"])
def get_texts(request):
    user = request.user.id
    texts = Text.objects.filter(writer=user)
    serializer = TextSerializer(texts, many=True)
    return JsonResponse({'texts': serializer.data}, safe=False, status=status.HTTP_200_OK)

  
class LepicUser(APIView):
    
    def get_object(self, primary_key):
        try:
            return {"user" : User.objects.get(pk=primary_key), "profile" : Profile.objects.get(pk=primary_key)}
        except ObjectDoesNotExist:
            raise Http404

    def get(self, request, primary_key, format=None):
        user_dictionary = self.get_object(primary_key)
        user_serializer = UserSerializer(user_dictionary.get("user"))
        profile_serializer = ProfileSerializer(user_dictionary.get("profile"))
        return Response({'user': {**user_serializer.data, **profile_serializer.data}})

      
