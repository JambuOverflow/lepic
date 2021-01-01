import 'package:flutter/material.dart';

// This widget is a workaround of a known glitch when using Hero with a Text
// widget, presented in github.com/flutter/flutter/issues/30647 and
// github.com/flutter/flutter/issues/12463. Another solution is inserting some
// widget between Hero and Text (ex. Material). I think it's also possible to
// put it inside a StatelessWidget.

Widget flightShuttleBuilder(
  BuildContext flightContext,
  Animation<double> animation,
  HeroFlightDirection flightDirection,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  return DefaultTextStyle(
    style: DefaultTextStyle.of(toHeroContext).style,
    child: toHeroContext.widget,
  );
}
