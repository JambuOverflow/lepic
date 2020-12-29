import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/features/school_management/domain/entities/school.dart';

class SchoolParams extends Equatable {
  final School school;

  SchoolParams({@required this.school});

  @override
  List<Object> get props => [SchoolParams];
}
