//This file defines all the routing logic so it won't be anywhere else in the code
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/features/class_management/presentation/pages/detail_class.dart';
import 'package:mobile/features/class_management/presentation/pages/classrooms_page.dart';
import 'package:mobile/features/class_management/presentation/pages/classroom_creation_page.dart';
import 'package:mobile/features/class_management/presentation/pages/update_class.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/student_management/presentation/bloc/student_bloc.dart';
import 'package:mobile/features/student_management/presentation/pages/create_student_page.dart';
import 'package:mobile/features/student_management/presentation/pages/detail_student.dart';
import 'package:mobile/features/student_management/presentation/pages/list_student.dart';
import 'package:mobile/features/text_management/presentation/pages/create_text.dart';
import 'package:mobile/features/text_management/presentation/pages/list_text.dart';
import 'package:mobile/features/user_management/presentation/bloc/login_form_bloc.dart';
import 'package:mobile/features/user_management/presentation/pages/guest.dart';

import 'package:mobile/features/user_management/presentation/bloc/signup_form_bloc.dart';
import 'package:mobile/features/user_management/presentation/pages/signup_success.dart';
import 'package:mobile/features/user_management/presentation/pages/login.dart';
import 'package:mobile/features/user_management/presentation/pages/signup.dart';
import 'package:mobile/features/user_management/presentation/pages/update_user.dart';
import 'home.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => GetIt.instance<LoginFormBloc>(),
            child: Login(),
          ),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
        );
      case '/signup':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => GetIt.instance<SignupFormBloc>(),
            child: Signup(),
          ),
        );
      case '/guest':
        return MaterialPageRoute(
          builder: (_) => Guest(),
        );
      case '/update_user':
        return MaterialPageRoute(
          builder: (_) => UpdateUser(),
        );
      case '/signup_success':
        return MaterialPageRoute(builder: (_) => SignUpSuccess());
      case '/list_students':
        return MaterialPageRoute(
          builder: (_) => ShowStudents(),
        );
      case '/add_student':
        return MaterialPageRoute(
          builder: (_) => AddStudent(),
        );
      case '/list_classes':
        return MaterialPageRoute(
          builder: (_) => ClassroomsPage(),
        );
      case '/add_class':
        return MaterialPageRoute(
          builder: (_) => ClassroomCreationPage(),
        );
      case '/list_texts':
        return MaterialPageRoute(
          builder: (_) => ShowTexts(),
        );
      case '/add_text':
        return MaterialPageRoute(
          builder: (_) => AddText(),
        );
      case '/detail_class':
        return MaterialPageRoute(
          builder: (_) =>
              ClassDetailPage(/*_schoolClass*/), //receives arguments
        );

      case '/update_class':
        return MaterialPageRoute(
          builder: (_) => UpdateClass(),
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
