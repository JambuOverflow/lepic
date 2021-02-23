import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/features/text_correction/domain/entities/mistake.dart';

class Correction extends Equatable {
  final int textId;
  final int studentId;
  final int localId;
  final List<Mistake> mistakes;

  Correction({
    @required this.localId,
    @required this.textId,
    @required this.studentId,
    @required this.mistakes,
  });

  int get numberOfMistakes {
    return mistakes.length;
  }

  @override
  List<Object> get props => [textId, studentId, mistakes];
}
