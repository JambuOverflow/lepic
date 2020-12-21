import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:formz/formz.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/network/response.dart';

import '../../domain/use_cases/user_params.dart';
import '../../domain/entities/user.dart';
import '../../../../core/presentation/validators/not_empty_input.dart';
import '../../../../core/presentation/validators/email_input.dart';
import '../../domain/use_cases/login.dart';

part 'login_form_event.dart';
part 'login_form_state.dart';

class LoginFormBloc extends Bloc<LoginFormEvent, LoginFormState> {
  final LoginCase loginCase;

  LoginFormBloc({this.loginCase}) : super(LoginFormState());

  @override
  Stream<LoginFormState> mapEventToState(LoginFormEvent event) async* {
    if (event is EmailChanged) {
      final email = EmailInput.dirty(event.email);

      yield state.copyWith(
        email: email.valid ? email : EmailInput.pure(event.email),
        status: _validateOnState(email: email),
      );
    } else if (event is PasswordChanged) {
      final password = NotEmptyInput.dirty(event.password);

      yield state.copyWith(
        password:
            password.valid ? password : NotEmptyInput.pure(event.password),
        status: _validateOnState(password: password),
      );
    } else if (event is FormSubmitted) {
      yield _setStateDirtyAndValidate();

      if (state.status.isValidated) {
        yield state.copyWith(status: FormzStatus.submissionInProgress);

        final user = User(
          email: state.email.value,
          password: state.password.value,
        );

        final failureOrResponse = await loginCase(UserParams(user: user));

        yield _stateSuccessOrFailure(failureOrResponse);
      }
    }
  }

  LoginFormState _stateSuccessOrFailure(
      Either<Failure, Response> failureOrResponse) {
    return failureOrResponse.fold(
      (failure) => state.copyWith(status: FormzStatus.submissionFailure),
      (response) {
        if (response is SuccessfulResponse)
          return state.copyWith(status: FormzStatus.submissionSuccess);
        else
          return state.copyWith(
            status: FormzStatus.invalid,
            credentialInvalid: true,
          );
      },
    );
  }

  LoginFormState _setStateDirtyAndValidate() {
    return state.copyWith(
      email: EmailInput.dirty(state.email.value),
      password: NotEmptyInput.dirty(state.password.value),
      status: _validateOnState(),
    );
  }

  FormzStatus _validateOnState({EmailInput email, NotEmptyInput password}) {
    email = email ?? state.email;
    password = password ?? state.password;

    return Formz.validate([email, password]);
  }
}
