import 'package:flutter/material.dart';

class MoreInfoDialog extends StatelessWidget {
  const MoreInfoDialog({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('More info'),
      buttonPadding: EdgeInsets.only(right: 15),
      contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 0),
      titlePadding: EdgeInsets.fromLTRB(15, 15, 15, 0),
      actions: <Widget>[
        FlatButton(
            child: Text('Close'), onPressed: () => Navigator.pop(context))
      ],
      content: Text(
        "The $title report is generated automatically by calculating measures related to the student's reading fluency.",
        textAlign: TextAlign.justify,
      ),
    );
  }
}
