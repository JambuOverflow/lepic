import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../entities/audio.dart';

class AudioParams extends Equatable {
  final AudioEntity audio;

  AudioParams({@required this.audio});

  @override
  List<Object> get props => [this.audio];
}
