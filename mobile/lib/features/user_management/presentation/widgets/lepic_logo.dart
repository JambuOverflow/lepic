import 'package:flutter/material.dart';

class LepicLogo extends StatelessWidget {
  const LepicLogo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/JambuOverflow.png",
      width: 100,
      height: 100,
    );
  }
}
