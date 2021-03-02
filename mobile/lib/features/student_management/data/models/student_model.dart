import 'package:mobile/core/data/database.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:moor/moor.dart';

class StudentModels extends Table {
  @JsonKey('local_id')
  IntColumn get localId => integer().autoIncrement()();
  @JsonKey('first_name')
  TextColumn get firstName => text()();
  @JsonKey('last_name')
  TextColumn get lastName => text()();
  @JsonKey('classroom_id')
  IntColumn get classroomId => integer()
      .customConstraint('NOT NULL REFERENCES classroom_models(local_id) ON DELETE CASCADE')();
}

Student studentModelToEntity(StudentModel model) {
  return Student(
    firstName: model.firstName,
    lastName: model.lastName,
    id: model.localId,
    classroomId: model.classroomId,
  );
}

StudentModel studentEntityToModel(Student student) {
  return StudentModel(
    firstName: student.firstName,
    lastName: student.lastName,
    localId: student.id,
    classroomId: student.classroomId,
  );
}
