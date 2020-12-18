part of 'student_bloc.dart';

abstract class StudentState extends Equatable {
  const StudentState();
  @override
  List<Object> get props => [StudentState];
}

class StudentNotLoaded extends StudentState {}

class DeletingStudent extends StudentState {}

class StudentDeleted extends StudentState {}

class CreatingStudent extends StudentState {}

class StudentCreated extends StudentState {
  final Student student;

  StudentCreated({@required this.student});
}

class UpdatingStudent extends StudentState {}

class StudentUpdated extends StudentState {
  final Student student;

  StudentUpdated({@required this.student});
}

class GettingStudents extends StudentState {}

class StudentGot extends StudentState {
  final List<Student> students;
  StudentGot({@required this.students});
}

class Error extends StudentState {
  final String message;

  Error({@required this.message});
}
