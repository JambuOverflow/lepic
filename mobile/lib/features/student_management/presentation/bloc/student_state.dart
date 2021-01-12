part of 'student_bloc.dart';

abstract class StudentState extends Equatable {
  const StudentState();
  @override
  List<Object> get props => [StudentState];
}

class StudentsLoadInProgress extends StudentState {}

class StudentsLoaded extends StudentState {
  final List<Student> students;

  StudentsLoaded({@required this.students});

  @override
  List<Object> get props => [students];
}

class Error extends StudentState {
  final String message;

  Error({@required this.message});
}
