import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class AudioEntity extends Equatable {
  final int localId;
  final String title;
  final int textId;
  final int studentId;
  final Uint8List data;
  final Duration audioDuration;

  AudioEntity({
    @required this.title,
    @required this.textId,
    @required this.studentId,
    @required this.data,
    @required this.audioDuration,
    this.localId,
  });

  ByteData get byteData => ByteData.view(data.buffer);

  Duration get getAudioDuration {
    return audioDuration;
  }

  @override
  List<Object> get props => [
        localId,
        title,
        textId,
        studentId,
      ];
}
