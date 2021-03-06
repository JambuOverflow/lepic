import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Classroom extends Equatable {
  final int id;
  final int grade;
  final String name;
  final bool deleted;
  final DateTime lastUpdated;
  final DateTime clientLastUpdated;

  Classroom({
    @required this.grade,
    @required this.name,
    this.id,
    this.deleted,
    this.lastUpdated,
    this.clientLastUpdated,
  });

  @override
  List<Object> get props => [
        grade,
        name,
        id,
        deleted,
        lastUpdated,
        clientLastUpdated,
      ];
}
