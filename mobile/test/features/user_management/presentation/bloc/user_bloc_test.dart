import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/network/response.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:mobile/features/user_management/domain/use_cases/create_user_use_case.dart';
import 'package:mobile/features/user_management/domain/use_cases/update_user_use_case.dart';
import 'package:mobile/features/user_management/domain/use_cases/user_params.dart';
import 'package:mobile/features/user_management/presentation/bloc/bloc/user_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mobile/features/user_management/domain/use_cases/login.dart';

class MockCreateNewUserCase extends Mock implements CreateNewUserCase {}

class MockLoginCase extends Mock implements LoginCase {}

class MockUpdateUserCase extends Mock implements UpdateUserCase {}

void main() {
  UserBloc bloc;
  MockCreateNewUserCase mockCreateNewUser;
  MockLoginCase mockLoginCase;
  MockUpdateUserCase mockUpdateUserCase;

  setUp(() {
    mockCreateNewUser = MockCreateNewUserCase();
    mockLoginCase = MockLoginCase();
    mockUpdateUserCase = MockUpdateUserCase();
    bloc = UserBloc(
      createNewUser: mockCreateNewUser,
      login: mockLoginCase,
      updateUser: mockUpdateUserCase,
    );
  });

  final tUser = User(
    firstName: 'v',
    lastName: 'c',
    email: 'v@g.com',
    role: Role.teacher,
    password: '123',
  );

  final String tFirstName = 'v';
  final String tLastName = 'c';
  final String tEmail = 'vc@g.com';
  final Role tRole = Role.support;
  final String tPassword = '123';

  test('initial state should be NotLoggedIn', () {
    expect(bloc.state, NotLoggedIn());
  });

  group('CreateNewUser', () {
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
        Error(message: 'Not able to create an user'),
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
    test('should emit [Logging, LoggedIn] when login is successful', () async {
      when(mockLoginCase(UserParams(user: tUser)))
          .thenAnswer((_) async => Right(SuccessfulResponse()));

      final expected = [Logging(), LoggedIn()];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(LoggingUserEvent(tUser.email, tUser.password));
    });

    test('should emit [Logging, Error] when login is unsuccessful', () async {
      when(mockLoginCase(UserParams(user: tUser)))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [Logging(), Error(message: ':(')];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(LoggingUserEvent(tUser.email, tUser.password));
    });
  });

  group('updateUser', () {
    test('''should emit [UpdatingUser, UserUpdated] when update 
    is successful''', () async {
      when(mockUpdateUserCase(any)).thenAnswer(
        (_) async => Right(SuccessfulResponse()),
      );

      final expected = [
        UpdatingUser(),
        UserUpdated()
      ]; //não achei o getter pra updating user(acho que é esse que tá faltando)

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(UpdateUserEvent(
        tFirstName,
        tLastName,
        tEmail,
        tRole,
        tPassword,
      ));
    });

    test('''should emit [UpdatingUser, Error] when user creation 
    is unsuccessful''', () {
      when(mockUpdateUserCase(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        UpdatingUser(),
        Error(message: 'Not able to create/update a user')
      ];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(UpdateUserEvent(
        tFirstName,
        tLastName,
        tEmail,
        tRole,
        tPassword,
      ));
    });
  });
}
