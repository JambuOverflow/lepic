import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile/features/class_management/domain/use_cases/get_classrooms_use_case.dart';

import '../../../../core/network/response.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/classroom.dart';
import '../../domain/use_cases/classroom_params.dart';
import '../../domain/use_cases/create_classroom_use_case.dart';
import '../../domain/use_cases/delete_classroom_use_case.dart';
import '../../domain/use_cases/update_classroom_use_case.dart';

part 'class_event.dart';
part 'class_state.dart';

class ClassroomBloc extends Bloc<ClassroomEvent, ClassroomState> {
  final CreateClassroom createNewClassroom;
  final DeleteClassroom deleteClassroom;
  final UpdateClassroom updateClassroom;
  final GetClassrooms getClassroom;

  ClassroomBloc({
    @required this.updateClassroom,
    @required this.deleteClassroom,
    @required this.createNewClassroom,
    @required this.getClassroom,
  }) : super(GetClassroom());

  @override
  Stream<ClassroomState> mapEventToState(
    ClassroomEvent event,
  ) async* {
    if (event is CreateNewClassroomEvent)
      yield* _createClassStates(event);
    else if (event is DeleteClassroomEvent)
      yield* _deleteClassStates(event);
    else if (event is UpdateClassroomEvent)
      yield* _updateStates(event);
    else if (event is GetClassroomEvent) yield* _getClassesStates(event);
  }

  Stream<ClassroomState> _updateStates(UpdateClassroomEvent event) async* {
    yield UpdatingClassroom();

    final classroom = _createClassEntityFromEvent(event);

    final failureOrResponse =
        await updateClassroom(ClassroomParams(classroom: classroom));

    yield failureOrResponse.fold(
      (failure) => Error(message: _mapFailureToMessage(ServerFailure())),
      (response) => ClassroomUpdated(),
    );
  }

  Stream<ClassroomState> _getClassesStates(GetClassroomEvent event) async* {
    yield GetClassroom();

    final classroom = Classroom(
      tutorId: event.tutorId,
      name: event.name,
    );

    final failureOrResponse =
        await deleteClassroom(ClassroomParams(classroom: classroom));

    yield failureOrResponse.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (response) => GetClassroom(),
    );
  }

  Stream<ClassroomState> _createClassStates(
      CreateNewClassroomEvent event) async* {
    yield CreatingClassroom();

    final classroom = _createClassEntityFromEvent(event);

    final failureOrResponse =
        await createNewClassroom(ClassroomParams(classroom: classroom));

    yield failureOrResponse.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (response) => ClassroomCreated(response: response),
    );
  }

  Stream<ClassroomState> _deleteClassStates(DeleteClassroomEvent event) async* {
    yield DeletingClassroom();

    final classroom = Classroom(
      id: event.id,
    );
    final failureOrResponse =
        await deleteClassroom(ClassroomParams(classroom: classroom));

    yield failureOrResponse.fold(
      (failure) => Error(message: _mapFailureToMessage(ServerFailure())),
      (response) => ClassroomDeleted(),
    );
  }

  Classroom _createClassEntityFromEvent(ClassroomEvent event) {
    if (event is _ClassroomManagementEvent) {
      return Classroom(
        id: event.id,
        tutorId: event.tutorId,
        grade: event.grade,
        name: event.name,
      );
    }

    throw Exception('Cannot create class from event');
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Could not reach server';
      default:
        return 'Unexpected Error';
    }
  }
}

Classroom _createClassEntityFromEvent(ClassroomEvent event) {
  if (event is _ClassroomManagementEvent) {
    return Classroom(
      id: event.id,
      tutorId: event.tutorId,
      grade: event.grade,
      name: event.name,
    );
  }

  throw Exception('Cannot create user from event');
}

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return 'Could not reach server';
    default:
      return 'Unexpected Error';
  }
}
