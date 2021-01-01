import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile/features/user_management/domain/use_cases/user_params.dart';

import '../../domain/use_cases/get_classrooms_use_case.dart';
import '../../../user_management/presentation/bloc/auth_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/classroom.dart';
import '../../domain/use_cases/classroom_params.dart';
import '../../domain/use_cases/create_classroom_use_case.dart';
import '../../domain/use_cases/delete_classroom_use_case.dart';
import '../../domain/use_cases/update_classroom_use_case.dart';
import '../../../../core/utils/input_converter.dart';

part 'classroom_event.dart';
part 'classroom_state.dart';

class ClassroomBloc extends Bloc<ClassroomEvent, ClassroomState> {
  final AuthBloc authBloc;

  final InputConverter inputConverter;

  final CreateClassroom createNewClassroom;
  final DeleteClassroom deleteClassroom;
  final UpdateClassroom updateClassroom;
  final GetClassrooms getClassrooms;

  ClassroomBloc({
    @required this.authBloc,
    @required this.inputConverter,
    @required this.updateClassroom,
    @required this.deleteClassroom,
    @required this.createNewClassroom,
    @required this.getClassrooms,
  }) : super(GettingClassrooms());

  @override
  Stream<ClassroomState> mapEventToState(
    ClassroomEvent event,
  ) async* {
    if (authBloc.state.status != AuthStatus.authenticated)
      yield Error(message: 'User not authenticated');
    else if (event is CreateClassroomEvent)
      yield* _createClassStates(event);
    else if (event is DeleteClassroomEvent)
      yield* _deleteClassStates(event);
    else if (event is UpdateClassroomEvent)
      yield* _updateStates(event);
    else if (event is GetClassroomsEvent) yield* _getClassesStates(event);
  }

  Stream<ClassroomState> _createClassStates(
    CreateClassroomEvent event,
  ) async* {
    yield CreatingClassroom();

    final inputEither = inputConverter.stringToUnsignedInteger(event.grade);

    yield* inputEither.fold(
      (failure) async* {
        yield Error(message: _mapFailureToMessage(failure));
      },
      (grade) async* {
        final loggedUser = authBloc.state.user;

        final classroom = Classroom(
          grade: grade,
          name: event.name,
        );

        yield* _eitherCreatedOrErrorState(classroom);
      },
    );
  }

  Stream<ClassroomState> _eitherCreatedOrErrorState(
    Classroom classroom,
  ) async* {
    final failureOrClassroom =
        await createNewClassroom(ClassroomParams(classroom: classroom));

    yield failureOrClassroom.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (response) => ClassroomCreated(newClassroom: response),
    );
  }

  Stream<ClassroomState> _deleteClassStates(DeleteClassroomEvent event) async* {
    yield DeletingClassroom();

    final failureOrSuccess =
        await deleteClassroom(ClassroomParams(classroom: event.classroom));

    yield failureOrSuccess.fold(
      (failure) => Error(message: _mapFailureToMessage(CacheFailure())),
      (_) => ClassroomDeleted(),
    );
  }

  Stream<ClassroomState> _updateStates(UpdateClassroomEvent event) async* {
    yield UpdatingClassroom();

    final failureOrClassroom =
        await updateClassroom(ClassroomParams(classroom: event.classroom));

    yield failureOrClassroom.fold(
      (failure) => Error(message: _mapFailureToMessage(CacheFailure())),
      (classroom) => ClassroomUpdated(updatedClassroom: classroom),
    );
  }

  Stream<ClassroomState> _getClassesStates(GetClassroomsEvent event) async* {
    yield GettingClassrooms();

    final loggedUser = authBloc.state.user;

    final failureOrClassrooms =
        await getClassrooms(UserParams(user: loggedUser));

    yield failureOrClassrooms.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (classrooms) => ClassroomsGot(classrooms: classrooms),
    );
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
