import 'package:flutter/material.dart';

class EmptyListText extends StatelessWidget {
  final String text;
  final double fontSize;

  const EmptyListText(
    this.text, {
    this.fontSize = 12,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 80),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.grey,
            fontSize: fontSize,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
