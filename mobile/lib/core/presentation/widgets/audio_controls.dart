import 'package:flutter/material.dart';

class AudioControls extends StatelessWidget {
  const AudioControls({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            iconSize: 40,
            icon: Icon(Icons.replay_5),
            color: Colors.white,
            disabledColor: Colors.grey,
            onPressed: null,
          ),
          IconButton(
            iconSize: 40,
            icon: Icon(Icons.play_arrow),
            color: Colors.white,
            disabledColor: Colors.grey,
            onPressed: null,
          ),
          IconButton(
            iconSize: 40,
            icon: Icon(Icons.forward_5),
            color: Colors.white,
            disabledColor: Colors.grey,
            onPressed: null,
          ),
        ],
      ),
    );
  }
}
