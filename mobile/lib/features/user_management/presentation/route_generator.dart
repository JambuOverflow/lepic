//This file defines all the routing logic so it won't be anywhere else in the code
import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'pages/guest.dart';
import 'pages/signup.dart';
import 'pages/home.dart';
import 'pages/update_user.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(
          builder: (_) => Login(),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
        );
      case '/signup':
        return MaterialPageRoute(
          builder: (_) => Signup(),
        );
      case '/guest':
        return MaterialPageRoute(
          builder: (_) => Guest(),
        );
      case '/update_user':
        return MaterialPageRoute(
          builder: (_) => UpdateUser(),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Error'),
          ),
          body: Center(
            child: Text('Page not Found'),
          ));
    });
  }
}
