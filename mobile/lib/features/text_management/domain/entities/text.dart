import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class MyText extends Equatable {
  final String title;
  final String body;
  final int localId;
  final int classId;

  MyText(
      {@required this.title,
      @required this.body,
      this.localId,
      @required this.classId});

  int get numberOfWords {
    return body.split(" ").length;
  }

  @override
  List<Object> get props => [title, body, localId, classId];
}
