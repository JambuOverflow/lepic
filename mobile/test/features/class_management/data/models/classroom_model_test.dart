import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/features/class_management/data/models/classroom_model.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:moor/moor.dart';

import '../../../../core/fixtures/fixture_reader.dart';

void main() {
  final tClassModel =
      ClassroomModel(grade: 1, localId: 2, name: "A", tutorId: 3);

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
        "tutor_id": 3,
      };

      expect(result, expectedMap);
    });
  });
}
