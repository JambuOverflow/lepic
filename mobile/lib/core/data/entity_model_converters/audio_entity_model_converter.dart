import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import '../database.dart';

class AudioEntityModelConverter {

  AudioEntity modelToEntity(AudioModel model) {
    return AudioEntity(
      localId: model.localId,
      title: model.title,
      data: model.audioData,
      studentId: model.studentId,
      textId: model.textId,
    );
  }

  AudioModel entityToModel(AudioEntity entity) {
    return AudioModel(
      localId: entity.localId,
      audioData: entity.data,
      title: entity.title,
      studentId: entity.studentId,
      textId: entity.textId,
    );
  }
}
