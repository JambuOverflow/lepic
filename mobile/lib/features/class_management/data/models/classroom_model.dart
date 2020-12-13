import 'package:mobile/core/data/database.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:moor/moor.dart';

class ClassroomModels extends Table {
  @JsonKey("local_id")
  IntColumn get localId => integer().autoIncrement()();
  IntColumn get grade => integer()();
  TextColumn get name => text()();
  @JsonKey("tutor_id")
  IntColumn get tutorId =>
      integer().customConstraint('NOT NULL REFERENCES user_models(local_id)')();
}

Classroom classroomModelToEntity(ClassroomModel model) {
  return Classroom(
      id: model.localId,
      grade: model.grade,
      name: model.name,
      tutorId: model.tutorId);
}

ClassroomModel classroomEntityToModel(Classroom entity) {
  return ClassroomModel(
      localId: entity.id,
      grade: entity.grade,
      name: entity.name,
      tutorId: entity.tutorId);
}

