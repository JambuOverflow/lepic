import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:formz/formz.dart';
import 'package:mobile/core/presentation/validators/role_input.dart';

import '../../domain/use_cases/user_params.dart';
import '../../domain/entities/user.dart';
import '../../domain/use_cases/create_user_use_case.dart';
import '../../../../core/presentation/validators/confirm_password_input.dart';
import '../../../../core/presentation/validators/email_input.dart';
import '../../../../core/presentation/validators/name_input.dart';
import '../../../../core/presentation/validators/password_input.dart';

part 'user_form_event.dart';
part 'user_form_state.dart';

class UserFormBloc extends Bloc<UserFormEvent, UserFormState> {
  final CreateNewUserCase createNewUser;

  UserFormBloc({@required this.createNewUser}) : super(UserFormState());

  @override
  Stream<UserFormState> mapEventToState(
    UserFormEvent event,
  ) async* {
    if (event is FirstNameChanged) {
      final firstName = NameInput.dirty(event.firstName);

      yield state.copyWith(
        firstName:
            firstName.valid ? firstName : NameInput.pure(event.firstName),
        status: _validateOnState(firstName: firstName),
      );
    } else if (event is FirstNameUnfocused) {
      final firstName = NameInput.dirty(state.firstName.value);

      yield state.copyWith(
        firstName: firstName,
        status: _validateOnState(firstName: firstName),
      );
    } else if (event is LastNameChanged) {
      final lastName = NameInput.dirty(event.lastName);

      yield state.copyWith(
        lastName: lastName.valid ? lastName : NameInput.pure(event.lastName),
        status: _validateOnState(lastName: lastName),
      );
    } else if (event is LastNameUnfocused) {
      final lastName = NameInput.dirty(state.lastName.value);

      yield state.copyWith(
        lastName: lastName,
        status: _validateOnState(lastName: lastName),
      );
    } else if (event is EmailChanged) {
      final email = EmailInput.dirty(event.email);

      yield state.copyWith(
        email: email.valid ? email : EmailInput.pure(event.email),
        status: _validateOnState(email: email),
      );
    } else if (event is EmailUnfocused) {
      final email = EmailInput.dirty(state.email.value);

      yield state.copyWith(
        email: email,
        status: _validateOnState(email: email),
      );
    } else if (event is PasswordChanged) {
      final password = PasswordInput.dirty(event.password);

      yield state.copyWith(
        password:
            password.valid ? password : PasswordInput.pure(event.password),
        status: _validateOnState(password: password),
      );
    } else if (event is PasswordUnfocused) {
      final password = PasswordInput.dirty(state.password.value);

      yield state.copyWith(
        password: password,
        status: _validateOnState(password: password),
      );
    } else if (event is ConfirmPasswordChanged) {
      final confirmPassword = ConfirmPasswordInput.dirty(
          password: state.password.value, value: event.confirmPassword);

      yield state.copyWith(
        confirmPassword: confirmPassword.valid
            ? confirmPassword
            : ConfirmPasswordInput.pure(
                password: state.password.value,
                value: event.confirmPassword,
              ),
        status: _validateOnState(confirmPassword: confirmPassword),
      );
    } else if (event is ConfirmPasswordUnfocused) {
      final confirmPassword = ConfirmPasswordInput.dirty(
          password: state.password.value, value: state.confirmPassword.value);

      yield state.copyWith(
        confirmPassword: confirmPassword,
        status: _validateOnState(confirmPassword: confirmPassword),
      );
    } else if (event is RoleChanged) {
      final role = RoleInput.dirty(event.role);

      yield state.copyWith(
        role: role.valid ? role : RoleInput.pure(event.role),
        status: _validateOnState(role: role),
      );
    } else if (event is RoleUnfocused) {
      final role = RoleInput.dirty(state.role.value);

      yield state.copyWith(
        role: role,
        status: _validateOnState(role: role),
      );
    } else if (event is FormSubmitted) {
      yield _setStateDirtyAndValidate();

      if (state.status.isValidated) {
        yield state.copyWith(status: FormzStatus.submissionInProgress);

        final user = User(
          firstName: state.firstName.value,
          lastName: state.lastName.value,
          email: state.email.value,
          role: state.role.value,
          password: state.password.value,
        );

        final failureOrResponse = await createNewUser(UserParams(user: user));

        yield failureOrResponse.fold(
          (failure) => state.copyWith(status: FormzStatus.submissionFailure),
          (response) => state.copyWith(status: FormzStatus.submissionSuccess),
        );
      }
    }
  }

  UserFormState _setStateDirtyAndValidate() {
    final dirtyConfirmPassword = ConfirmPasswordInput.dirty(
      password: state.password.value,
      value: state.confirmPassword.value,
    );

    return state.copyWith(
      firstName: NameInput.dirty(state.firstName.value),
      lastName: NameInput.dirty(state.lastName.value),
      email: EmailInput.dirty(state.email.value),
      password: PasswordInput.dirty(state.password.value),
      confirmPassword: dirtyConfirmPassword,
      role: RoleInput.dirty(state.role.value),
      status: _validateOnState(confirmPassword: dirtyConfirmPassword),
    );
  }

  FormzStatus _validateOnState({
    NameInput firstName,
    NameInput lastName,
    EmailInput email,
    PasswordInput password,
    RoleInput role,
    ConfirmPasswordInput confirmPassword,
  }) {
    firstName = firstName ?? state.firstName;
    lastName = lastName ?? state.lastName;
    email = email ?? state.email;
    password = password ?? state.password;
    confirmPassword = confirmPassword ?? state.confirmPassword;
    role = role ?? state.role;

    return Formz.validate([
      firstName,
      lastName,
      email,
      password,
      confirmPassword,
      role,
    ]);
  }
}
