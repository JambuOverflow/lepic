part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class _UserManagementEvent extends UserEvent {
  final String firstName;
  final String lastName;
  final String email;
  final Role role;
  final String password;

  _UserManagementEvent(
    this.firstName,
    this.lastName,
    this.email,
    this.role,
    this.password,
  );
}

class CreateNewUserEvent extends _UserManagementEvent {
  CreateNewUserEvent(
    String firstName,
    String lastName,
    String email,
    Role role,
    String password,
  ) : super(firstName, lastName, email, role, password);
}

class UpdateUserEvent extends _UserManagementEvent {
  UpdateUserEvent(
    String firstName,
    String lastName,
    String email,
    Role role,
    String password,
  ) : super(firstName, lastName, email, role, password);
}

class LoggingUserEvent extends UserEvent {
  final String email;
  final String password;

  LoggingUserEvent(
    this.email,
    this.password,
  );
}
