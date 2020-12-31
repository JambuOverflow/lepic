import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/features/class_management/data/data_sources/classroom_local_data_source.dart';
import 'package:mobile/features/class_management/data/models/classroom_model.dart';
import 'package:mobile/features/class_management/data/repositories/classroom_repository_impl.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/user_management/data/data_sources/user_local_data_source.dart';
import 'package:mobile/features/user_management/data/models/user_model.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:mockito/mockito.dart';
import 'package:clock/clock.dart';

class MockClassroomLocalDataSource extends Mock
    implements ClassroomLocalDataSource {}

class MockClock extends Mock implements Clock {}

class MockUserLocalDataSourceImpl extends Mock
    implements UserLocalDataSourceImpl {}

void main() {
  MockClassroomLocalDataSource mockLocalDataSource;
  MockClock mockClock;
  ClassroomRepositoryImpl repository;
  ClassroomModel tClassroomModel;
  UserModel tUserModel;
  List<ClassroomModel> tClassroomsModels;
  List<Classroom> tClassrooms;
  ClassroomEntityModelConverter classroomEntityModelConverter;
  MockUserLocalDataSourceImpl mockUserLocalDataSourceImpl;

  final nowTime = DateTime.now();
  final nowTimeUtc = nowTime.toUtc();

  final tUser = User(
    firstName: 'v',
    lastName: 'c',
    email: 'v@g.com',
    role: Role.teacher,
    password: '123',
    id: 1,
  );

  final tClassroom = Classroom(
    grade: 1,
    name: "A",
    id: 1,
    deleted: false,
    lastUpdated: nowTimeUtc,
    clientLastUpdated: nowTimeUtc,
  );

  setUp(() async {
    mockLocalDataSource = MockClassroomLocalDataSource();
    mockClock = MockClock();
    mockUserLocalDataSourceImpl = MockUserLocalDataSourceImpl();
    classroomEntityModelConverter = ClassroomEntityModelConverter(
        userLocalDataSource: mockUserLocalDataSourceImpl);
    tClassroomModel = await classroomEntityModelConverter.classroomEntityToModel(tClassroom);
    tUserModel = userEntityToModel(tUser);

    tClassroomsModels = [tClassroomModel, tClassroomModel];
    tClassrooms = [tClassroom, tClassroom];

    repository = ClassroomRepositoryImpl(
      localDataSource: mockLocalDataSource,
      clock: mockClock,
      clasrooomEntityModelConverter: classroomEntityModelConverter
    );

    when(mockClock.now()).thenAnswer((_) => nowTime);
  });

  group('createClassroom', () {
    test('should return CacheFailure when cache is unsuccessful', () async {
      when(mockLocalDataSource.cacheNewClassroom(tClassroomModel))
          .thenThrow(CacheException());

      final result = await repository.createClassroom(tClassroom);

      expect(result, Left(CacheFailure()));
    });

    test('should cache newly created classroom', () async {
      when(mockLocalDataSource.cacheNewClassroom(tClassroomModel))
          .thenAnswer((_) async => tClassroomModel);

      final result = await repository.createClassroom(tClassroom);

      verify(mockLocalDataSource.cacheNewClassroom(tClassroomModel));
      expect(result, Right(tClassroom));
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('delete', () {
    test('should delete a classroom', () async {
      when(mockLocalDataSource.deleteClassroomFromCache(tClassroomModel))
          .thenAnswer((_) async => _);

      await repository.deleteClassroom(tClassroom);

      verify(mockLocalDataSource.deleteClassroomFromCache(tClassroomModel));
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return a CacheFailure when a CacheException is throw',
        () async {
      when(mockLocalDataSource.deleteClassroomFromCache(tClassroomModel))
          .thenThrow(CacheException());

      final result = await repository.deleteClassroom(tClassroom);
      verify(mockLocalDataSource.deleteClassroomFromCache(tClassroomModel));

      expect(result, Left(CacheFailure()));
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('update', () {
    test('should return a classroom when updateClassroom is called', () async {
      when(mockLocalDataSource.updateCachedClassroom(tClassroomModel))
          .thenAnswer((_) async => tClassroomModel);

      final result = await repository.updateClassroom(tClassroom);

      verify(mockLocalDataSource.updateCachedClassroom(tClassroomModel));
      expect(result, Right(tClassroom));
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return a CacheFailure when a CacheException is throw',
        () async {
      when(mockLocalDataSource.updateCachedClassroom(tClassroomModel))
          .thenThrow(CacheException());

      final result = await repository.updateClassroom(tClassroom);

      verify(mockLocalDataSource.updateCachedClassroom(tClassroomModel));
      expect(result, Left(CacheFailure()));
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('get', () {
    test('should return a list of classrooms when getClassrooms is called',
        () async {
      when(mockLocalDataSource.getClassroomsFromCache(tUserModel))
          .thenAnswer((_) async => tClassroomsModels);

      final result = await repository.getClassrooms(tUser);
      final List<Classroom> resultList = result.getOrElse(() => null);

      final resultTest = listEquals(resultList, tClassrooms);
      equals(resultTest);
    });

    test('should return a CacheFailure when a CacheException is throw',
        () async {
      when(mockLocalDataSource.getClassroomsFromCache(tUserModel))
          .thenThrow(CacheException());

      final result = await repository.getClassrooms(tUser);

      expect(result, Left(CacheFailure()));
    });
  });
}
