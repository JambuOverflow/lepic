//This file defines all the routing logic so it won't be anywhere else in the code
import 'package:flutter/material.dart';
import 'package:mobile/features/class_management/presentation/pages/list_class.dart';
import 'package:mobile/features/student_management/presentation/pages/create_student_page.dart';
import 'package:mobile/features/student_management/presentation/pages/detail_student.dart';
import 'package:mobile/features/student_management/presentation/pages/list_student.dart';
import 'package:mobile/features/text_management/presentation/pages/list_text.dart';
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
      case '/list_students':
        return MaterialPageRoute(
          builder: (_) => ShowStudents(),
        );
      case '/list_classes':
        return MaterialPageRoute(
          builder: (_) => ShowClasses(),
        );
      case '/list_texts':
        return MaterialPageRoute(
          builder: (_) => ShowTexts(),
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
