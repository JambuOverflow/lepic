import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/network/network_info.dart';
import 'package:mobile/features/class_management/data/data_sources/classroom_local_data_source.dart';
import 'package:mobile/features/class_management/data/repositories/classroom_repository_impl.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockClassroomLocalDataSource extends Mock
    implements ClassroomLocalDataSource {}

void main() {
  MockClassroomLocalDataSource mockLocalDataSource;
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
    mockLocalDataSource = MockClassroomLocalDataSource();

    repository = ClassroomRepositoryImpl(
      localDataSource: mockLocalDataSource,
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

  group('delete', () {

    
  });
}
