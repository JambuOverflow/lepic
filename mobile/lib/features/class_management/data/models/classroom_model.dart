import 'package:moor/moor.dart';

class ClassroomModels extends Table {
  @JsonKey("local_id")
  IntColumn get localId => integer().autoIncrement()();
  IntColumn get grade => integer()();
  TextColumn get name => text()();
  @JsonKey("last_updated")
  DateTimeColumn get lastUpdated => dateTime()();
  @JsonKey("client_last_updated")
  DateTimeColumn get clientLastUpdated => dateTime()();
  BoolColumn get deleted => boolean()();
  @JsonKey("tutor_id")
  IntColumn get tutorId =>
      integer().customConstraint('NOT NULL REFERENCES user_models(local_id)')();
}
