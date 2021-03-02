import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class MyText extends Equatable {
  final String title;
  final String body;
  final int localId;
  final int studentId;
  final DateTime creationDate;

  MyText({
    @required this.title,
    @required this.body,
    @required this.studentId,
    @required this.creationDate,
    this.localId,
  });

  int get numberOfWords => splitted.length;

  List<String> get splitted => body
      .split(RegExp("\\s|\"\\n\"", multiLine: true))
      .where((element) => element != '')
      .toList();

  @override
  List<Object> get props => [title, body, localId, studentId, creationDate];
}
