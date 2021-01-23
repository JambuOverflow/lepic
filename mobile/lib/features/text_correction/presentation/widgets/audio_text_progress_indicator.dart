import 'package:flutter/material.dart';

class AudioTextProgressIndicator extends StatelessWidget {
  const AudioTextProgressIndicator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '0:15',
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.left,
          ),
        ),
        Text(
          '1:10',
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}
