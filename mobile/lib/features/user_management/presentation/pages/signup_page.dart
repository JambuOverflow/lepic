import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(40.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            LepicLogo(),
            SizedBox(height: 80),
            LoginInput(text: 'Name'),
            SizedBox(height: 20),
            LoginInput(text: 'Email'),
            SizedBox(height: 20),
            RoleDropdownButton(),
            LoginInput(text: 'Password'),
            SizedBox(height: 20),
            LoginInput(text: 'Confirm Password'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  },
                ),
                SizedBox(width: 10),
                RaisedButton(
                  child: Text('Confirm'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
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
