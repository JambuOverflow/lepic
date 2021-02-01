import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Mistake extends Equatable {
  final int wordIndex;
  final String commentary;
  final int localId;

  Mistake({
    @required this.wordIndex,
    @required this.commentary,
    this.localId,
  });

  Mistake.highlighted({@required this.wordIndex, this.localId})
      : this.commentary = '';

  bool get hasCommentary => commentary.isNotEmpty;
  bool get isHighlighted => commentary.isEmpty;

  @override
  List<Object> get props => [wordIndex, commentary, localId];
}
