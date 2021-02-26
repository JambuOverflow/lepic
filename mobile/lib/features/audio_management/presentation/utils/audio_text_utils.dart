import 'package:flutter/foundation.dart';

class AudioTextUtils {
  static String formattedDuration({@required double durationInSeconds}) {
    if (durationInSeconds == null)
      return '--:--';
    else
      return _formatSeconds(durationInSeconds);
  }

  static String formattedPosition({@required double currentPosition}) {
    if (currentPosition == null)
      return '00:00';
    else
      return _formatSeconds(currentPosition);
  }

  static String _formatSeconds(double timeinSeconds) {
    final position = Duration(seconds: timeinSeconds.toInt());

    String twoDigits(int n) => n.toString().padLeft(2, "0");

    var minutes = twoDigits(position.inMinutes.remainder(60));
    var seconds = twoDigits((position.inSeconds.remainder(60)));

    return '$minutes:$seconds';
  }
}
