import 'package:mobile/features/student_management/domain/entities/student.dart';
import '../database.dart';

class StudentEntityModelConverter {
  Student modelToEntity(StudentModel model) {
    return Student(
      firstName: model.firstName,
      lastName: model.lastName,
      classroomId: model.classroomId,
    );
  }

  Future<StudentModel> entityToModel(Student entity) async {
    return StudentModel(
      localId: entity.id,
      firstName: entity.firstName,
      lastName: entity.lastName,
      classroomId: entity.classroomId,
    );
  }
}
