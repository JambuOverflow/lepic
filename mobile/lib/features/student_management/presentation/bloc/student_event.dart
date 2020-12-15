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

class UpdateStudentEvent extends _StudentManagementEvent {}

class DeleteStudentEvent extends _StudentManagementEvent {}

class GetStudentEvent extends StudentEvent {
  final int id;
  final String firstName;

  GetStudentEvent(
    this.id,
    this.firstName,
  );
}
