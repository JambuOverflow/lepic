import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';

class StudentParams extends Equatable {
  final Student student;

  StudentParams({@required this.student});

  @override
  List<Object> get props => [StudentParams];
}
