import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/data/entity_model_converters/mistake_entity_model_converter.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/features/text_correction/domain/entities/correction.dart';
import 'package:mobile/features/text_correction/domain/entities/mistake.dart';
import 'package:matcher/matcher.dart';
import 'package:collection/collection.dart';

void main() {
  MistakeEntityModelConverter mistakeEntityModelConverter;

  setUp(() {
    mistakeEntityModelConverter = MistakeEntityModelConverter();
  });

  final tMistakeModel = MistakeModel(
    wordIndex: 1,
    commentary: "B",
    localId: 1,
    correctionId: 1,
  );

  final tMistakeEntity1 = Mistake(
    wordIndex: 1,
    commentary: "B",
    localId: 1,
  );

  final tMistakeEntity2 = Mistake(
    wordIndex: 1,
    commentary: "B",
    localId: 2,
  );

  group('modelToEntity', () {
    test('should return a Mistake entity with proper data', () async {
      final result = mistakeEntityModelConverter.modelToEntity(tMistakeModel);

      expect(result, tMistakeEntity1);
    });

    test(
        'should return a list Mistake entities with proper data',
        () async {
      final result = mistakeEntityModelConverter.modelsToEntityList(
          [tMistakeModel, tMistakeModel.copyWith(localId: 2)]);
      equals(listEquals(result, [tMistakeEntity1, tMistakeEntity2]));
    });
  });

  group('entityToModel', () {
    test('should return a Classroom model with proper data', () {
      final MistakeModel result = mistakeEntityModelConverter.entityToModel(entity: tMistakeEntity1, 
      correctionId: 1);

      expect(result, tMistakeModel);
    });

    test(
        'should return a list of Classroom models with proper data',
        () async {
      final result = mistakeEntityModelConverter.entitiesToModelList(
          entities: [tMistakeEntity1, tMistakeEntity2], correctionId: 1);
      equals(listEquals(result, [tMistakeModel, tMistakeModel.copyWith(localId: 2)]));
    });
  });
}
