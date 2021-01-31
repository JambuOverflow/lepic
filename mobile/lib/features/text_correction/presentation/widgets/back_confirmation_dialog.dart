import 'package:flutter/material.dart';

class BackConfirmationDialog extends StatelessWidget {
  const BackConfirmationDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Discard correction?"),
      content: Text("This action can't be undone!"),
      actions: [
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text('CANCEL'),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: Text('DISCARD'),
        ),
      ],
    );
  }
}
