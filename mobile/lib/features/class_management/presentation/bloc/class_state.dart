part of 'class_bloc.dart';

abstract class ClassroomState extends Equatable {
  const ClassroomState();

  @override
  List<Object> get props => [ClassroomState];
}

class DeletingClassroom extends ClassroomState {}

class ClassroomDeleted extends ClassroomState {}

class CreatingClassroom extends ClassroomState {}

class ClassroomCreated extends ClassroomState {
  final Classroom response;

  ClassroomCreated({@required this.response});
}

class UpdatingClassroom extends ClassroomState {}

class ClassroomUpdated extends ClassroomState {
  final Classroom response;

  ClassroomUpdated({@required this.response});
}

class GettingClassroom extends ClassroomState {}

class ClassroomGot extends ClassroomState {
  final List<Classroom> classrooms;
  ClassroomGot({@required this.classrooms});
}

class Error extends ClassroomState {
  final String message;

  Error({@required this.message});
}
