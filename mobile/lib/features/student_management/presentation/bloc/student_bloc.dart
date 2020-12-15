import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mobile/features/class_management/presentation/bloc/class_bloc.dart';
import 'package:mobile/features/student_management/domain/use_cases/delete_student_use_case.dart';

part 'student_event.dart';
part 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  StudentBloc() : super(StudentInitial());

  @override
  Stream<StudentState> mapEventToState(
    StudentEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
