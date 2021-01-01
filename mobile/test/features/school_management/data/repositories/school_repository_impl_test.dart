import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/data/entity_model_converters/school_entity_model_converter.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/features/class_management/data/models/classroom_model.dart';
import 'package:mobile/features/class_management/data/repositories/classroom_repository_impl.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/school_management/data/data_sources/school_local_data_source.dart';
import 'package:mobile/features/school_management/data/models/school_model.dart';
import 'package:mobile/features/school_management/data/repositories/school_repository_impl.dart';
import 'package:mobile/features/school_management/domain/entities/school.dart';
import 'package:mobile/features/user_management/data/models/user_model.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:mockito/mockito.dart';

class MockSchoolLocalDataSource extends Mock implements SchoolLocalDataSource {}

class MockSchoolEntityModelConverter extends Mock
    implements SchoolEntityModelConverter {}

void main() {
  MockSchoolLocalDataSource mockLocalDataSource;
  SchoolRepositoryImpl repository;
  MockSchoolEntityModelConverter mockSchoolEntityModelConverter;

  final tUser = User(
    firstName: 'v',
    lastName: 'c',
    email: 'v@g.com',
    role: Role.teacher,
    password: '123',
    id: 1,
  );

  final tSchool = School(
    id: 1,
    userId: 1,
    name: 'A',
    zipCode: 0,
    modality: Modality.public,
    state: 'B',
    city: 'C',
    neighborhood: 'D',
  );

  final tSchoolModel = SchoolModel(
    localId: 1,
    userId: 1,
    name: "A",
    zipCode: 0,
    modality: Modality.public,
    state: "B",
    city: "C",
    neighborhood: "D",
  );
  final tUserModel = userEntityToModel(tUser);

  final tSchoolModels = [tSchoolModel, tSchoolModel];
  final tSchools = [tSchool, tSchool];

  setUp(() {
    mockLocalDataSource = MockSchoolLocalDataSource();
    mockSchoolEntityModelConverter = MockSchoolEntityModelConverter();

    repository = SchoolRepositoryImpl(
      localDataSource: mockLocalDataSource,
      schoolEntityModelConverter: mockSchoolEntityModelConverter,
    );

    when(mockSchoolEntityModelConverter.schoolEntityToModel(any))
        .thenAnswer((_) async => tSchoolModel);

    when(mockSchoolEntityModelConverter.schoolModelToEntity(any))
        .thenAnswer((_) => tSchool);
  });

  group('createSchool', () {
    test('should return CacheFailure when cache is unsuccessful', () async {
      when(mockLocalDataSource.cacheNewSchool(tSchoolModel))
          .thenThrow(CacheException());

      final result = await repository.createSchool(tSchool);

      expect(result, Left(CacheFailure()));
    });

    test('should cache newly created school', () async {
      when(mockLocalDataSource.cacheNewSchool(tSchoolModel))
          .thenAnswer((_) async => tSchoolModel);

      final result = await repository.createSchool(tSchool);

      verify(mockLocalDataSource.cacheNewSchool(tSchoolModel));
      expect(result, Right(tSchool));
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('delete', () {
    test('should delete a school', () async {
      when(mockLocalDataSource.deleteSchoolFromCache(tSchoolModel))
          .thenAnswer((_) async => _);

      await repository.deleteSchool(tSchool);

      verify(mockLocalDataSource.deleteSchoolFromCache(tSchoolModel));
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return a CacheFailure when a CacheException is throw',
        () async {
      when(mockLocalDataSource.deleteSchoolFromCache(tSchoolModel))
          .thenThrow(CacheException());

      final result = await repository.deleteSchool(tSchool);
      verify(mockLocalDataSource.deleteSchoolFromCache(tSchoolModel));

      expect(result, Left(CacheFailure()));
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('update', () {
    test('should return a classroom when updateSchool is called', () async {
      when(mockLocalDataSource.updateCachedSchool(tSchoolModel))
          .thenAnswer((_) async => tSchoolModel);

      final result = await repository.updateSchool(tSchool);

      verify(mockLocalDataSource.updateCachedSchool(tSchoolModel));
      expect(result, Right(tSchool));
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return a CacheFailure when a CacheException is throw',
        () async {
      when(mockLocalDataSource.updateCachedSchool(tSchoolModel))
          .thenThrow(CacheException());

      final result = await repository.updateSchool(tSchool);

      verify(mockLocalDataSource.updateCachedSchool(tSchoolModel));
      expect(result, Left(CacheFailure()));
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('get', () {
    test('should return a list of schools when getSchools is called', () async {
      when(mockLocalDataSource.getSchoolsFromCache(tUserModel))
          .thenAnswer((_) async => tSchoolModels);

      final result = await repository.getSchools(tUser);
      final List<School> resultList = result.getOrElse(() => null);

      final resultTest = listEquals(resultList, tSchools);
      equals(resultTest);
    });

    test('should return a CacheFailure when a CacheException is throw',
        () async {
      when(mockLocalDataSource.getSchoolsFromCache(tUserModel))
          .thenThrow(CacheException());

      final result = await repository.getSchools(tUser);

      expect(result, Left(CacheFailure()));
    });
  });
}
