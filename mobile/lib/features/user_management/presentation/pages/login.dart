import 'package:flutter/material.dart';
import 'package:mobile/features/user_management/presentation/bloc/bloc/user_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  UserBloc _userBloc;
  @override
  Widget build(BuildContext context) {
    _userBloc = BlocProvider.of<UserBloc>(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                child: Text(
                  'Lepic',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'E-mail',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            BlocListener<UserBloc, UserState>(
              listener: (context, state) {
                if (state is LoggedIn) {
                  Navigator.of(context).pushNamed(
                    '/home',
                  );
                }
              },
              child:
                  BlocBuilder<UserBloc, UserState>(builder: (context, state) {
                return Container(
                  height: 80,
                  padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
                  child: RaisedButton(
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      print(nameController.text);
                      print(passwordController.text);
                      _userBloc.add(LoggingUserEvent(
                        nameController.text,
                        passwordController.text,
                      ));
                    },
                  ),
                );
              }),
            ),
            Container(
              height: 80,
              padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
              child: OutlineButton(
                child: Text(
                  'Login as guest',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  print("opening guest screen");
                  Navigator.of(context).pushNamed(
                    '/guest',
                  );
                },
              ),
            ),
            Container(
                padding: EdgeInsets.all(8.0),
                child: FlatButton(
                  child: Text(
                    'Sign up',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    print("Opening signup screen...");
                    Navigator.of(context).pushNamed(
                      '/signup',
                    );
                  },
                ))
          ],
        ),
      ),
    );
  }
  /*void submitLogin(BuildContext context, String name, String password){
    final
    _userBloc
  }*/
}
