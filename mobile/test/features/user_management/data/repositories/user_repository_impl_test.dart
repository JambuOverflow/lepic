import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/network/network_info.dart';
import 'package:mobile/core/network/response.dart';
import 'package:mobile/features/user_management/data/data_sources/user_local_data_source.dart';
import 'package:mobile/features/user_management/data/data_sources/user_remote_data_source.dart';
import 'package:mobile/features/user_management/data/repositories/user_repository_impl.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock implements UserRemoteDataSource {}

class MockLocalDataSource extends Mock implements UserLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  UserRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  User tUser;
  UserModel tUserModel;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = UserRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );

    tUser = User(
      localId: 1,
      firstName: 'v',
      lastName: 'c',
      email: 'v@g.com',
      role: Role.teacher,
      password: '123',
    );

    tUserModel = UserModel(
      localId: 1,
      firstName: 'v',
      lastName: 'c',
      email: 'v@g.com',
      username: 'v@g.com',
      role: Role.teacher,
      password: '123',
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getLoggedInUser', () {
    test('should get User from local cache when there is cached data',
        () async {
      when(mockLocalDataSource.getLoggedInUser())
          .thenAnswer((_) async => tUserModel);

      final result = await repository.getLoggedInUser();

      verify(mockLocalDataSource.getLoggedInUser());
      expect(result, Right<Failure, User>(tUser));
    });

    test('should throw cache failure when there is not cached data', () async {
      when(mockLocalDataSource.getLoggedInUser()).thenThrow(CacheException());

      final result = await repository.getLoggedInUser();

      verify(mockLocalDataSource.getLoggedInUser());
      expect(result, Left(CacheFailure()));
    });
  });

  group('createUser', () {
    test('should test if device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      repository.createUser(tUser);
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      Response response;

      test('should send new User with successful response', () async {
        when(mockRemoteDataSource.createUser(tUserModel))
            .thenAnswer((_) async => response);

        final result = await repository.createUser(tUser);

        verify(mockRemoteDataSource.createUser(tUserModel));
        expect(result, Right(response));
      });

      test('should cache user when call is successful', () async {
        when(mockRemoteDataSource.createUser(tUserModel))
            .thenAnswer((_) async => response);

        await repository.createUser(tUser);

        verify(mockRemoteDataSource.createUser(tUserModel));
        verify(mockLocalDataSource.cacheUser(tUserModel));
      });

      test('should return server failure when call is unsuccessful', () async {
        when(mockRemoteDataSource.createUser(tUserModel))
            .thenThrow(ServerException());

        final result = await repository.createUser(tUser);

        expect(result, Left(ServerFailure()));
      });

      test('''should return server failure when token 
        is invalid in a successful response''', () async {
        when(mockRemoteDataSource.createUser(tUserModel))
            .thenThrow(ServerException());

        final result = await repository.login(tUser);

        expect(result, Left(ServerFailure()));
      });
    });

    runTestsOffline(() {
      test('should throw server failure', () async {
        when(mockRemoteDataSource.createUser(tUserModel))
            .thenThrow(ServerFailure());

        final result = await repository.createUser(tUser);

        expect(result, Left(ServerFailure()));
      });
    });
  });

  group('updateUser', () {
    final String token = 'test';

    test('should test if device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      repository.updateUser(tUser, token);
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      Response response;

      test('should send updated user with successful response', () async {
        when(mockRemoteDataSource.updateUser(tUserModel, token))
            .thenAnswer((_) async => response);

        final result = await repository.updateUser(tUser, token);

        verify(mockRemoteDataSource.updateUser(tUserModel, token));
        expect(result, Right(response));
      });

      test('should cache user when call is successful', () async {
        when(mockRemoteDataSource.updateUser(tUserModel, token))
            .thenAnswer((_) async => response);

        await repository.updateUser(tUser, token);

        verify(mockRemoteDataSource.updateUser(tUserModel, token));
        verify(mockLocalDataSource.cacheUser(tUserModel));
      });

      test('should return server failure when call is unsuccessful', () async {
        when(mockRemoteDataSource.updateUser(tUserModel, token))
            .thenThrow(ServerException());

        final result = await repository.updateUser(tUser, token);

        expect(result, Left(ServerFailure()));
      });
    });

    runTestsOffline(() {
      test('should throw server failure', () async {
        when(mockRemoteDataSource.updateUser(tUserModel, token))
            .thenThrow(ServerFailure());

        final result = await repository.updateUser(tUser, token);

        expect(result, Left(ServerFailure()));
      });
    });
  });

  group('login', () {
    test('should test if device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      repository.login(tUser);
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      final response = TokenResponse(token: 'secret');

      test('should login user with successful response', () async {
        when(mockRemoteDataSource.login(tUserModel))
            .thenAnswer((_) async => response);

        final result = await repository.login(tUser);

        verify(mockRemoteDataSource.login(tUserModel));
        expect(result, Right(response));
      });

      test('should securely cache token received when call is successful',
          () async {
        when(mockRemoteDataSource.login(tUserModel))
            .thenAnswer((_) async => response);

        await repository.login(tUser);

        verify(mockRemoteDataSource.login(tUserModel));
        verify(mockLocalDataSource.storeTokenSecurely(
            token: anyNamed('token'), user: tUserModel));
      });

      test('should cache user when call is successful', () async {
        when(mockRemoteDataSource.login(tUserModel))
            .thenAnswer((_) async => response);

        await repository.login(tUser);

        verify(mockRemoteDataSource.login(tUserModel));
        verify(mockLocalDataSource.cacheUser(tUserModel));
      });

      test('should return invalid credentials', () async {
        when(mockRemoteDataSource.login(tUserModel))
            .thenAnswer((_) async => InvalidCredentials());

        final result = await repository.login(tUser);

        expect(result, Right(InvalidCredentials()));
      });

      test('should return server failure when call returns exception',
          () async {
        when(mockRemoteDataSource.login(tUserModel))
            .thenThrow(ServerException());

        final result = await repository.login(tUser);

        expect(result, Left(ServerFailure()));
      });

      test('should return server failure when call is unsuccessful', () async {
        when(mockRemoteDataSource.login(tUserModel))
            .thenAnswer((_) async => UnsuccessfulResponse(message: 'on noes'));

        final result = await repository.login(tUser);

        expect(result, Left(ServerFailure()));
      });
    });

    runTestsOffline(() {
      test('should return server failure', () async {
        when(mockRemoteDataSource.login(tUserModel)).thenThrow(ServerFailure());

        final result = await repository.login(tUser);

        expect(result, Left(ServerFailure()));
      });
    });
  });

  group('retrieveToken', () {
    final String tToken = 'aASj24s4#sf';

    test('should get token from local cache when the user token exists',
        () async {
      when(mockLocalDataSource.retrieveToken(any))
          .thenAnswer((_) async => tToken);

      final result = await repository.retrieveToken(tUser);

      verify(mockLocalDataSource.retrieveToken(tUserModel));
      expect(result, Right(tToken));
    });

    test('should throw cache failure when there is not cached token', () async {
      when(mockLocalDataSource.retrieveToken(any)).thenThrow(CacheException());

      final result = await repository.retrieveToken(tUser);

      verify(mockLocalDataSource.retrieveToken(tUserModel));
      expect(result, Left(CacheFailure()));
    });
  });
}
