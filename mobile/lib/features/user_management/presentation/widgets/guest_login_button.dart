import 'package:flutter/material.dart';

class GuestLoginButton extends StatelessWidget {
  const GuestLoginButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        'Login as guest',
        style: TextStyle(fontSize: 16),
      ),
      onPressed: () => Navigator.of(context).pushNamed('/guest'),
    );
  }
}
