import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/user_management/presentation/bloc/auth_bloc.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        title: Text(
          'Account and Settings',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w300,
          ),
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: FakeAccountDetail(),
    );
  }
}

class FakeAccountDetail extends StatelessWidget {
  const FakeAccountDetail({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 128, vertical: 8),
        child: ListView(
          children: [
            RaisedButton(
              child: Text('Logout'),
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(UserLoggedOutEvent());
                Navigator.of(context).pushReplacementNamed('/login');
              },
            )
          ],
        ),
      ),
    );
  }
}
