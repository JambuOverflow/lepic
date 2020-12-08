import 'package:flutter/material.dart';
import 'features/user_management/presentation/pages/pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lepic',
      home: LoginPage(),
      // Routes are temporary for testing pages, replace it by bloc
      routes: {
        '/guest': (context) => GuestLoginPage(),
        '/signup': (context) => SignupPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
