import 'package:mobile/features/text_correction/domain/entities/mistake.dart';
import '../database.dart';

class MistakeEntityModelConverter {
  Mistake modelToEntity(MistakeModel model) {
    return Mistake(
      localId: model.localId,
      commentary: model.commentary,
      wordIndex: model.wordIndex,
    );
  }

  List<Mistake> modelsToEntityList(List<MistakeModel> models) {
    List<Mistake> result = [];
    Mistake localMistake;
    for (var i = 0; i < models.length; i++) {
      localMistake = modelToEntity(models[i]);
      result.add(localMistake);
    }

    return result;
  }

  MistakeModel entityToModel({Mistake entity, int correctionId}) {
    return MistakeModel(
        localId: entity.localId,
        commentary: entity.commentary,
        wordIndex: entity.wordIndex,
        correctionId: correctionId);
  }

  List<MistakeModel> entitiesToModelList({
    List<Mistake> entities,
    int correctionId,
  }) {
    List<MistakeModel> result = [];
    MistakeModel localModel;
    for (var i = 0; i < entities.length; i++) {
      localModel = entityToModel(
        entity: entities[i],
        correctionId: correctionId,
      );
      result.add(localModel);
    }
    return result;
  }
}
