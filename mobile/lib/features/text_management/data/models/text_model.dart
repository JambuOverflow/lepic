import 'package:moor/moor.dart';

class TextModels extends Table {
  @JsonKey("local_id")
  IntColumn get localId => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  @JsonKey("tutor_id")
  IntColumn get tutorId => integer()();
  @JsonKey("class_id")
  IntColumn get classId => integer()
      .customConstraint('NOT NULL REFERENCES classroom_models(local_id)')();
}