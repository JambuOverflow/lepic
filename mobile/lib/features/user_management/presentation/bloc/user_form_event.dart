part of 'user_form_bloc.dart';

abstract class UserFormEvent extends Equatable {
  const UserFormEvent();

  @override
  List<Object> get props => [];
}

class FirstNameChanged extends UserFormEvent {
  final String firstName;

  const FirstNameChanged({@required this.firstName});

  @override
  List<Object> get props => [firstName];
}

class FirstNameUnfocused extends UserFormEvent {}

class LastNameChanged extends UserFormEvent {
  final String lastName;

  const LastNameChanged({@required this.lastName});

  @override
  List<Object> get props => [lastName];
}

class LastNameUnfocused extends UserFormEvent {}

class EmailChanged extends UserFormEvent {
  final String email;

  const EmailChanged({@required this.email});

  @override
  List<Object> get props => [email];
}

class EmailUnfocused extends UserFormEvent {}

class PasswordChanged extends UserFormEvent {
  const PasswordChanged({@required this.password});

  final String password;

  @override
  List<Object> get props => [password];
}

class PasswordUnfocused extends UserFormEvent {}

class ConfirmPasswordChanged extends UserFormEvent {
  const ConfirmPasswordChanged({@required this.confirmPassword});

  final String confirmPassword;

  @override
  List<Object> get props => [confirmPassword];
}

class ConfirmPasswordUnfocused extends UserFormEvent {}

class RoleChanged extends UserFormEvent {
  final Role role;

  RoleChanged({@required this.role});

  @override
  List<Object> get props => [role];
}

class RoleUnfocused extends UserFormEvent {}

class FormSubmitted extends UserFormEvent {}
