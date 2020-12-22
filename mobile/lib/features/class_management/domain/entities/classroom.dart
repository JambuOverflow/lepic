import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Classroom extends Equatable {
  final int tutorId;
  final int id;
  final int grade;
  final String name;
  bool deleted = false;
  DateTime lastUpdated = DateTime(0);
  DateTime clientLastUpdated = DateTime(0);

  Classroom({
    @required this.tutorId,
    @required this.grade,
    @required this.name,
    this.id,
    this.deleted,
    this.lastUpdated,
    this.clientLastUpdated,
  });

  @override
  List<Object> get props => [
        tutorId,
        grade,
        name,
        id,
        deleted,
        lastUpdated,
        clientLastUpdated,
      ];
}
