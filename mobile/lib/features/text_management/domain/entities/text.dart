import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class MyText extends Equatable {
  final String title;
  final String body;
  final int localId;
  final int studentId;

  MyText({
    @required this.title,
    @required this.body,
    @required this.studentId,
    this.localId,
  });

  int get numberOfWords {
    return body.split(" ").length;
  }

  @override
  List<Object> get props => [title, body, localId, studentId];
}
