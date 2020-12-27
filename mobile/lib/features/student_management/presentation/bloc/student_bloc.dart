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
import '../../domain/entities/student.dart';
import '../../domain/use_cases/student_params.dart';

part 'student_event.dart';
part 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final Classroom classroom;
  final CreateStudent createStudent;
  final GetStudents getStudents;
  final DeleteStudent deleteStudent;
  final UpdateStudent updateStudent;

  StudentBloc({
    @required this.classroom,
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
    else if (event is GetStudentsEvent) yield* _getStudentsStates(event);
  }

  Stream<StudentState> _createNewStudentStates(
      CreateNewStudentEvent event) async* {
    yield CreatingStudent();

    final student = _createStudentEntityFromEvent(event);

    final studentEither = await createStudent(StudentParams(student: student));

    yield studentEither.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (newStudent) => StudentCreated(student: newStudent),
    );
  }

  Stream<StudentState> _updateStudentStates(UpdateStudentEvent event) async* {
    yield UpdatingStudent();

    final student = _createStudentEntityFromEvent(event);
    final studentEither = await updateStudent(StudentParams(student: student));

    yield studentEither.fold(
      (failure) => Error(message: _mapFailureToMessage(ServerFailure())),
      (updatedStudent) => StudentUpdated(student: updatedStudent),
    );
  }

  Stream<StudentState> _deleteStudentStates(DeleteStudentEvent event) async* {
    yield DeletingStudent();

    final student = Student(id: event.id);

    final deleteEither = await deleteStudent(StudentParams(student: student));

    yield deleteEither.fold(
      (failure) => Error(message: _mapFailureToMessage(ServerFailure())),
      (response) => StudentDeleted(),
    );
  }

  Stream<StudentState> _getStudentsStates(GetStudentsEvent event) async* {
    yield GettingStudents();

    final getEither = await getStudents(ClassroomParams(classroom: classroom));

    yield getEither.fold(
      (failure) => Error(message: _mapFailureToMessage(ServerFailure())),
      (students) => StudentsGot(students: students),
    );
  }

  Student _createStudentEntityFromEvent(StudentManagementEvent event) {
    return Student(
      firstName: event.firstName,
      lastName: event.lastName,
      classroomId: classroom.id,
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
