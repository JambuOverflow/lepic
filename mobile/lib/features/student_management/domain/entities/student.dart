import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Student extends Equatable {
  final String firstName;
  final String lastName;
  final int id;
  final int classroomId;

  Student({
    @required this.firstName,
    @required this.lastName,
    @required this.classroomId,
    this.id,
  });

  @override
  List<Object> get props => [firstName, lastName, id, classroomId];
}
