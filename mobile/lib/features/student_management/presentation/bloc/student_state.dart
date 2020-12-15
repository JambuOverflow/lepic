part of 'student_bloc.dart';

abstract class StudentState extends Equatable {
  @override
  List<Object> get props => [StudentState];
}

class StudentInitial extends StudentState {}

class DeletingStudent extends StudentState {}

class StudentDeleted extends StudentState {}

class CreatingStudent extends StudentState {}

class StudentCreated extends StudentState {
  final Response response;

  StudentCreated({@required this.response});
}

class UpdatingStudent extends StudentState {}

class StudentUpdated extends StudentState {}

class GetStudent extends StudentState {}

class Error extends StudentState {
  final String message;

  Error({@required this.message});
}
