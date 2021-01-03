part of 'student_bloc.dart';

abstract class StudentEvent extends Equatable {
  const StudentEvent();
}

class CreateStudentEvent extends StudentEvent {
  final String firstName;
  final String lastName;

  @override
  List<Object> get props => [firstName, lastName];

  CreateStudentEvent({
    @required this.firstName,
    @required this.lastName,
  });
}

class UpdateStudentEvent extends StudentEvent {
  final Student student;
  final String firstName;
  final String lastName;

  @override
  List<Object> get props => [firstName, lastName, student];

  UpdateStudentEvent({
    @required this.student,
    @required this.firstName,
    @required this.lastName,
  });
}

class DeleteStudentEvent extends StudentEvent {
  final Student student;

  @override
  List<Object> get props => [student];

  DeleteStudentEvent({@required this.student});
}

class GetStudentsEvent extends StudentEvent {
  @override
  List<Object> get props => [];
}
