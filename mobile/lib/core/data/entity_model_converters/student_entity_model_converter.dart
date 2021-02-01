import 'package:mobile/features/student_management/domain/entities/student.dart';
import '../database.dart';

class StudentEntityModelConverter {
  Student classroomModelToEntity(StudentModel model) {
    return Student(
      firstName: model.firstName,
      lastName: model.lastName,
      classroomId: model.classroomId,
    );
  }

  Future<StudentModel> classroomEntityToModel(Student entity) async {
    return StudentModel(
      localId: entity.id,
      firstName: entity.firstName,
      lastName: entity.lastName,
      classroomId: entity.classroomId,
    );
  }
}
