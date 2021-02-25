import 'package:mobile/features/text_correction/domain/entities/correction.dart';
import 'package:mobile/features/text_correction/domain/entities/mistake.dart';
import '../database.dart';

class CorrectionEntityModelConverter {
  Correction modelToEntity({CorrectionModel model, List<Mistake> mistakes}) {
    return Correction(
      localId: model.localId,
      studentId: model.studentId,
      textId: model.textId,
      mistakes: mistakes,
    );
  }

  CorrectionModel entityToModel(Correction entity) {
    return CorrectionModel(
      localId: entity.localId,
      studentId: entity.studentId,
      textId: entity.textId,
    );
  }
}
