import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:moor/moor.dart';

class ClassroomModels extends Table {
  @JsonKey("local_id")
  IntColumn get localId => integer().autoIncrement()();
  IntColumn get grade => integer()();
  TextColumn get title => text()();
  @JsonKey("last_updated")
  DateTimeColumn get lastUpdated => dateTime()();
  @JsonKey("client_last_updated")
  DateTimeColumn get clientLastUpdated => dateTime()();
  BoolColumn get deleted => boolean()();
  @JsonKey("tutor_id")
  IntColumn get tutorId => integer()();
  IntColumn get school => integer()
      .customConstraint("NOT NULL REFERENCES school_models(local_id)")();
}
