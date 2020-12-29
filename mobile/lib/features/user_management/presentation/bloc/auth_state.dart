part of 'auth_bloc.dart';

enum AuthStatus { unauthenticated, authenticated, unkown, error }

class AuthState extends Equatable {
  final User user;
  final AuthStatus status;

  const AuthState({this.user, this.status = AuthStatus.unkown});

  AuthState copyWith({
    final User user,
    final AuthStatus status,
  }) {
    return AuthState(
      user: user ?? this.user,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [user, status];
}
