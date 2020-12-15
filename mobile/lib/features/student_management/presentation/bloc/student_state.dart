part of 'student_bloc.dart';

abstract class StudentState extends Equatable {
  @override
  List<Object> get props => [StudentState];
}

class StudentNotLoaded extends StudentState {}

class DeletingStudent extends StudentState {}

class StudentDeleted extends StudentState {
  final Response response;
  StudentDeleted({@required this.response});
}

class CreatingStudent extends StudentState {}

class StudentCreated extends StudentState {
  final Response response;

  StudentCreated({@required this.response});
}

class UpdatingStudent extends StudentState {}

class StudentUpdated extends StudentState {
  final Response response;

  StudentUpdated({@required this.response});
}

class GetStudent extends StudentState {
  final Student student;
  GetStudent({@required this.student});
}

class Error extends StudentState {
  final String message;

  Error({@required this.message});
}
