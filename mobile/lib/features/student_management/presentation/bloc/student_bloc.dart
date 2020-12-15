import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mobile/core/network/response.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/student_management/domain/use_cases/create_student_use_case.dart';
import 'package:mobile/features/student_management/domain/use_cases/delete_student_use_case.dart';
import 'package:mobile/features/student_management/domain/use_cases/get_students_use_case.dart';
import 'package:mobile/features/student_management/domain/use_cases/update_student_use_case.dart';

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
    // TODO: implement mapEventToState
  }
}
