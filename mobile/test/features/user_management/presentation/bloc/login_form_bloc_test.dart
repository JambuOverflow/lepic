import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/network/response.dart';
import 'package:mobile/core/presentation/validators/email_input.dart';
import 'package:mobile/core/presentation/validators/not_empty_input.dart';
import 'package:mobile/features/user_management/domain/use_cases/login.dart';
import 'package:mobile/features/user_management/presentation/bloc/login_form_bloc.dart';
import 'package:mockito/mockito.dart';

class MockLoginCase extends Mock implements LoginCase {}

void main() {
  LoginFormBloc bloc;
  MockLoginCase mockLogin;

  final tEmail = 'vitornovaes.cantao@gmail.com';

  setUp(() {
    mockLogin = MockLoginCase();
    bloc = LoginFormBloc(loginCase: mockLogin);
  });

  group('emailChanged', () {
    blocTest(
      'should emit state with dirty email',
      build: () => bloc,
      act: (bloc) => bloc.add(EmailChanged(email: tEmail)),
      expect: [
        LoginFormState(
          email: EmailInput.dirty(tEmail),
          status: FormzStatus.invalid,
        )
      ],
    );
  });

  group('passwordChanged', () {
    final tPassword = 'ABCdef123';

    blocTest(
      'should emit state with dirty password',
      build: () => bloc,
      act: (bloc) => bloc.add(PasswordChanged(password: tPassword)),
      expect: [
        LoginFormState(
          password: NotEmptyInput.dirty(tPassword),
          status: FormzStatus.invalid,
        )
      ],
    );
  });

  group('formSubmitted', () {
    blocTest(
      'should emit state with invalid status when no input field was changed',
      build: () => bloc,
      act: (bloc) => bloc.add(FormSubmitted()),
      expect: [
        LoginFormState(
          email: EmailInput.dirty(),
          password: NotEmptyInput.dirty(),
          status: FormzStatus.pure,
        )
      ],
    );

    group('invalid', () {
      blocTest(
        'should emit state with invalid status when email is empty',
        build: () => bloc,
        act: (bloc) {
          bloc.add(PasswordChanged(password: 'a'));
          bloc.add(FormSubmitted());
        },
        skip: 1,
        expect: [
          LoginFormState(
            password: NotEmptyInput.dirty('a'),
            email: EmailInput.dirty(),
            status: FormzStatus.invalid,
          ),
        ],
      );

      final tInvalidEmail = 'vc@gmail';

      blocTest(
        'should emit state with invalid status when email is invalid',
        build: () => bloc,
        act: (bloc) {
          bloc.add(EmailChanged(email: tInvalidEmail));
          bloc.add(PasswordChanged(password: '123'));
          bloc.add(FormSubmitted());
        },
        skip: 2,
        expect: [
          LoginFormState(
            email: EmailInput.dirty(tInvalidEmail),
            password: NotEmptyInput.dirty('123'),
            status: FormzStatus.invalid,
          ),
        ],
      );

      blocTest(
        'should emit state with invalid status when password is empty',
        build: () => bloc,
        act: (bloc) {
          bloc.add(EmailChanged(email: tEmail));
          bloc.add(FormSubmitted());
        },
        skip: 1,
        expect: [
          LoginFormState(
            password: NotEmptyInput.dirty(),
            email: EmailInput.dirty(tEmail),
            status: FormzStatus.invalid,
          ),
        ],
      );
    });

    group('valid', () {
      group('failure', () {
        setUp(() {
          when(mockLogin(any)).thenAnswer((_) async => Left(ServerFailure()));
        });

        blocTest(
          '''should emit state with submission in progress state and submission
        failed when login returned failure''',
          build: () => bloc,
          act: (bloc) {
            bloc.add(EmailChanged(email: tEmail));
            bloc.add(PasswordChanged(password: 'a'));
            bloc.add(FormSubmitted());
          },
          skip: 2,
          expect: [
            LoginFormState(
              email: EmailInput.dirty(tEmail),
              password: NotEmptyInput.dirty('a'),
              status: FormzStatus.submissionInProgress,
            ),
            LoginFormState(
              email: EmailInput.dirty(tEmail),
              password: NotEmptyInput.dirty('a'),
              status: FormzStatus.submissionFailure,
            ),
          ],
        );
      });

      group('success', () {
        setUp(() {
          when(mockLogin(any)).thenAnswer(
            (_) async => Right(SuccessfulResponse()),
          );
        });

        blocTest(
          '''should emit state with submission in progress state and submission
        success when login returned success response''',
          build: () => bloc,
          act: (bloc) {
            bloc.add(EmailChanged(email: tEmail));
            bloc.add(PasswordChanged(password: 'a'));
            bloc.add(FormSubmitted());
          },
          skip: 2,
          expect: [
            LoginFormState(
              email: EmailInput.dirty(tEmail),
              password: NotEmptyInput.dirty('a'),
              status: FormzStatus.submissionInProgress,
            ),
            LoginFormState(
              email: EmailInput.dirty(tEmail),
              password: NotEmptyInput.dirty('a'),
              status: FormzStatus.submissionSuccess,
            ),
          ],
        );

        blocTest(
          '''should emit state with submission in progress state and invalid
           when login returned unsuccessful response''',
          build: () {
            when(mockLogin(any)).thenAnswer(
              (_) async => Right(InvalidCredentials()),
            );
            return bloc;
          },
          act: (bloc) {
            bloc.add(EmailChanged(email: tEmail));
            bloc.add(PasswordChanged(password: 'a'));
            bloc.add(FormSubmitted());
          },
          skip: 2,
          expect: [
            LoginFormState(
              email: EmailInput.dirty(tEmail),
              password: NotEmptyInput.dirty('a'),
              status: FormzStatus.submissionInProgress,
            ),
            LoginFormState(
              email: EmailInput.dirty(tEmail),
              password: NotEmptyInput.dirty('a'),
              status: FormzStatus.invalid,
              isCredentialInvalid: true,
            ),
          ],
        );
      });
    });
  });
}
