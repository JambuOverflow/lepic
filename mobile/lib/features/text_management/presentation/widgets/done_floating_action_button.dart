import 'package:flutter/material.dart';

class DoneFloatingActionButton extends StatelessWidget {
  final Function onPressed;

  const DoneFloatingActionButton({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.done_rounded),
      onPressed: onPressed,
      tooltip: 'Save changes',
    );
  }
}
