import 'package:flutter/material.dart';
import '../widgets/login_text_input.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(40.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/JambuOverflow.png",
              width: 100,
              height: 100,
            ),
            SizedBox(height: 80),
            LoginInput(text: 'Email'),
            SizedBox(height: 20),
            LoginInput(text: 'Password'),
            SizedBox(height: 20),
            RaisedButton(
              child: Text('Login'),
              onPressed: () {},
            ),
            SizedBox(height: 20),
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
    ));
  }
}

// TODO: Add BLOC Management
