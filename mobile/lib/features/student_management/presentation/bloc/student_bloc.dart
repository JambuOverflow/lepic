import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
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
  List<Student> students = const <Student>[];

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
  }) : super(StudentsLoadInProgress());

  @override
  Stream<StudentState> mapEventToState(
    StudentEvent event,
  ) async* {
    if (event is CreateStudentEvent)
      yield* _createNewStudentState(event);
    else if (event is UpdateStudentEvent)
      yield* _updateStudentState(event);
    else if (event is DeleteStudentEvent)
      yield* _deleteStudentState(event);
    else if (event is LoadStudentsEvent) yield* _getStudentsState();
  }

  Stream<StudentState> _createNewStudentState(CreateStudentEvent event) async* {
    final student = Student(
      firstName: event.firstName,
      lastName: event.lastName,
      classroomId: classroom.id,
    );

    final failureOrSucess =
        await createStudent(StudentParams(student: student));

    yield* _eitherLoadedOrErrorState(failureOrSucess);
  }

  Stream<StudentState> _eitherLoadedOrErrorState(
    Either<Failure, dynamic> failureOrSuccess,
  ) async* {
    yield* failureOrSuccess.fold(
      (failure) async* {
        yield Error(message: _mapFailureToMessage(failure));
      },
      (_) async* {
        yield* _loadAndReplaceClassrooms();
      },
    );
  }

  Stream<StudentState> _updateStudentState(UpdateStudentEvent event) async* {
    final updatedStudent = Student(
      firstName: event.firstName,
      lastName: event.lastName,
      id: event.oldStudent.id,
      classroomId: classroom.id,
    );

    final failureOrStudent =
        await updateStudent(StudentParams(student: updatedStudent));

    yield* _eitherLoadedOrErrorState(failureOrStudent);
  }

  Stream<StudentState> _deleteStudentState(DeleteStudentEvent event) async* {
    final failureOrSuccess =
        await deleteStudent(StudentParams(student: event.student));

    yield* failureOrSuccess.fold(
      (failure) async* {
        yield Error(message: _mapFailureToMessage(CacheFailure()));
      },
      (_) async* {
        yield* _loadAndReplaceClassrooms();
      },
    );
  }

  Stream<StudentState> _getStudentsState() async* {
    yield StudentsLoadInProgress();

    yield* _loadAndReplaceClassrooms();
  }

  Stream<StudentState> _loadAndReplaceClassrooms() async* {
    final failureOrClassrooms = await getStudents(
      ClassroomParams(classroom: classroom),
    );

    yield failureOrClassrooms.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (students) {
        this.students = students;

        return StudentsLoaded(students: students);
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
