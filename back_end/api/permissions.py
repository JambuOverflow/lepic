from rest_framework import permissions
from api.models import Class, Text


class IsClassTutor(permissions.BasePermission):
    """
    Custom permission to only allow the class tutor to edit it.
    """

    def has_object_permission(self, request, view, class_):
        # Write permissions are only allowed to the owner of the object.
        return class_.tutor == request.user


class IsOwner(permissions.BasePermission):
    """
    Custom permission to only allow owners of an object to edit it.
    """

    def has_object_permission(self, request, view, obj):
        # All permissions are only allowed to the owner of the object.
        return obj == request.user


class IsTextCreator(permissions.BasePermission):
    """
    Custom permission to allow only tutor of a class to edit its texts.
    """

    def has_object_permission(self, request, view, text):
        # All permissions are only allowed to the texts creator.
        return text._class.tutor == request.user


class IsTeacher(permissions.BasePermission):
    """
    Custom permission to allow only teachers to create schools.
    """

    def has_permission(self, request, view):
        # Permissions are only allowed to teachers.
        return request.user.role == 0


class IsCreator(permissions.BasePermission):
    """
    Custom permission to allow only teachers to edit schools.
    """

    def has_object_permission(self, request, view, school):
        # All permissions are only allowed to the texts creator.
        return school.creator == request.user 