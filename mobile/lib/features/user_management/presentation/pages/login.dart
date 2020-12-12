import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
            Container(
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
                  Navigator.of(context).pushNamed(
                    '/home',
                  );
                },
              ),
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
}
