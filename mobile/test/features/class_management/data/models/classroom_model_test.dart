import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:moor/moor.dart';
import '../../../../core/fixtures/fixture_reader.dart';
import 'package:mobile/features/class_management/data/models/classroom_model.dart';

void main() {
  final tClassModel = ClassroomModel(
    grade: 1,
    localId: 2,
    name: "A",
    tutorId: 3,
    deleted: false,
    lastUpdated: DateTime(2020),
    clientLastUpdated: DateTime(2020),
  );

  final tClassEntity = Classroom(
    grade: 1,
    id: 2,
    name: "A",
    tutorId: 3,
    deleted: false,
    lastUpdated: DateTime(2020),
    clientLastUpdated: DateTime(2020),
  );

  final tClassCompanion = ClassroomModelsCompanion(
    grade: Value(1),
    name: Value("A"),
    tutorId: Value(3),
    deleted: Value(false),
    lastUpdated: Value(DateTime(2020)),
    clientLastUpdated: Value(DateTime(2020)),
  );

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
        "lastUpdated": 1577847600000,
        "clientLastUpdated": 1577847600000,
        "deleted": false,
        "tutor_id": 3,
        
      };

      expect(result, expectedMap);
    });
  });

  group('modelToEntity', () {
    test('should return a Classroom entity with proper data', () async {
      final result = classroomModelToEntity(tClassModel);

      expect(result, tClassEntity);
    });
  });

  group('entityToModel', () {
    test('should return a Classroom model with proper data', () async {
      final result = classroomEntityToModel(tClassEntity);

      expect(result, tClassModel);
    });
  });
}
