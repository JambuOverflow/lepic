import 'package:flutter/material.dart';
/* 
Widget _tab(List<Widget> children) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: children
              .map((w) => Container(child: w, padding: EdgeInsets.all(6.0)))
              .toList(),
        ),
      ),
    ],
  );
}

Widget _btn(String txt, VoidCallback onPressed) {
  return ButtonTheme(
    minWidth: 48.0,
    child: Container(
      width: 150,
      height: 45,
      child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          child: Text(txt),
          // color: Colors.pink[900],
          // textColor: Colors.white,
          onPressed: onPressed),
    ),
  );
}

Widget slider() {
  return Slider(
      // activeColor: Colors.black,
      // inactiveColor: Colors.pink,
      value: _position.inSeconds.toDouble(),
      min: 0.0,
      max: _duration.inSeconds.toDouble(),
      onChanged: (double value) {
        setState(() {
          seekToSecond(value.toInt());
          value = value;
        });
      });
}

Widget localAudio() {
  return _tab([
    _btn('Play', () => audioCache.play(localFilePath)),
    _btn('Pause', () => advancedPlayer.pause()),
    _btn('Stop', () => advancedPlayer.stop()),
    slider()
  ]);
}
 */
