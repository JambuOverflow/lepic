import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:mobile/features/user_management/domain/use_cases/get_logged_in_user_use_case.dart';
import 'package:mobile/features/user_management/domain/use_cases/logout_use_case.dart';
import 'package:mobile/features/user_management/presentation/bloc/auth_bloc.dart';
import 'package:mockito/mockito.dart';

class MockGetLoggedInUserCase extends Mock implements GetLoggedInUserCase {}

class MockLogoutCase extends Mock implements LogoutCase {}

void main() {
  AuthBloc authBloc;
  MockGetLoggedInUserCase mockGetLoggedInUserCase;
  MockLogoutCase mockLogoutCase;

  final tUser = User(
    firstName: 'v',
    lastName: 'c',
    email: 'vc@gmail.com',
    role: Role.support,
    password: 'ABCdef123',
  );

  setUp(() {
    mockGetLoggedInUserCase = MockGetLoggedInUserCase();
    mockLogoutCase = MockLogoutCase();

    authBloc = AuthBloc(
      getLoggedInUserCase: mockGetLoggedInUserCase,
      logoutCase: mockLogoutCase,
    );
  });

  AuthBloc setUpUserAndReturnBloc() {
    when(mockGetLoggedInUserCase(NoParams())).thenAnswer(
      (_) async => Right(tUser),
    );

    return authBloc;
  }

  AuthBloc setUpNoUserAndReturnBloc() {
    when(mockGetLoggedInUserCase(NoParams())).thenAnswer(
      (_) async => Right(null),
    );

    return authBloc;
  }

  group('appStarted', () {
    blocTest(
      '''should emit state with user and authenticated status when app started
      and user is logged in''',
      build: () => setUpUserAndReturnBloc(),
      act: (bloc) => bloc.add(AppStartedEvent()),
      expect: [
        AuthState(status: AuthStatus.authenticating),
        AuthState(user: tUser, status: AuthStatus.authenticated),
      ],
    );

    blocTest(
      '''should emit state with no user and unauthenticated status when app 
      started and user is not logged in''',
      build: () => setUpNoUserAndReturnBloc(),
      act: (bloc) => bloc.add(AppStartedEvent()),
      expect: [
        AuthState(status: AuthStatus.authenticating),
        AuthState(user: null, status: AuthStatus.unauthenticated),
      ],
    );
  });

  group('userLoggedInEvent', () {
    blocTest(
      '''should emit state with user and authenticated status when 
      user logged in''',
      build: () => setUpUserAndReturnBloc(),
      act: (bloc) => bloc.add(UserLoggedInEvent()),
      expect: [
        AuthState(status: AuthStatus.authenticating),
        AuthState(user: tUser, status: AuthStatus.authenticated),
      ],
    );

    blocTest(
      '''should emit state with no user and error status when 
      user logged in but no user was found''',
      build: () => setUpNoUserAndReturnBloc(),
      act: (bloc) => bloc.add(UserLoggedInEvent()),
      expect: [
        AuthState(status: AuthStatus.authenticating),
        AuthState(user: null, status: AuthStatus.error),
      ],
    );
  });

  group('userLoggedOut', () {
    blocTest(
      'should emit state with no user and unauthenticated when user logs out',
      build: () {
        when(mockLogoutCase(any)).thenAnswer((_) async => Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(UserLoggedOutEvent()),
      expect: [
        AuthState(status: AuthStatus.authenticating),
        AuthState(user: null, status: AuthStatus.unauthenticated),
      ],
    );

    blocTest(
      '''should emit state with no user and error status when 
      user logged out failed''',
      build: () {
        when(mockLogoutCase(any)).thenAnswer((_) async => Left(CacheFailure()));
        return authBloc;
      },
      act: (bloc) => bloc.add(UserLoggedOutEvent()),
      expect: [
        AuthState(status: AuthStatus.authenticating),
        AuthState(user: null, status: AuthStatus.error),
      ],
    );
  });
}
