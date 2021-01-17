import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import '../database.dart';

class AudioEntityModelConverter {

  AudioEntity modelToEntity(AudioModel model) {
    return AudioEntity(
      localId: model.localId,
      title: model.title,
      audioData: model.audioData,
      studentId: model.studentId,
      textId: model.textId,
    );
  }

  Future<AudioModel> entityToModel(AudioEntity entity) async {
    return AudioModel(
      localId: entity.localId,
      audioData: entity.audioData,
      title: entity.title,
      studentId: entity.studentId,
      textId: entity.textId,
    );
  }
}
