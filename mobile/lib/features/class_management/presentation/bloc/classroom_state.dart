part of 'classroom_bloc.dart';

abstract class ClassroomState extends Equatable {
  const ClassroomState();

  @override
  List<Object> get props => [ClassroomState];
}

class DeletingClassroom extends ClassroomState {}

class ClassroomDeleted extends ClassroomState {}

class CreatingClassroom extends ClassroomState {}

class ClassroomCreated extends ClassroomState {
  final Classroom newClassroom;

  ClassroomCreated({@required this.newClassroom});

  @override
  List<Object> get props => [newClassroom];
}

class UpdatingClassroom extends ClassroomState {}

class ClassroomUpdated extends ClassroomState {
  final Classroom updatedClassroom;

  ClassroomUpdated({@required this.updatedClassroom});

  @override
  List<Object> get props => [updatedClassroom];
}

class GettingClassrooms extends ClassroomState {}

class ClassroomsGot extends ClassroomState {
  final List<Classroom> classrooms;

  ClassroomsGot({@required this.classrooms});

  @override
  List<Object> get props => [classrooms];
}

class Error extends ClassroomState {
  final String message;

  Error({@required this.message});
}
