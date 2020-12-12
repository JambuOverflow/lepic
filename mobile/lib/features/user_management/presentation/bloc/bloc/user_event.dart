part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class CreateNewUserEvent extends UserEvent {
  final String firstName;
  final String lastName;
  final String email;
  final Role role;
  final String password;

  CreateNewUserEvent(
    this.firstName,
    this.lastName,
    this.email,
    this.role,
    this.password,
  );
}

class UpdateUserEvent extends UserEvent {
  final User user;

  UpdateUserEvent({@required this.user});
}

class LoggingUserEvent extends UserEvent {
  final String email;
  final String password;

  LoggingUserEvent(
    this.email,
    this.password,
  );
}
