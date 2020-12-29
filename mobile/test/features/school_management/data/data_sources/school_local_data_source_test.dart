import 'dart:ffi';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/network/network_info.dart';
import 'package:mobile/features/school_management/domain/entities/school.dart';
import 'package:mobile/features/school_management/data/data_sources/school_local_data_source.dart';
import 'package:mobile/features/user_management/data/models/user_model.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:matcher/matcher.dart';

class MockDatabase extends Mock implements Database {}

Future<void> main() {
  MockDatabase mockDatabase;
  SchoolLocalDataSourceImpl schoolLocalDataSourceImpl;

  final tValidPk = 1;

  final tUser = User(
    firstName: 'v',
    lastName: 'c',
    email: 'v@g.com',
    role: Role.teacher,
    password: '123',
    id: 1,
  );

  final tUserModel = userEntityToModel(tUser);

  final tSchoolInputModel1 = SchoolModel(
    localId: null,
    userId: 1,
    name: 'A',
    zipCode: 0,
    modality: Modality.public,
    state: 'B',
    city: 'C',
    neighborhood: 'D',
  );

  final tSchoolInputModel2 = SchoolModel(
    localId: null,
    userId: 1,
    name: 'AA',
    zipCode: 0,
    modality: Modality.public,
    state: 'B',
    city: 'C',
    neighborhood: 'D',
  );

  final tSchoolModel1 = SchoolModel(
    localId: 1,
    userId: 1,
    name: 'A',
    zipCode: 0,
    modality: Modality.public,
    state: 'B',
    city: 'C',
    neighborhood: 'D',
  );

  final tSchoolCompanion1 = tSchoolInputModel1.toCompanion(true);

  final tSchoolModels = [tSchoolInputModel1, tSchoolInputModel2];

  setUp(() async {
    mockDatabase = MockDatabase();

    schoolLocalDataSourceImpl = SchoolLocalDataSourceImpl(
      database: mockDatabase,
    );
  });

  group("cacheSchool", () {
    test("should correctly cache and return a valid school", () async {
      when(mockDatabase.insertSchool(tSchoolCompanion1))
          .thenAnswer((_) async => tValidPk);

      final result =
          await schoolLocalDataSourceImpl.cacheNewSchool(tSchoolInputModel1);
      verify(mockDatabase.insertSchool(tSchoolCompanion1));
      expect(result, tSchoolModel1);
    });

    test("should throw CacheException when trying to insert an invalid school",
        () {
      when(mockDatabase.insertSchool(tSchoolCompanion1))
          .thenThrow(SqliteException(787, ""));
      expect(
          () async => await schoolLocalDataSourceImpl
              .cacheNewSchool(tSchoolInputModel1),
          throwsA(TypeMatcher<CacheException>()));
    });
  });

  group("deleteSchool", () {
    test("should correctly delete a cached school", () async {
      when(mockDatabase.deleteSchool(tValidPk)).thenAnswer((_) async => 1);

      await schoolLocalDataSourceImpl.deleteSchoolFromCache(tSchoolModel1);
      verify(mockDatabase.deleteSchool(tValidPk));
    });

    test("should throw CacheException when trying to delete an ivalid school",
        () {
      when(mockDatabase.deleteSchool(tValidPk)).thenAnswer((_) async => 0);
      expect(
          () async => await schoolLocalDataSourceImpl
              .deleteSchoolFromCache(tSchoolModel1),
          throwsA(TypeMatcher<CacheException>()));
    });
  });

  group("getSchool", () {
    test("should correctly return a list of schools", () async {
      when(mockDatabase.getSchools(tValidPk))
          .thenAnswer((_) async => tSchoolModels);

      final result =
          await schoolLocalDataSourceImpl.getSchoolsFromCache(tUserModel);

      verify(mockDatabase.getSchools(tValidPk));
      final testResult = listEquals(result, tSchoolModels);
      equals(testResult);
    });

    test("should correctly return an empty list", () async {
      when(mockDatabase.getSchools(tValidPk)).thenAnswer((_) async => []);

      final result =
          await schoolLocalDataSourceImpl.getSchoolsFromCache(tUserModel);

      verify(mockDatabase.getSchools(tValidPk));
      final testResult = listEquals(result, []);
      equals(testResult);
    });

    test("should throw a CacheException", () async {
      when(mockDatabase.getSchools(tValidPk))
          .thenThrow(SqliteException(787, ""));

      expect(
          () async =>
              await schoolLocalDataSourceImpl.getSchoolsFromCache(tUserModel),
          throwsA(TypeMatcher<CacheException>()));
    });
  });

  group("updateSchool", () {
    test("should correctly update a cached school", () async {
      when(mockDatabase.updateSchool(tSchoolModel1))
          .thenAnswer((_) async => true);

      await schoolLocalDataSourceImpl.updateCachedSchool(tSchoolModel1);
      verify(mockDatabase.updateSchool(tSchoolModel1));
    });

    test("should throw a cache expection if the update was not completed",
        () async {
      when(mockDatabase.updateSchool(tSchoolModel1))
          .thenAnswer((_) async => false);

      expect(
          () async =>
              await schoolLocalDataSourceImpl.updateCachedSchool(tSchoolModel1),
          throwsA(TypeMatcher<CacheException>()));
    });
  });
}
