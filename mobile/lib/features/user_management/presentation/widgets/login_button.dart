import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/user_bloc.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is LoggedIn) {
          Navigator.of(context).pushNamed(
            '/home',
          );
        } else if (state is Error) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        return Container(
          height: 80,
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: RaisedButton(
            child: Text(
              'Login',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () {
              throw UnimplementedError();
            },
          ),
        );
      },
    );
  }
}
