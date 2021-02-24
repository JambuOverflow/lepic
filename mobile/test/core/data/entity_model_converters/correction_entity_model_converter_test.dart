import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/data/entity_model_converters/correction_entity_model_converter.dart';
import 'package:mobile/features/text_correction/domain/entities/correction.dart';

void main() {
  CorrectionEntityModelConverter correctionEntityModelConverter;

  setUp(() {
    correctionEntityModelConverter = CorrectionEntityModelConverter();
  });

  final tCorrectionEntity =
      Correction(localId: 1, textId: 1, studentId: 1, mistakes: []);

  final tCorrectionModel = CorrectionModel(localId: 1, textId: 1, studentId: 1);

  group('modelToEntity', () {
    test('should return a Correction entity with proper data', () async {
      final result = correctionEntityModelConverter.modelToEntity(model: tCorrectionModel, 
      mistakes: []);

      expect(result, tCorrectionEntity);
    });

  });

  group('entityToModel', () {
    test('should return a Classroom model with proper data', () {
      final CorrectionModel result = correctionEntityModelConverter.entityToModel(
          tCorrectionEntity);

      expect(result, tCorrectionModel);
    });

  });
}
