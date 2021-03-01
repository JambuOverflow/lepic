import 'package:flutter/material.dart';

class Footnote extends StatelessWidget {
  const Footnote({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 10),
      alignment: Alignment.centerRight,
      child: Text(
        '* Generated automatically once the correction is uploaded',
        style: TextStyle(fontSize: 11.5, letterSpacing: -0.5),
      ),
    );
  }
}
