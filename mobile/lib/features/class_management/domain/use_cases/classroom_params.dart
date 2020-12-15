import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';

class ClassroomParams extends Equatable {
  final Classroom classroom;

  ClassroomParams({@required this.classroom});

  @override
  List<Object> get props => [ClassroomParams];
}
