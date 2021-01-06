part of 'student_bloc.dart';

abstract class StudentEvent extends Equatable {
  const StudentEvent();

  @override
  List<Object> get props => [];
}

class CreateNewStudentEvent extends StudentEvent {
  final String firstName;
  final String lastName;

  CreateNewStudentEvent({
    @required this.firstName,
    @required this.lastName,
  });
}

class UpdateStudentEvent extends StudentEvent {
  final Student student;
  final String firstName;
  final String lastName;

  UpdateStudentEvent({
    @required this.student,
    @required this.firstName,
    @required this.lastName,
  });
}

class DeleteStudentEvent extends StudentEvent {
  final Student student;

  DeleteStudentEvent({@required this.student});
}

class LoadStudentsEvent extends StudentEvent {}
