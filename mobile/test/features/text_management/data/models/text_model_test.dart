import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/features/text_management/data/models/text_model.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';

import '../../../../core/fixtures/fixture_reader.dart';

void main() {
  final tTextModel = TextModel(title: '1', localId: 2, body: "A", classId: 3);

  final tTextEntity = Text(title: '1', localId: 2, body: "A", classId: 3);

  group("from json", () {
    test("should return a valid Text model", () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('text'));

      final result = TextModel.fromJson(jsonMap);

      expect(result, tTextModel);
    });
  });

  group('toJson', () {
    test('should return a Text JSON map with proper data', () async {
      final result = tTextModel.toJson();

      final expectedMap = {
        "local_id": 2,
        "title": '1',
        "body": "A", 
        "class_id": 3
      };

      expect(result, expectedMap);
    });
  });

  group('modelToEntity', () {
    test('should return a Text entity with proper data', () async {
      final result = textModelToEntity(tTextModel);

      expect(result, tTextEntity);
    });
  });

  group('entityToModel', () {
    test('should return a Text model with proper data', () async {
      final result = textEntityToModel(tTextEntity);

      expect(result, tTextModel);
    });
  });
}
