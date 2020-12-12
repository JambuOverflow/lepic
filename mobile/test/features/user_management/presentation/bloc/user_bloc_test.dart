import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/network/response.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:mobile/features/user_management/domain/use_cases/create_new_user.dart';
import 'package:mobile/features/user_management/domain/use_cases/user_params.dart';
import 'package:mobile/features/user_management/presentation/bloc/bloc/user_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mobile/features/user_management/domain/use_cases/login.dart';

class MockCreateNewUserCase extends Mock implements CreateNewUserCase {}

class MockLoginCase extends Mock implements LoginCase {}

void main() {
  UserBloc bloc;
  MockCreateNewUserCase mockCreateNewUser;
  MockLoginCase mockLoginCase;

  setUp(() {
    mockCreateNewUser = MockCreateNewUserCase();
    mockLoginCase = MockLoginCase();
    bloc = UserBloc(
      createNewUser: mockCreateNewUser,
      login: mockLoginCase,
    );
  });

  test('initial state should be NotLoggedIn', () {
    expect(bloc.state, NotLoggedIn());
  });

  group('CreateNewUser', () {
    final String tFirstName = 'v';
    final String tLastName = 'c';
    final String tEmail = 'vc@g.com';
    final Role tRole = Role.support;
    final String tPassword = '123';

    test('''should emit [CreatingUser, UserCreated] when user 
    creation is successful''', () {
      when(mockCreateNewUser(any))
          .thenAnswer((_) async => Right(SuccessfulResponse()));

      final expected = [
        CreatingUser(),
        UserCreated(response: SuccessfulResponse()),
      ];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(CreateNewUserEvent(
        tFirstName,
        tLastName,
        tEmail,
        tRole,
        tPassword,
      ));
    });

    test('''should emit [CreatingUser, Error] when user creation 
    is unsuccessful''', () {
      when(mockCreateNewUser(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        CreatingUser(),
        Error(message: 'oh noes'),
      ];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(CreateNewUserEvent(
        tFirstName,
        tLastName,
        tEmail,
        tRole,
        tPassword,
      ));
    });
  });

  group('Logging', () {
    final tUser = User(
      firstName: 'v',
      lastName: 'c',
      email: 'v@g.com',
      role: Role.teacher,
      password: '123',
    );

    test('should emit [Logging, LoggedIn] when login is successful', () async {
      // Arrange
      when(mockLoginCase(UserParams(user: tUser)))
          .thenAnswer((_) async => Right(SuccessfulResponse()));

      final expected = [Logging(), LoggedIn()];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(LoggingUserEvent(tUser.email, tUser.password));
    });

    test('should emit [Logging, Error] when login is unsuccessful', () async {
      // Arrange
      when(mockLoginCase(UserParams(user: tUser)))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [Logging(), Error(message: ':(')];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(LoggingUserEvent(tUser.email, tUser.password));
    });
  });
}
