import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class AudioEntity extends Equatable {
  final int localId;
  final String title;
  final int textId;
  final int studentId;
  final Uint8List audioData;

  AudioEntity({
    @required this.title,
    @required this.textId,
    @required this.studentId,
    @required this.audioData,
    this.localId,
  });

  Duration get audioDuration {
    return Duration(minutes: audioData.length);
  }

  @override
  List<Object> get props => [
        localId,
        title,
        textId,
        studentId,
      ];
}