import 'package:moor/moor.dart';

class TextModels extends Table {
  @JsonKey("local_id")
  IntColumn get localId => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  @JsonKey("tutor_id")
  IntColumn get tutorId => integer()();
  @JsonKey("creation_date")
  DateTimeColumn get creationDate => dateTime()();
  @JsonKey("student_id")
  IntColumn get studentId => integer()
      .customConstraint('NOT NULL REFERENCES student_models(local_id) ON DELETE CASCADE')();
}
