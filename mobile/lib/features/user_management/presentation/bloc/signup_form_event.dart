part of 'signup_form_bloc.dart';

abstract class SignupFormEvent extends Equatable {
  const SignupFormEvent();

  @override
  List<Object> get props => [];
}

class FirstNameChanged extends SignupFormEvent {
  final String firstName;

  const FirstNameChanged({@required this.firstName});

  @override
  List<Object> get props => [firstName];
}

class FirstNameUnfocused extends SignupFormEvent {}

class LastNameChanged extends SignupFormEvent {
  final String lastName;

  const LastNameChanged({@required this.lastName});

  @override
  List<Object> get props => [lastName];
}

class LastNameUnfocused extends SignupFormEvent {}

class EmailChanged extends SignupFormEvent {
  final String email;

  const EmailChanged({@required this.email});

  @override
  List<Object> get props => [email];
}

class EmailUnfocused extends SignupFormEvent {}

class PasswordChanged extends SignupFormEvent {
  const PasswordChanged({@required this.password});

  final String password;

  @override
  List<Object> get props => [password];
}

class PasswordUnfocused extends SignupFormEvent {}

class ConfirmPasswordChanged extends SignupFormEvent {
  const ConfirmPasswordChanged({@required this.confirmPassword});

  final String confirmPassword;

  @override
  List<Object> get props => [confirmPassword];
}

class ConfirmPasswordUnfocused extends SignupFormEvent {}

class RoleChanged extends SignupFormEvent {
  final Role role;

  RoleChanged({@required this.role});

  @override
  List<Object> get props => [role];
}

class RoleUnfocused extends SignupFormEvent {}

class FormSubmitted extends SignupFormEvent {}
