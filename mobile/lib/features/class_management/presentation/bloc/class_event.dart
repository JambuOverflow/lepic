part of 'class_bloc.dart';

abstract class ClassroomEvent extends Equatable {
  const ClassroomEvent();

  @override
  List<Object> get props => [];
}

class _ClassroomManagementEvent extends ClassroomEvent {
  final int tutorId;
  final int id;
  final int grade;
  final String name;

  _ClassroomManagementEvent(
    this.tutorId,
    this.id,
    this.grade,
    this.name,
  );
}

class CreateNewClassroomEvent extends _ClassroomManagementEvent {
  CreateNewClassroomEvent(
    int tutorId,
    int id,
    int grade,
    String name,
  ) : super(tutorId, id, grade, name);
}

class UpdateClassroomEvent extends _ClassroomManagementEvent {
  UpdateClassroomEvent(
    int tutorId,
    int id,
    int grade,
    String name,
  ) : super(tutorId, id, grade, name);
}

class DeleteClassroomEvent extends _ClassroomManagementEvent {
  DeleteClassroomEvent(
    int tutorId,
    int id,
    int grade,
    String name,
  ) : super(tutorId, id, grade, name);
}

class GetClassroomEvent extends ClassroomEvent {
  final int tutorId;
  final int id;
  final int grade;
  final String name;

  GetClassroomEvent(
    this.tutorId,
    this.id,
    this.grade,
    this.name,
  );
}
