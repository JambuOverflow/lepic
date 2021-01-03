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
  }) : super(GettingStudents());

  @override
  Stream<StudentState> mapEventToState(
    StudentEvent event,
  ) async* {
    if (event is CreateStudentEvent)
      yield* _createNewStudentStates(event);
    else if (event is UpdateStudentEvent)
      yield* _updateStudentStates(event);
    else if (event is DeleteStudentEvent)
      yield* _deleteStudentStates(event);
    else if (event is GetStudentsEvent) yield* _getStudentsStates(event);
  }

  Stream<StudentState> _createNewStudentStates(
      CreateStudentEvent event) async* {
    yield CreatingStudent();

    final student = Student(
      firstName: event.firstName,
      lastName: event.lastName,
      classroomId: classroom.id,
    );

    final studentEither = await createStudent(StudentParams(student: student));

    yield studentEither.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (newStudent) => StudentCreated(student: newStudent),
    );
  }

  Stream<StudentState> _updateStudentStates(UpdateStudentEvent event) async* {
    yield UpdatingStudent();

    final failureOrStudent =
        await updateStudent(StudentParams(student: event.student));

    yield failureOrStudent.fold(
      (failure) => Error(message: _mapFailureToMessage(CacheFailure())),
      (student) => StudentUpdated(updatedStudent: student),
    );
  }

  Stream<StudentState> _deleteStudentStates(DeleteStudentEvent event) async* {
    yield DeletingStudent();

    final failureOrSuccess =
        await deleteStudent(StudentParams(student: event.student));

    yield failureOrSuccess.fold(
      (failure) => Error(message: _mapFailureToMessage(CacheFailure())),
      (_) => StudentDeleted(),
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

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Could not reach server';
      default:
        return 'Unexpected Error';
    }
  }
}
