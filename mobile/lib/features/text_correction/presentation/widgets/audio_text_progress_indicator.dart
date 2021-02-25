import 'package:flutter/material.dart';

class AudioTextProgressIndicator extends StatelessWidget {
  final String audioDuration;
  final String audioPosition;

  const AudioTextProgressIndicator({
    Key key,
    @required this.audioDuration,
    @required this.audioPosition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            audioPosition,
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.left,
          ),
        ),
        Text(
          audioDuration,
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}
