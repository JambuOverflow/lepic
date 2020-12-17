part of 'student_bloc.dart';

abstract class StudentEvent extends Equatable {
  const StudentEvent();

  @override
  List<Object> get props => [];
}

class _StudentManagementEvent extends StudentEvent {
  final String firstName;
  final String lastName;
  final int id;
  final int classroomId;

  _StudentManagementEvent(
    this.firstName,
    this.lastName,
    this.classroomId,
    this.id,
  );
}

class CreateNewStudentEvent extends _StudentManagementEvent {
  CreateNewStudentEvent(
    String firstName,
    String lastName,
    int id,
    int classroomId,
  ) : super(firstName, lastName, id, classroomId);
}

class UpdateStudentEvent extends _StudentManagementEvent {
  UpdateStudentEvent(
    String firstName,
    String lastName,
    int id,
    int classroomId,
  ) : super(firstName, lastName, id, classroomId);
}

class DeleteStudentEvent extends StudentEvent {
  final int id;

  DeleteStudentEvent(
    this.id,
  );
}

class GetStudentEvent extends _StudentManagementEvent {
  final String firstName;
  final String lastName;
  final int id;
  final int classroomId;

  GetStudentEvent(
    this.firstName,
    this.lastName,
    this.classroomId,
    this.id,
  ) : super(firstName, lastName, classroomId, id);
}
