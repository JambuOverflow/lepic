import 'package:flutter/material.dart';

class InvalidCredentialsWarning extends StatelessWidget {
  final _visible;

  const InvalidCredentialsWarning({
    Key key,
    bool isVisible,
  })  : this._visible = isVisible,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).errorColor;

    return AnimatedOpacity(
      duration: Duration(milliseconds: 175),
      opacity: _visible ? 1 : 0,
      child: Row(
        children: [
          Icon(Icons.error, color: color),
          SizedBox(width: 8),
          Text('Invalid credentials', style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
