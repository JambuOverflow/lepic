import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Audio extends Equatable {
  final int localId;
  final String title;
  final int textId;
  final int studentId;
  final Uint8List audioData;

  Audio({
    @required this.title,
    @required this.textId,
    @required this.studentId,
    @required this.audioData,
    this.localId,
  });

  @override
  List<Object> get props => [
        localId,
        title,
        textId,
        studentId,
      ];
}
