import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/data/entity_model_converters/classroom_entity_model_converter.dart';
import 'package:mobile/core/data/serializer.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/user_management/data/data_sources/user_local_data_source.dart';
import 'package:mockito/mockito.dart';
import 'package:moor/moor.dart';
import '../../../../core/fixtures/fixture_reader.dart';

class MockUserLocalDataSourceImpl extends Mock
    implements UserLocalDataSourceImpl {}

void main() {
  moorRuntimeOptions.defaultSerializer = Serializer();
  final time = DateTime.utc(2018, 1, 1, 1, 1);
  ClassroomEntityModelConverter classroomEntityModelConverter;
  MockUserLocalDataSourceImpl mockUserLocalDataSourceImpl;
  final tClassModel = ClassroomModel(
    grade: 1,
    localId: 2,
    name: "A",
    tutorId: 3,
    deleted: false,
    lastUpdated: time,
    clientLastUpdated: time,
  );

  final tClassEntity = Classroom(
    grade: 1,
    id: 2,
    name: "A",
    deleted: false,
    lastUpdated: time,
    clientLastUpdated: time,
  );

  setUp(() {
    mockUserLocalDataSourceImpl = MockUserLocalDataSourceImpl();
    classroomEntityModelConverter = ClassroomEntityModelConverter(
        userLocalDataSource: mockUserLocalDataSourceImpl);
  });

  group("from json", () {
    test("should return a valid Classroom model", () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('classroom'));

      final result = ClassroomModel.fromJson(jsonMap);

      expect(result, tClassModel);
    });
  });

  group('toJson', () {
    test('should return a Classroom JSON map with proper data', () async {
      final result = tClassModel.toJson();

      final expectedMap = {
        "local_id": 2,
        "grade": 1,
        "name": "A",
        "last_updated": 1514768460000,
        "client_last_updated": 1514768460000,
        "deleted": false,
        "tutor_id": 3,
      };

      expect(result, expectedMap);
    });
  });

  group('modelToEntity', () {
    test('should return a Classroom entity with proper data', () async {
      final result =
          classroomEntityModelConverter.classroomModelToEntity(tClassModel);

      expect(result, tClassEntity);
    });
  });

  group('entityToModel', () {
    test('should return a Classroom model with proper data', () async {
      when(mockUserLocalDataSourceImpl.getUserId()).thenAnswer((_) async => 3);
      final result = await classroomEntityModelConverter
          .classroomEntityToModel(tClassEntity);

      expect(result, tClassModel);
    });
  });
}
