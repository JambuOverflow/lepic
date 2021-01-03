import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Correction extends Equatable {
  final Map<int, String> mistakes;
  final int textId;
  final int studentId;
  final int localId;

  Correction({
    @required this.textId,
    @required this.studentId,
    @required this.mistakes,
    this.localId,
  });

  @override
  List<Object> get props => [textId, studentId, mistakes, localId];
}
