import 'package:flutter/material.dart';

class DoneFloatingActionButton extends StatelessWidget {
  const DoneFloatingActionButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.done_rounded),
      onPressed: () {},
      tooltip: 'Save changes',
    );
  }
}
