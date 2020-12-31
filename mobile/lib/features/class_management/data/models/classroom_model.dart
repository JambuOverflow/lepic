import 'package:mobile/core/data/database.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/user_management/data/data_sources/user_local_data_source.dart';
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

class ClassroomEntityModelConverter {
  final UserLocalDataSource userLocalDataSource;

  ClassroomEntityModelConverter({@required this.userLocalDataSource});

  Classroom classroomModelToEntity(ClassroomModel model) {
    return Classroom(
      id: model.localId,
      grade: model.grade,
      name: model.name,
      deleted: model.deleted,
      lastUpdated: model.lastUpdated,
      clientLastUpdated: model.clientLastUpdated,
    );
  }

  Future<ClassroomModel> classroomEntityToModel(Classroom entity) async {
    bool deleted;
    DateTime lastUpdated;

    if (entity.deleted == null) {
      deleted = false;
    } else {
      deleted = entity.deleted;
    }

    if (entity.lastUpdated == null) {
      lastUpdated = DateTime(0).toUtc();
    } else {
      lastUpdated = entity.lastUpdated;
    }
    final int userId = await userLocalDataSource.getUserId();

    return ClassroomModel(
      localId: entity.id,
      grade: entity.grade,
      name: entity.name,
      tutorId: userId,
      lastUpdated: lastUpdated,
      deleted: deleted,
      clientLastUpdated: entity.clientLastUpdated,
    );
  }
}
