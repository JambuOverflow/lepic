import 'package:flutter/material.dart';
import 'package:mobile/features/user_management/presentation/widgets/login_text_input.dart';

class SignupPage extends StatelessWidget {
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
            LoginInput(text: 'Name'),
            SizedBox(height: 20),
            LoginInput(text: 'Email'),
            SizedBox(height: 20),
            DropdownButton(
              value: 'Role',
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.black87),
              onChanged: (String newValue) {
                newValue = newValue;
              },
              items: <String>['Role', 'Student', 'Professor', 'Researcher']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
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
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
