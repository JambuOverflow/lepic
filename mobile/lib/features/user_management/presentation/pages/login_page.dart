import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

// To many SizedBox, refactoring/modularization is necessary
// The RaisedButtons widgets should also be extracted
// Another alternative (but causes bottom overflow, probably bc Padding()):
// https://stackoverflow.com/questions/51842787/flutter-space-evenly-in-column-does-not-work-as-expected
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              LepicLogo(),
              SizedBox(height: 50),
              LoginInput(text: 'Email'),
              SizedBox(height: 20),
              LoginInput(text: 'Password'),
              SizedBox(height: 20),
              RaisedButton(
                child: Text('Login'),
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    child: Text('Guest Login'),
                    onPressed: () {
                      Navigator.pushNamed(context, '/guest');
                    },
                  ),
                  SizedBox(width: 10),
                  RaisedButton(
                    child: Text('Sign Up'),
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
