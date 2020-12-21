import 'package:flutter/material.dart';

class SignupButton extends StatelessWidget {
  const SignupButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        'Sign up',
        style: TextStyle(fontSize: 16),
      ),
      onPressed: () => Navigator.of(context).pushNamed('/signup'),
    );
  }
}
