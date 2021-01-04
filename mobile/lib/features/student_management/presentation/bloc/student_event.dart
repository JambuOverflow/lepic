part of 'student_bloc.dart';

@immutable
abstract class StudentEvent extends Equatable {
  const StudentEvent();
  @override
  List<Object> get props => [];
}

class CreateStudentEvent extends StudentEvent {
  final String firstName;
  final String lastName;

  CreateStudentEvent({
    @required this.firstName,
    @required this.lastName,
  });
}

class UpdateStudentEvent extends StudentEvent {
  final String firstName;
  final String lastName;

  final Student student;

  UpdateStudentEvent({
    this.firstName,
    this.lastName,
    @required this.student,
  });
}

class DeleteStudentEvent extends StudentEvent {
  final Student student;

  DeleteStudentEvent({@required this.student});
}

class GetStudentsEvent extends StudentEvent {}
