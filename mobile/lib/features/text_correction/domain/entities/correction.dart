import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/features/text_correction/domain/entities/mistake.dart';

class Correction extends Equatable {
  final int audioId;
  final List<Mistake> mistakes;

  Correction({
    @required this.audioId,
    @required this.mistakes,
  });

  int get numberOfMistakes {
    return mistakes.length;
  }

  @override
  List<Object> get props => [audioId, mistakes];
}
