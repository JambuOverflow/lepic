import 'package:moor/moor.dart';

class CorrectionModels extends Table {
  @JsonKey("local_id")
  IntColumn get localId => integer().autoIncrement()();
  @JsonKey('text_id')
  IntColumn get textId => integer()
      .customConstraint('NOT NULL REFERENCES text_models(local_id)')();
  @JsonKey('student_id')
  IntColumn get studentId => integer()
      .customConstraint('NOT NULL REFERENCES student_models(local_id)')();
}
