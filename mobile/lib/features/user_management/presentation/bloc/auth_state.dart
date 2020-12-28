part of 'auth_bloc.dart';

enum AuthStatus { unauthenticated, authenticated, unkown }

class AuthState extends Equatable {
  final User user;
  final AuthStatus status;

  const AuthState({@required this.user, this.status = AuthStatus.unkown});

  @override
  List<Object> get props => [user, status];
}
