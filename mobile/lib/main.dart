import 'package:flutter/material.dart';
import 'package:moor/moor.dart';

import 'features/user_management/presentation/pages/pages.dart';
import 'features/user_management/data/models/user_model.dart';
import 'features/user_management/presentation/pages/login_page.dart';


void main() {
  // This setting overrides the default serializer to our custom one
  moorRuntimeOptions.defaultSerializer = UserSerializer();

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
