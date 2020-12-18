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