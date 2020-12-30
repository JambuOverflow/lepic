import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:mobile/features/user_management/domain/use_cases/get_logged_in_user_use_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetLoggedInUserCase getLoggedInUserCase;

  AuthBloc({
    @required this.getLoggedInUserCase,
  }) : super(AuthState());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AppStartedEvent) {
      yield _copyWithAuthenticating();
      yield* _eitherCheckAuthenticationOrFail();
    } else if (event is UserLoggedInEvent) {
      yield _copyWithAuthenticating();
      await Future.delayed(Duration(seconds: 5));
      yield* _eitherAuthenticateOrFail();
    } else if (event is UserLoggedOutEvent) {
      yield _copyWithAuthenticating();
      yield _copyWithUnauthenticated();
    }
  }

  Stream<AuthState> _eitherAuthenticateOrFail() async* {
    final eitherLoggedIn = await getLoggedInUserCase(NoParams());

    var fold = eitherLoggedIn.fold(
      (failure) => _copyWithError(),
      (loggedInUser) => loggedInUser == null
          ? _copyWithError()
          : _copyWithAuthenticated(loggedInUser),
    );
    yield fold;
  }

  Stream<AuthState> _eitherCheckAuthenticationOrFail() async* {
    final eitherLoggedIn = await getLoggedInUserCase(NoParams());

    yield eitherLoggedIn.fold(
      (failure) => _copyWithError(),
      (loggedInUser) => loggedInUser == null
          ? _copyWithUnauthenticated()
          : _copyWithAuthenticated(loggedInUser),
    );
  }

  AuthState _copyWithAuthenticated(User user) =>
      state.copyWith(user: user, status: AuthStatus.authenticated);

  AuthState _copyWithUnauthenticated() =>
      state.copyWith(user: null, status: AuthStatus.unauthenticated);

  AuthState _copyWithAuthenticating() =>
      state.copyWith(status: AuthStatus.authenticating);

  AuthState _copyWithError() =>
      state.copyWith(user: null, status: AuthStatus.error);
}
