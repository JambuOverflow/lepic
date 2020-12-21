part of 'login_form_bloc.dart';

abstract class LoginFormEvent extends Equatable {
  const LoginFormEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends LoginFormEvent {
  final String email;

  EmailChanged({@required this.email});

  @override
  List<Object> get props => [email];
}

class PasswordChanged extends LoginFormEvent {
  final String password;

  PasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];
}

class FormSubmitted extends LoginFormEvent {}
