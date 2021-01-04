import 'package:flutter/rendering.dart';
import 'package:mobile/features/text_correction/domain/entities/correction.dart';
import 'package:mobile/features/text_correction/domain/entities/mistake.dart';

import '../database.dart';

class MistakeEntityModelConverter {
  Correction modelToEntity(List<MistakeModel> models) {
    if (models.length == 0){
      throw ErrorDescription(
          "Models are empty",
        );
    }
    List<Mistake> mistakes = [];
    final int studentId = models[0].studentId;
    final int textId = models[0].textId;

    for (var model in models) {
      var mistake = Mistake(
        commentary: model.commentary,
        localId: model.localId,
        wordIndex: model.wordIndex,
      );

      if (model.studentId != studentId || model.textId != textId) {
        throw ErrorDescription(
          """List of mistakes contain mistakes with 
        different studentIds or textIDs""",
        );
      }
      mistakes.add(mistake);
    }

    return Correction(
      textId: textId,
      studentId: studentId,
      mistakes: mistakes,
    );
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
