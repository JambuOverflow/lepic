part of 'student_bloc.dart';

abstract class StudentState extends Equatable {
  const StudentState();
  @override
  List<Object> get props => [StudentState];
}

class DeletingStudent extends StudentState {}

class StudentDeleted extends StudentState {}

class CreatingStudent extends StudentState {}

class StudentCreated extends StudentState {
  final Student student;

  StudentCreated({@required this.student});

  @override
  List<Object> get props => [student];
}

class UpdatingStudent extends StudentState {}

class StudentUpdated extends StudentState {
  final Student updatedStudent;

  StudentUpdated({@required this.updatedStudent});

  @override
  List<Object> get props => [updatedStudent];
}

class GettingStudents extends StudentState {}

class StudentsGot extends StudentState {
  final List<Student> students;

  StudentsGot({@required this.students});

  @override
  List<Object> get props => [students];
}

class Error extends StudentState {
  final String message;

  Error({@required this.message});
}
