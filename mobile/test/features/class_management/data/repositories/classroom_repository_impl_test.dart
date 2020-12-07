import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/network/network_info.dart';
import 'package:mobile/features/class_management/data/data_sources/classroom_local_data_source.dart';
import 'package:mobile/features/class_management/data/data_sources/classroom_remote_data_source.dart';
import 'package:mobile/features/class_management/data/repositories/classroom_repository_impl.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockClassroomLocalDataSource extends Mock
    implements ClassroomLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockClassroomRemoteDataSource extends Mock
    implements ClassroomRemoteDataSource {}

void main() {
  MockClassroomRemoteDataSource mockRemoteDataSource;
  MockClassroomLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;
  ClassroomRepositoryImpl repository;

  final tUser = User(
    firstName: 'v',
    lastName: 'c',
    email: 'v@g.com',
    role: Role.teacher,
    password: '123',
  );

  final tClassroom = Classroom(
    tutor: tUser,
    grade: 1,
    name: "A",
    id: 1,
  );

  setUp(() {
    mockRemoteDataSource = MockClassroomRemoteDataSource();
    mockLocalDataSource = MockClassroomLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = ClassroomRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('createClassroom', () {
    void testCacheFailure() {
      test('should return CacheFailure when cache is unsuccessful', () async {
        when(mockLocalDataSource.cacheClassroom(tClassroom))
            .thenThrow(CacheException());

        final result = await repository.createClassroom(tClassroom);

        expect(result, Left(CacheFailure()));
      });
    }

    test('should check if the device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      repository.createClassroom(tClassroom);

      verify(mockNetworkInfo.isConnected);
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should cache newly created classroom', () async {
        when(mockLocalDataSource.cacheClassroom(tClassroom))
            .thenAnswer((_) async => tClassroom);

        final result = await repository.createClassroom(tClassroom);

        verify(mockLocalDataSource.cacheClassroom(tClassroom));
        expect(result, Right(tClassroom));
        verifyNoMoreInteractions(mockLocalDataSource);
      });

      testCacheFailure();
    });

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('should send new classroom when call is successful', () async {
        when(mockRemoteDataSource.sendNewClassroom(tClassroom))
            .thenAnswer((realInvocation) async => tClassroom);

        final result = await repository.createClassroom(tClassroom);

        verify(mockRemoteDataSource.sendNewClassroom(tClassroom));
        expect(result, Right(tClassroom));
      });

      test('should cache classroom returned by a successful call', () async {
        when(mockRemoteDataSource.sendNewClassroom(tClassroom))
            .thenAnswer((realInvocation) async => tClassroom);

        final result = await repository.createClassroom(tClassroom);

        verify(mockLocalDataSource.cacheClassroom(tClassroom));
        expect(result, Right(tClassroom));
      });

      test('should return ServerFailure when call is unsuccessful', () async {
        when(mockRemoteDataSource.sendNewClassroom(tClassroom))
            .thenThrow(ServerException());

        final result = await repository.createClassroom(tClassroom);

        expect(result, Left(ServerFailure()));
      });

      testCacheFailure();
    });
  });

  group('delete', () {
    test('should test if the device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      await repository.deleteClassroom(tClassroom);

      verify(mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('should delete local cached classroom', () async {
        when(mockLocalDataSource.deleteClassroomFromCache(tClassroom))
            .thenAnswer((_) async => null);

        await repository.deleteClassroom(tClassroom);

        verify(mockLocalDataSource.deleteClassroomFromCache(tClassroom));
        verifyNoMoreInteractions(mockLocalDataSource);
      });

      test('should return valid response when call is successful', () async {
        final response = http.Response('Yay', 204);

        when(mockRemoteDataSource.deleteClassroom(tClassroom))
            .thenAnswer((_) async => response);

        final result = await repository.deleteClassroom(tClassroom);

        expect(result, Right(response));
      });

      test('should return server failure when call is unsuccessful', () async {
        when(mockRemoteDataSource.deleteClassroom(tClassroom))
            .thenThrow(ServerException());

        final result = await repository.deleteClassroom(tClassroom);

        expect(result, Left(ServerFailure()));
      });
    });
  });
}
