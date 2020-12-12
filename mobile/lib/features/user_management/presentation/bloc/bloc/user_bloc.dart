import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile/features/user_management/domain/use_cases/login.dart';
import 'package:mobile/features/user_management/domain/use_cases/update_user.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/network/response.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/use_cases/create_new_user.dart';
import '../../../domain/use_cases/user_params.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final CreateNewUserCase createNewUser;
  final LoginCase login;
  final UpdateUserCase updateUser;

  UserBloc({
    @required this.updateUser,
    @required this.login,
    @required this.createNewUser,
  }) : super(NotLoggedIn());

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is CreateNewUserEvent)
      yield* _createUserStates(event);
    else if (event is LoggingUserEvent)
      yield* _loggingStates(event);
    else if (event is UpdateUserEvent) yield* _updateStates(event);
  }

  Stream<UserState> _updateStates(UpdateUserEvent event) async* {
    yield UpdatingUser();

    final user = _createUserEntityFromEvent(event);

    final failureOrResponse = await updateUser(UserParams(user: user));

    yield failureOrResponse.fold(
      (failure) => Error(message: _mapFailureToMessage(ServerFailure())),
      (response) => UserUpdated(),
    );
  }

  Stream<UserState> _loggingStates(LoggingUserEvent event) async* {
    yield Logging();

    final user = User(
      password: event.password,
      email: event.email,
    );

    final failureOrResponse = await login(UserParams(user: user));

    yield failureOrResponse.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (response) => LoggedIn(),
    );
  }

  Stream<UserState> _createUserStates(CreateNewUserEvent event) async* {
    yield CreatingUser();

    final user = _createUserEntityFromEvent(event);

    final failureOrResponse = await createNewUser(UserParams(user: user));

    yield failureOrResponse.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (response) => UserCreated(response: response),
    );
  }

  User _createUserEntityFromEvent(UserEvent event) {
    if (event is _UserManagementEvent) {
      return User(
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        role: event.role,
        password: event.password,
      );
    }

    throw Exception('Cannot create user from event');
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Could not reach server';
      default:
        return 'Unexpected Error';
    }
  }
}
