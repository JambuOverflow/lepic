import 'package:flutter/rendering.dart';
import 'package:mobile/features/text_correction/domain/entities/correction.dart';
import 'package:mobile/features/text_correction/domain/entities/mistake.dart';

import '../database.dart';

class MistakeEntityModelConverter {
  Correction modelToEntity(List<MistakeModel> models) {
    if (models.isEmpty){
      throw ErrorDescription(
          "'model' is empty",
        );
    }
    
    final int studentId = models[0].studentId;
    final int textId = models[0].textId;

    List<Mistake> mistakes = _getMistakes(models, studentId, textId);

    return Correction(
      textId: textId,
      studentId: studentId,
      mistakes: mistakes,
    );
  }

  List<Mistake> _getMistakes(List<MistakeModel> models, int studentId, int textId) {
    List<Mistake> mistakes = [];
    for (var model in models) {
      Mistake mistake = _extractMistake(model);
    
      if (model.studentId != studentId || model.textId != textId) {
        throw ErrorDescription(
          """List of mistakes contain mistakes with 
        different studentIds or textIDs""",
        );
      }
      mistakes.add(mistake);
    }
    return mistakes;
  }

  Mistake _extractMistake(MistakeModel model) {
    var mistake = Mistake(
      commentary: model.commentary,
      localId: model.localId,
      wordIndex: model.wordIndex,
    );
    return mistake;
  }

  List<MistakeModel> entityToModel(Correction entity) {
    List<MistakeModel> mistakeModels = [];
    MistakeModel mistakeModel;
    for (var mistake in entity.mistakes) {
      mistakeModel = MistakeModel(
          studentId: entity.studentId,
          textId: entity.textId,
          localId: mistake.localId,
          wordIndex: mistake.wordIndex,
          commentary: mistake.commentary);
      mistakeModels.add(mistakeModel);
    }

    return mistakeModels;
  }
}
