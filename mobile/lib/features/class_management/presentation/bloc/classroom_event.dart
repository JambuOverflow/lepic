part of 'classroom_bloc.dart';

abstract class ClassroomEvent extends Equatable {
  const ClassroomEvent();

  @override
  List<Object> get props => [];
}

class CreateClassroomEvent extends ClassroomEvent {
  final String grade;
  final String name;

  CreateClassroomEvent({@required this.grade, @required this.name});
}

class UpdateClassroomEvent extends ClassroomEvent {
  final Classroom classroom;
  final String grade;
  final String name;

  UpdateClassroomEvent({@required this.classroom, this.grade, this.name});
}

class DeleteClassroomEvent extends ClassroomEvent {
  final Classroom classroom;

  DeleteClassroomEvent({@required this.classroom});
}

class LoadClassroomsEvent extends ClassroomEvent {}
