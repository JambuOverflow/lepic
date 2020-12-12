import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile/features/user_management/domain/use_cases/login.dart';

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

  UserBloc({
    @required this.login,
    @required this.createNewUser,
  }) : super(NotLoggedIn());

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is CreateNewUserEvent) {
      _createUserStates(event);
    } else if (event is LoggingUserEvent) {
      _loggingStates(event);
    }
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
    
    final user = User(
      firstName: event.firstName,
      lastName: event.lastName,
      email: event.lastName,
      role: event.role,
      password: event.password,
    );
    
    final failureOrResponse = await createNewUser(UserParams(user: user));
    
    yield failureOrResponse.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (response) => UserCreated(response: response),
    );
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
