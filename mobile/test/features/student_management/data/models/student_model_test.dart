import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import "package:mobile/core/data/database.dart";
import 'package:mobile/features/student_management/data/models/student_model.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import '../../../../core/fixtures/fixture_reader.dart';

void main() {
  final tStudentModel = StudentModel(
    firstName: '1',
    lastName: 'canavarro',
    localId: 1,
    classroomId: 2,
  );

  final tStudent = Student(
    firstName: '1',
    lastName: 'canavarro',
    id: 1,
    classroomId: 2,
  );

  group("from json", () {
    test("should return a valid Student model", () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('student'));

      final result = StudentModel.fromJson(jsonMap);

      expect(result, tStudentModel);
    });
  });

  group("to json", () {
    test("should return a Student JSON map with proper data", () async {
      final result = tStudentModel.toJson();

      final expectedMap = {
        "local_id": 1,
        "first_name": "1",
        "last_name": "canavarro",
        "classroom_id": 2,
      };

      expect(result, expectedMap);
    });
  });
  group('modelToEntity', () {
    test('should return a Student entity with proper data', () async {
      final result = studentModelToEntity(tStudentModel);

      expect(result, tStudent);
    });
  });

  group('entityToModel', () {
    test('should return a Student model with proper data', () async {
      final result = studentEntityToModel(tStudent);

      expect(result, tStudentModel);
    });
  });
}
