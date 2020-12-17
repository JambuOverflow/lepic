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

class ClassroomUpdated extends ClassroomState {}

class GetClassroom extends ClassroomState {}

class Error extends ClassroomState {
  final String message;

  Error({@required this.message});
}
