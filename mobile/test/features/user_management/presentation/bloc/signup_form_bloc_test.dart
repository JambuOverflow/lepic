import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/network/response.dart';
import 'package:mobile/core/presentation/validators/confirm_password_input.dart';
import 'package:mobile/core/presentation/validators/email_input.dart';
import 'package:mobile/core/presentation/validators/name_input.dart';
import 'package:mobile/core/presentation/validators/password_input.dart';
import 'package:mobile/core/presentation/validators/role_input.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:mobile/features/user_management/domain/use_cases/create_user_use_case.dart';
import 'package:mobile/features/user_management/presentation/bloc/signup_form_bloc.dart';
import 'package:mockito/mockito.dart';

class MockCreateNewUserCase extends Mock implements CreateNewUserCase {}

void main() {
  MockCreateNewUserCase mockCreateNewUserCase;
  SignupFormBloc bloc;

  setUp(() {
    mockCreateNewUserCase = MockCreateNewUserCase();
    bloc = SignupFormBloc(createNewUser: mockCreateNewUserCase);
  });

  group('firstName', () {
    final tValidName = 'Ana';
    final tInvalidName = '';

    blocTest(
      'should emit state with dirty first name when valid',
      build: () => bloc,
      act: (bloc) => bloc.add(FirstNameChanged(firstName: tValidName)),
      expect: [
        SignupFormState(
            firstName: NameInput.dirty(tValidName),
            status: FormzStatus.invalid),
      ],
    );

    blocTest(
      'should emit state with pure first name when invalid',
      build: () => bloc,
      act: (bloc) => bloc.add(FirstNameChanged(firstName: tInvalidName)),
      expect: [
        SignupFormState(
            firstName: NameInput.pure(''), status: FormzStatus.invalid),
      ],
    );

    blocTest(
      'should emit state with dirty first name',
      build: () => bloc,
      act: (bloc) => bloc.add(FirstNameUnfocused()),
      expect: [
        SignupFormState(
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
        SignupFormState(
            lastName: NameInput.dirty(tValidName), status: FormzStatus.invalid),
      ],
    );

    blocTest(
      'should emit state with pure last name when invalid',
      build: () => bloc,
      act: (bloc) => bloc.add(LastNameChanged(lastName: tInvalidName)),
      expect: [
        SignupFormState(
            lastName: NameInput.pure(''), status: FormzStatus.invalid),
      ],
    );

    blocTest(
      'should emit state with dirty last name',
      build: () => bloc,
      act: (bloc) => bloc.add(LastNameUnfocused()),
      expect: [
        SignupFormState(
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
        SignupFormState(
            email: EmailInput.dirty(tValidEmail), status: FormzStatus.invalid),
      ],
    );

    blocTest(
      'should emit state with pure email when invalid',
      build: () => bloc,
      act: (bloc) => bloc.add(EmailChanged(email: tInvalidEmail)),
      expect: [
        SignupFormState(
            email: EmailInput.pure(tInvalidEmail), status: FormzStatus.invalid),
      ],
    );

    blocTest(
      'should emit state with dirty email',
      build: () => bloc,
      act: (bloc) => bloc.add(EmailUnfocused()),
      expect: [
        SignupFormState(
            email: EmailInput.dirty(''), status: FormzStatus.invalid),
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
        SignupFormState(
            password: PasswordInput.dirty(tValidPassword),
            status: FormzStatus.invalid),
      ],
    );

    blocTest(
      'should emit state with pure password when invalid',
      build: () => bloc,
      act: (bloc) => bloc.add(PasswordChanged(password: tInvalidPassword)),
      expect: [
        SignupFormState(
            password: PasswordInput.pure(tInvalidPassword),
            status: FormzStatus.invalid),
      ],
    );

    blocTest(
      'should emit state with dirty password',
      build: () => bloc,
      act: (bloc) => bloc.add(PasswordUnfocused()),
      expect: [
        SignupFormState(
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
        SignupFormState(
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
        SignupFormState(
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
        SignupFormState(
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
        SignupFormState(
            role: RoleInput.dirty(tValidRole), status: FormzStatus.invalid),
      ],
    );

    blocTest(
      'should emit state with pure role when invalid',
      build: () => bloc,
      act: (bloc) => bloc.add(RoleChanged(role: tInvalidRole)),
      expect: [
        SignupFormState(
            role: RoleInput.pure(tInvalidRole), status: FormzStatus.invalid),
      ],
    );

    blocTest(
      'should emit state with dirty role',
      build: () => bloc,
      act: (bloc) => bloc.add(RoleUnfocused()),
      expect: [
        SignupFormState(role: RoleInput.dirty(), status: FormzStatus.invalid),
      ],
    );
  });

  group('formSubmitted', () {
    final tFirstName = 'Vitor';
    final tLastName = 'Cantao';
    final tEmail = 'vc@gmail.com';
    final tPassword = 'ABCdef123';
    final tRole = Role.teacher;

    group('valid', () {
      SignupFormBloc validBloc;

      final validFormState = SignupFormState(
        firstName: NameInput.dirty(tFirstName),
        lastName: NameInput.dirty(tLastName),
        email: EmailInput.dirty(tEmail),
        password: PasswordInput.dirty(tPassword),
        confirmPassword: ConfirmPasswordInput.dirty(
          password: tPassword,
          value: tPassword,
        ),
        role: RoleInput.dirty(tRole),
      );

      setUp(() {
        validBloc = SignupFormBloc(createNewUser: mockCreateNewUserCase);
        validBloc.add(FirstNameChanged(firstName: tFirstName));
        validBloc.add(LastNameChanged(lastName: tLastName));
        validBloc.add(EmailChanged(email: tEmail));
        validBloc.add(PasswordChanged(password: tPassword));
        validBloc.add(ConfirmPasswordChanged(confirmPassword: tPassword));
        validBloc.add(RoleChanged(role: tRole));
      });

      group('successfulResponse', () {
        setUp(() {
          when(mockCreateNewUserCase(any)).thenAnswer(
            (_) async => Right(SuccessfulResponse()),
          );
        });

        blocTest(
          '''should emit state with submission in progress status and 
      state with submission success when form is valid''',
          build: () => validBloc,
          act: (bloc) {
            bloc.add(FormSubmitted());
          },
          skip: 6,
          expect: [
            validFormState.copyWith(status: FormzStatus.submissionInProgress),
            validFormState.copyWith(status: FormzStatus.submissionSuccess),
          ],
        );
      });

      group('emailAlreadyExists', () {
        setUp(() {
          when(mockCreateNewUserCase(any)).thenAnswer(
            (_) async => Right(EmailAlreadyExists()),
          );
        });

        blocTest(
          '''should emit state with submission in progress status and 
            state with submission failure when form is invalid because of
            existing email''',
          build: () => validBloc,
          act: (bloc) {
            bloc.add(FormSubmitted());
          },
          skip: 6,
          expect: [
            validFormState.copyWith(status: FormzStatus.submissionInProgress),
            validFormState.copyWith(
              email: EmailInput.dirty(tEmail, true),
              status: FormzStatus.invalid,
            ),
          ],
        );
      });

      group('server failure', () {
        setUp(() {
          when(mockCreateNewUserCase(any)).thenAnswer(
            (_) async => Left(ServerFailure()),
          );
        });

        blocTest(
          '''should emit state with submission in progress status and 
            state with submission failure when form is valid but a server error
            has occurred''',
          build: () => validBloc,
          act: (bloc) {
            bloc.add(FormSubmitted());
          },
          skip: 6,
          expect: [
            validFormState.copyWith(status: FormzStatus.submissionInProgress),
            validFormState.copyWith(status: FormzStatus.submissionFailure),
          ],
        );
      });
    });

    group('invalid', () {
      blocTest(
        '''should emit state with dirty inputs and  invalid status''',
        build: () => bloc,
        act: (bloc) {
          bloc.add(FormSubmitted());
        },
        expect: [
          SignupFormState(
            firstName: NameInput.dirty(),
            lastName: NameInput.dirty(),
            email: EmailInput.dirty(),
            password: PasswordInput.dirty(),
            confirmPassword: ConfirmPasswordInput.dirty(
              password: '',
              value: '',
            ),
            role: RoleInput.dirty(),
            status: FormzStatus.invalid,
          ),
        ],
      );
    });
  });
}
