import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile/core/use_cases/use_case.dart';
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

  List<Student> students = const <Student>[];

  StudentBloc({
    @required this.classroom,
    @required this.createStudent,
    @required this.getStudents,
    @required this.deleteStudent,
    @required this.updateStudent,
  }) : super(StudentsLoadInProgress());

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
    else if (event is LoadStudentsEvent) yield* _getStudentsStates(event);
  }

  Stream<StudentState> _createNewStudentStates(
      CreateNewStudentEvent event) async* {
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

  Stream<StudentState> _getStudentsStates(LoadStudentsEvent event) async* {
    yield StudentsLoadInProgress();

    yield* _loadAndReplaceStudents();
  }

  Stream<StudentState> _loadAndReplaceStudents() async* {
    final failureOrClassrooms =
        await getStudents(ClassroomParams(classroom: classroom));

    yield failureOrClassrooms.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (students) {
        this.students = students;

        return StudentsLoaded();
      },
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
