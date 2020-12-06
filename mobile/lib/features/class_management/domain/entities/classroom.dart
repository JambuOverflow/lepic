import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../../user_management/domain/entities/user.dart';

class Classroom extends Equatable {
  final User tutor;
  final UniqueKey id;
  final int grade;
  final String name;

  Classroom({@required this.tutor, @required this.grade, @required this.name})
      : id = UniqueKey();

  @override
  List<Object> get props => [tutor, grade];
}
