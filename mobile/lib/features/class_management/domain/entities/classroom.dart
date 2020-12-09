import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../../user_management/domain/entities/user.dart';

class Classroom extends Equatable {
  final int tutorId;
  final int id;
  final int grade;
  final String name;

  Classroom(
      {@required this.tutorId,
      @required this.grade,
      @required this.name,
      @required this.id});

  @override
  List<Object> get props => [tutorId, grade, name, id];
}