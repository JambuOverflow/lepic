part of 'class_bloc.dart';

abstract class ClassEvent extends Equatable {
  const ClassEvent();

  @override
  List<Object> get props => [];
}

class _ClassManagementEvent extends ClassEvent {
  final int tutorId;
  final int id;
  final int grade;
  final String name;

  _ClassManagementEvent(
    this.tutorId,
    this.id,
    this.grade,
    this.name,
  );
}

class CreateNewClassEvent extends _ClassManagementEvent {
  CreateNewClassEvent(
    int tutorId,
    int id,
    int grade,
    String name,
  ) : super(tutorId, id, grade, name);
}

class UpdateClassEvent extends _ClassManagementEvent {
  UpdateClassEvent(
    int tutorId,
    int id,
    int grade,
    String name,
  ) : super(tutorId, id, grade, name);
}

class DeleteClassEvent extends _ClassManagementEvent {
  DeleteClassEvent(
    int tutorId,
    int id,
    int grade,
    String name,
  ) : super(tutorId, id, grade, name);
}

class GetClassEvent extends ClassEvent {
  final int tutorId;
  final String name;

  GetClassEvent(
    this.tutorId,
    this.name,
  );
}
