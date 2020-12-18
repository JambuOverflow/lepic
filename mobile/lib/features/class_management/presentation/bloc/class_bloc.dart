import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/network/response.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/classroom.dart';
import '../../domain/use_cases/classroom_params.dart';
import '../../domain/use_cases/create_classroom_use_case.dart';
import '../../domain/use_cases/delete_classroom_use_case.dart';
import '../../domain/use_cases/update_classroom_use_case.dart';

part 'class_event.dart';
part 'class_state.dart';

class ClassBloc extends Bloc<ClassEvent, ClassState> {
  final CreateClassroom createNewClass;
  final DeleteClassroom deleteClass;
  final UpdateClassroom updateClass;

  ClassBloc({
    @required this.updateClass,
    @required this.deleteClass,
    @required this.createNewClass,
  }) : super(GetClass());

  @override
  Stream<ClassState> mapEventToState(
    ClassEvent event,
  ) async* {
    if (event is CreateNewClassEvent)
      yield* _createClassStates(event);
    else if (event is DeleteClassEvent)
      yield* _deleteClassStates(event);
    else if (event is UpdateClassEvent)
      yield* _updateStates(event);
    else if (event is GetClassEvent) yield* _getClassesStates(event);
  }

  Stream<ClassState> _updateStates(UpdateClassEvent event) async* {
    yield UpdatingClass();

    final classroom = _createClassEntityFromEvent(event);

    final failureOrResponse =
        await updateClass(ClassroomParams(classroom: classroom));

    yield failureOrResponse.fold(
      (failure) => Error(message: _mapFailureToMessage(ServerFailure())),
      (response) => ClassUpdated(),
    );
  }

  Stream<ClassState> _getClassesStates(GetClassEvent event) async* {
    yield GetClass();

    final classroom = Classroom(
      tutorId: event.tutorId,
      name: event.name,
    );

    final failureOrResponse =
        await deleteClass(ClassroomParams(classroom: classroom));

    yield failureOrResponse.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (response) => GetClass(),
    );
  }

  Stream<ClassState> _createClassStates(CreateNewClassEvent event) async* {
    yield CreatingClass();

    final classroom = _createClassEntityFromEvent(event);

    final failureOrResponse =
        await createNewClass(ClassroomParams(classroom: classroom));

    yield failureOrResponse.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (response) => ClassCreated(response: null),
    );
  }

  Stream<ClassState> _deleteClassStates(DeleteClassEvent event) async* {
    yield DeletingClass();
  }

  Classroom _createClassEntityFromEvent(ClassEvent event) {
    if (event is _ClassManagementEvent) {
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
}

Classroom _createClassEntityFromEvent(ClassEvent event) {
  if (event is _ClassManagementEvent) {
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
