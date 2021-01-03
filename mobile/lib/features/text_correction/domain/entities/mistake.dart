import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Mistake extends Equatable {
  final String commentary;
  final int wordIndex;
  final int localId;
  final int textId;
  final int studentId;

  Mistake({
    @required this.textId,
    @required this.studentId,
    @required this.wordIndex,
    @required this.commentary,
    this.localId,
  });

  @override
  List<Object> get props => [textId, studentId, wordIndex, commentary, localId];
}
