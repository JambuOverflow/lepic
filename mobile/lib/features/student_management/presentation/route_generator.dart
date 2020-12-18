import 'package:flutter/material.dart';
import 'package:mobile/features/student_management/presentation/pages/list_student.dart';

// import 'pages/home_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(
          builder: (_) => ShowStudents(),
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
