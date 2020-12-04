import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        // padding: EdgeInsets.all(40.0),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/JambuOverflow.png",
            width: 100,
            height: 100,
          ),
          SizedBox(height: 80),
          LoginInput(text: 'email'),
          SizedBox(height: 20),
          LoginInput(text: 'password'),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                child: Text('Guest Login'),
                onPressed: () {},
              ),
              SizedBox(width: 10),
              RaisedButton(
                child: Text('Sign Up'),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    ));
  }
}

// TODO: Add BLOC Management
// TODO: Refactor Custom widgets

class LoginInput extends StatelessWidget {
  final String text;
  const LoginInput({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: text,
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}
