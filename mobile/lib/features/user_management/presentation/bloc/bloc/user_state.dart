part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [UserState];
}

class NotLoggedIn extends UserState {}

class Logging extends UserState {}

class LoggedIn extends UserState {}

class CreatingUser extends UserState {}

class UserCreated extends UserState {
  final Response response;

  UserCreated({@required this.response});
}

class Error extends UserState {
  final String message;

  Error({@required this.message});
}
