import 'package:flutter/material.dart';

class SignUpSuccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    new Future.delayed(
      const Duration(seconds: 2),
      () => Navigator.of(context).pop(),
    );

    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: MediaQuery.of(context).size.width / 2.5,
            ),
            SizedBox(height: 16),
            Text(
              'Welcome to Lepic!',
              key: Key("welcomePage"),
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
              ),
            ),
          ],
        )),
      ),
    );
  }
}
