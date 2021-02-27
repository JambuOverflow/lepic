import 'package:moor/moor.dart';

class AudioModels extends Table {
  @JsonKey("local_id")
  IntColumn get localId => integer().autoIncrement()();
  TextColumn get title => text()();
  @JsonKey("audio_data")
  BlobColumn get audioData => blob()();
  @JsonKey("audio_duration_in_seconds")
  IntColumn get audioDurationInSeconds => integer()();
  @JsonKey('text_id')
  IntColumn get textId =>
      integer().customConstraint('NOT NULL REFERENCES text_models(local_id)')();
  @JsonKey('student_id')
  IntColumn get studentId => integer()
      .customConstraint('NOT NULL REFERENCES student_models(local_id)')();
}
