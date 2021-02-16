import 'package:flutter/material.dart';

class AssignmentContextualFloatingActionButton extends StatelessWidget {
  const AssignmentContextualFloatingActionButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {},
      label: Text('Add Recording'),
      icon: Icon(Icons.music_note),
    );
  }
}
