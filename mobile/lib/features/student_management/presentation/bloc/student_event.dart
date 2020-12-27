part of 'student_bloc.dart';

abstract class StudentEvent extends Equatable {
  const StudentEvent();

  @override
  List<Object> get props => [];
}

abstract class StudentManagementEvent extends StudentEvent {
  final String firstName;
  final String lastName;
  final int classroomId;

  StudentManagementEvent(
    this.firstName,
    this.lastName,
    this.classroomId,
  );
}

class CreateNewStudentEvent extends StudentManagementEvent {
  CreateNewStudentEvent({
    @required String firstName,
    @required String lastName,
    @required int classroomId,
  }) : super(firstName, lastName, classroomId);
}

class UpdateStudentEvent extends StudentManagementEvent {
  UpdateStudentEvent({
    String firstName,
    String lastName,
    @required int classroomId,
  }) : super(firstName, lastName, classroomId);
}

class DeleteStudentEvent extends StudentEvent {
  final int id;

  DeleteStudentEvent({@required this.id});
}

class GetStudentsEvent extends StudentEvent {}
