import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/network/network_info.dart';
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
      firstName: 'v',
      lastName: 'c',
      email: 'v@g.com',
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

  group('getStoredUser', () {
    test('should get User from local cache when there is cached data',
        () async {
      when(mockLocalDataSource.getStoredUser()).thenAnswer((_) async => tUser);

      final result = await repository.getStoredUser();

      verify(mockLocalDataSource.getStoredUser());
      expect(result, Right(tUser));
    });

    test('should throw cache failure when there is not cached data', () async {
      when(mockLocalDataSource.getStoredUser()).thenThrow(CacheException());

      final result = await repository.getStoredUser();

      verify(mockLocalDataSource.getStoredUser());
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
      http.Response response;

      test('should send new User with successful response', () async {
        when(mockRemoteDataSource.createUser(tUser))
            .thenAnswer((_) async => response);

        final result = await repository.createUser(tUser);

        verify(mockRemoteDataSource.createUser(tUser));
        expect(result, Right(response));
      });

      test('should cache user when call is successful', () async {
        when(mockRemoteDataSource.createUser(tUser))
            .thenAnswer((_) async => response);

        await repository.createUser(tUser);

        verify(mockRemoteDataSource.createUser(tUser));
        verify(mockLocalDataSource.cacheUser(tUser));
      });

      test('should return server failure when call is unsuccessful', () async {
        when(mockRemoteDataSource.createUser(tUser))
            .thenThrow(ServerException());

        final result = await repository.createUser(tUser);

        expect(result, Left(ServerFailure()));
      });
    });

    runTestsOffline(() {
      test('should throw server failure', () async {
        when(mockRemoteDataSource.createUser(tUser)).thenThrow(ServerFailure());

        final result = await repository.createUser(tUser);

        expect(result, Left(ServerFailure()));
      });
    });
  });

  group('updateUser', () {
    test('should test if device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      repository.updateUser(tUser);
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      http.Response response;

      test('should send updated user with successful response', () async {
        when(mockRemoteDataSource.updateUser(tUser))
            .thenAnswer((_) async => response);

        final result = await repository.updateUser(tUser);

        verify(mockRemoteDataSource.updateUser(tUser));
        expect(result, Right(response));
      });

      test('should cache user when call is successful', () async {
        when(mockRemoteDataSource.updateUser(tUser))
            .thenAnswer((_) async => response);

        await repository.updateUser(tUser);

        verify(mockRemoteDataSource.updateUser(tUser));
        verify(mockLocalDataSource.cacheUser(tUser));
      });

      test('should return server failure when call is unsuccessful', () async {
        when(mockRemoteDataSource.updateUser(tUser))
            .thenThrow(ServerException());

        final result = await repository.updateUser(tUser);

        expect(result, Left(ServerFailure()));
      });
    });

    runTestsOffline(() {
      test('should throw server failure', () async {
        when(mockRemoteDataSource.updateUser(tUser)).thenThrow(ServerFailure());

        final result = await repository.updateUser(tUser);

        expect(result, Left(ServerFailure()));
      });
    });
  });
}
