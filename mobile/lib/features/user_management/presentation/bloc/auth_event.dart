part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStartedEvent extends AuthEvent {}

class UserLoggedInEvent extends AuthEvent {}

class UserLoggedOutEvent extends AuthEvent {}
