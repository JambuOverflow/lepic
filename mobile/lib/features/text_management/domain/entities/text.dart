import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Text extends Equatable {
  final String title;
  final String body;
  final int localId;
  final int classId;

  Text(
      {@required this.title,
      @required this.body,
      this.localId,
      @required this.classId});

  @override
  List<Object> get props => [title, body, localId, classId];
}
