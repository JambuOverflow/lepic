import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/data/entity_model_converters/school_entity_model_converter.dart';
import 'package:mobile/core/data/serializer.dart';
import 'package:mobile/features/school_management/data/models/school_model.dart';
import 'package:mobile/features/school_management/domain/entities/school.dart';
import 'package:moor/moor.dart';
import '../../../../core/fixtures/fixture_reader.dart';

void main() {
  moorRuntimeOptions.defaultSerializer = Serializer();

  final tSchoolModel = SchoolModel(
    localId: 1,
    userId: 1,
    name: 'A',
    zipCode: 0,
    modality: Modality.municipal,
    state: 'B',
    city: 'C',
    neighborhood: 'D',
  );

  final tSchoolEntity = School(
    id: 1,
    userId: 1,
    name: 'A',
    zipCode: 0,
    modality: Modality.municipal,
    state: 'B',
    city: 'C',
    neighborhood: 'D',
  );

  group("from json", () {
    test("should return a valid School model", () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('school'));

      final result = SchoolModel.fromJson(jsonMap);

      expect(result, tSchoolModel);
    });
  });

  group('toJson', () {
    test('should return a School JSON map with proper data', () async {
      final result = tSchoolModel.toJson();

      final expectedMap = {
        "local_id": 1,
        "user_id": 1,
        "zip_code": 0,
        "modality": 0,
        "state": "B",
        "city": "C",
        "neighborhood": "D",
        "name": "A",
      };

      expect(result, expectedMap);
    });
  });
}
