import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/class_management/domain/use_cases/classroom_params.dart';
import 'package:mobile/features/student_management/domain/use_cases/create_student_use_case.dart';
import 'package:mobile/features/student_management/domain/use_cases/delete_student_use_case.dart';
import 'package:mobile/features/student_management/domain/use_cases/get_students_use_case.dart';
import 'package:mobile/features/student_management/domain/use_cases/update_student_use_case.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/response.dart';
import '../../domain/entities/student.dart';
import '../../domain/use_cases/student_params.dart';

part 'student_event.dart';
part 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final CreateStudent createStudent;
  final GetStudents getStudents;
  final DeleteStudent deleteStudent;
  final UpdateStudent updateStudent;

  StudentBloc({
    @required this.createStudent,
    @required this.getStudents,
    @required this.deleteStudent,
    @required this.updateStudent,
  }) : super(StudentNotLoaded());

  @override
  Stream<StudentState> mapEventToState(
    StudentEvent event,
  ) async* {
    if (event is CreateNewStudentEvent)
      yield* _createNewStudentStates(event);
    else if (event is UpdateStudentEvent)
      yield* _updateStudentStates(event);
    else if (event is DeleteStudentEvent)
      yield* _deleteStudentStates(event);
    else if (event is GetStudentEvent) yield* _getStudentsStates(event);
  }

  Stream<StudentState> _createNewStudentStates(
      CreateNewStudentEvent event) async* {
    yield CreatingStudent();

    final student = _createStudentEntityFromEvent(event);

    final failureOrResponse =
        await createStudent(StudentParams(student: student));

    yield failureOrResponse.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (response) => StudentCreated(student: response));
  }

  Stream<StudentState> _updateStudentStates(UpdateStudentEvent event) async* {
    yield UpdatingStudent();

    final student = _createStudentEntityFromEvent(event);
    final failureOrResponse =
        await updateStudent(StudentParams(student: student));

    yield failureOrResponse.fold(
      (failure) => Error(message: _mapFailureToMessage(ServerFailure())),
      (response) => StudentUpdated(student: response),
    );
  }

  Stream<StudentState> _deleteStudentStates(DeleteStudentEvent event) async* {
    yield DeletingStudent();

    final student = Student(
      id: event.id,
    );
    final failureOrResponse =
        await deleteStudent(StudentParams(student: student));

    yield failureOrResponse.fold(
      (failure) => Error(message: _mapFailureToMessage(ServerFailure())),
      (response) => StudentDeleted(),
    );
  }

  Stream<StudentState> _getStudentsStates(GetStudentEvent event) async* {
    yield GettingStudents();

    final classroom = Classroom(
      id: event.classroomId,
    );

    final failureOrResponse =
        await getStudents(ClassroomParams(classroom: classroom));
    yield failureOrResponse.fold(
      (failure) => Error(message: _mapFailureToMessage(ServerFailure())),
      (response) => StudentGot(students: response),
    );
  }

  Student _createStudentEntityFromEvent(StudentEvent event) {
    if (event is _StudentManagementEvent) {
      return Student(
        firstName: event.firstName,
        lastName: event.lastName,
        id: event.id,
        classroomId: event.classroomId,
      );
    }
    throw Exception('Cannot create student from event');
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
