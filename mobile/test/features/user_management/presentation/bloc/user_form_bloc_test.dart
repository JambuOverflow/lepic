import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mobile/core/presentation/validators/confirm_password_input.dart';
import 'package:mobile/core/presentation/validators/email_input.dart';
import 'package:mobile/core/presentation/validators/name_input.dart';
import 'package:mobile/core/presentation/validators/password_input.dart';
import 'package:mobile/core/presentation/validators/role_input.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:mobile/features/user_management/presentation/bloc/user_form_bloc.dart';

import 'user_bloc_test.dart';

void main() {
  MockCreateNewUserCase mockCreateNewUserCase;
  UserFormBloc bloc;

  setUp(() {
    mockCreateNewUserCase = MockCreateNewUserCase();
    bloc = UserFormBloc(createNewUser: mockCreateNewUserCase);
  });

  group('firstName', () {
    final tValidName = 'Ana';
    final tInvalidName = '';

    blocTest(
      'should emit state with dirty first name when valid',
      build: () => bloc,
      act: (bloc) => bloc.add(FirstNameChanged(firstName: tValidName)),
      expect: [
        UserFormState(
            firstName: NameInput.dirty(tValidName),
            status: FormzStatus.invalid),
      ],
    );

    blocTest(
      'should emit state with pure first name when invalid',
      build: () => bloc,
      act: (bloc) => bloc.add(FirstNameChanged(firstName: tInvalidName)),
      expect: [
        UserFormState(
            firstName: NameInput.pure(''), status: FormzStatus.invalid),
      ],
    );

    blocTest(
      'should emit state with dirty first name',
      build: () => bloc,
      act: (bloc) => bloc.add(FirstNameUnfocused()),
      expect: [
        UserFormState(
            firstName: NameInput.dirty(''), status: FormzStatus.invalid),
      ],
    );
  });

  group('lastName', () {
    final tValidName = 'Beatriz';
    final tInvalidName = '';

    blocTest(
      'should emit state with dirty last name when valid',
      build: () => bloc,
      act: (bloc) => bloc.add(LastNameChanged(lastName: tValidName)),
      expect: [
        UserFormState(
            lastName: NameInput.dirty(tValidName), status: FormzStatus.invalid),
      ],
    );

    blocTest(
      'should emit state with pure last name when invalid',
      build: () => bloc,
      act: (bloc) => bloc.add(LastNameChanged(lastName: tInvalidName)),
      expect: [
        UserFormState(
            lastName: NameInput.pure(''), status: FormzStatus.invalid),
      ],
    );

    blocTest(
      'should emit state with dirty last name',
      build: () => bloc,
      act: (bloc) => bloc.add(LastNameUnfocused()),
      expect: [
        UserFormState(
            lastName: NameInput.dirty(''), status: FormzStatus.invalid),
      ],
    );
  });

  group('email', () {
    final tValidEmail = 'vitor@gmail.com';
    final tInvalidEmail = 'notanemail';

    blocTest(
      'should emit state with dirty email when valid',
      build: () => bloc,
      act: (bloc) => bloc.add(EmailChanged(email: tValidEmail)),
      expect: [
        UserFormState(
            email: EmailInput.dirty(tValidEmail), status: FormzStatus.invalid),
      ],
    );

    blocTest(
      'should emit state with pure email when invalid',
      build: () => bloc,
      act: (bloc) => bloc.add(EmailChanged(email: tInvalidEmail)),
      expect: [
        UserFormState(
            email: EmailInput.pure(tInvalidEmail), status: FormzStatus.invalid),
      ],
    );

    blocTest(
      'should emit state with dirty email',
      build: () => bloc,
      act: (bloc) => bloc.add(EmailUnfocused()),
      expect: [
        UserFormState(email: EmailInput.dirty(''), status: FormzStatus.invalid),
      ],
    );
  });

  group('password', () {
    final tValidPassword = 'ABcd3416@!';
    final tInvalidPassword = '123456';

    blocTest(
      'should emit state with dirty password when valid',
      build: () => bloc,
      act: (bloc) => bloc.add(PasswordChanged(password: tValidPassword)),
      expect: [
        UserFormState(
            password: PasswordInput.dirty(tValidPassword),
            status: FormzStatus.invalid),
      ],
    );

    blocTest(
      'should emit state with pure password when invalid',
      build: () => bloc,
      act: (bloc) => bloc.add(PasswordChanged(password: tInvalidPassword)),
      expect: [
        UserFormState(
            password: PasswordInput.pure(tInvalidPassword),
            status: FormzStatus.invalid),
      ],
    );

    blocTest(
      'should emit state with dirty password',
      build: () => bloc,
      act: (bloc) => bloc.add(PasswordUnfocused()),
      expect: [
        UserFormState(
            password: PasswordInput.dirty(''), status: FormzStatus.invalid),
      ],
    );
  });

  group('confirmPassword', () {
    final tPassword = 'ABcd3416@!';
    final tValidConfirm = '';
    final tInvalidConfirm = '123456';

    blocTest(
      'should emit state with dirty confirm password when valid',
      build: () => bloc,
      act: (bloc) =>
          bloc.add(ConfirmPasswordChanged(confirmPassword: tValidConfirm)),
      expect: [
        UserFormState(
            confirmPassword:
                ConfirmPasswordInput.dirty(password: '', value: tValidConfirm),
            status: FormzStatus.invalid),
      ],
    );

    blocTest(
      'should emit state with pure confirm password when invalid',
      build: () => bloc,
      act: (bloc) =>
          bloc.add(ConfirmPasswordChanged(confirmPassword: tInvalidConfirm)),
      expect: [
        UserFormState(
            confirmPassword:
                ConfirmPasswordInput.pure(password: '', value: tInvalidConfirm),
            status: FormzStatus.invalid),
      ],
    );

    blocTest(
      'should emit state with dirty confirm password',
      build: () => bloc,
      act: (bloc) => bloc.add(ConfirmPasswordUnfocused()),
      expect: [
        UserFormState(
            confirmPassword:
                ConfirmPasswordInput.dirty(password: tPassword, value: ''),
            status: FormzStatus.invalid),
      ],
    );
  });

  group('role', () {
    final tValidRole = Role.researcher;
    final tInvalidRole = null;

    blocTest(
      'should emit state with dirty role when valid',
      build: () => bloc,
      act: (bloc) => bloc.add(RoleChanged(role: tValidRole)),
      expect: [
        UserFormState(
            role: RoleInput.dirty(tValidRole), status: FormzStatus.invalid),
      ],
    );

    blocTest(
      'should emit state with pure role when invalid',
      build: () => bloc,
      act: (bloc) => bloc.add(RoleChanged(role: tInvalidRole)),
      expect: [
        UserFormState(
            role: RoleInput.pure(tInvalidRole), status: FormzStatus.invalid),
      ],
    );

    blocTest(
      'should emit state with dirty role',
      build: () => bloc,
      act: (bloc) => bloc.add(RoleUnfocused()),
      expect: [
        UserFormState(role: RoleInput.dirty(), status: FormzStatus.invalid),
      ],
    );
  });
}
