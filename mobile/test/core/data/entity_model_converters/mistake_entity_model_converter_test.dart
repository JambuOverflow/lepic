import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/data/entity_model_converters/mistake_entity_model_converter.dart';
import 'package:mobile/features/text_correction/domain/entities/correction.dart';
import 'package:mobile/features/text_correction/domain/entities/mistake.dart';

void main() {
  MistakeEntityModelConverter mistakeEntityModelConverter;

  setUp(() {
    mistakeEntityModelConverter = MistakeEntityModelConverter();
  });

  final tMistakeModel = MistakeModel(
    wordIndex: 1,
    commentary: "B",
    localId: 1,
    studentId: 2,
    textId: 3,
  );

  final tMistakeEntity = Mistake(
    wordIndex: 1,
    commentary: "B",
    localId: 1,
  );

  final tCorrection =
      Correction(mistakes: [tMistakeEntity], studentId: 2, textId: 3);

  group('modelToEntity', () {
    test('should return a Mistake entity with proper data', () async {
      final result =
          mistakeEntityModelConverter.modelToEntity([tMistakeModel]);

      expect(result, tCorrection);
    });
  });

  group('entityToModel', () {
    test('should return a Classroom model with proper data', () {
      final result = mistakeEntityModelConverter
          .entityToModel(tCorrection);

      expect(result, [tMistakeModel]);
    });
  });
}
