part of 'student_bloc.dart';

abstract class StudentEvent extends Equatable {
  const StudentEvent();

  @override
  List<Object> get props => [];
}

abstract class StudentManagementEvent extends StudentEvent {
  final String firstName;
  final String lastName;

  StudentManagementEvent(
    this.firstName,
    this.lastName,
  );
}

class CreateNewStudentEvent extends StudentManagementEvent {
  CreateNewStudentEvent({
    @required String firstName,
    @required String lastName,
  }) : super(firstName, lastName);
}

class UpdateStudentEvent extends StudentManagementEvent {
  UpdateStudentEvent({
    String firstName,
    String lastName,
  }) : super(firstName, lastName);
}

class DeleteStudentEvent extends StudentEvent {
  final int id;

  DeleteStudentEvent({@required this.id});
}

class GetStudentsEvent extends StudentEvent {}
