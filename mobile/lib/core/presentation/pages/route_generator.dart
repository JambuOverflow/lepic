import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../features/text_management/presentation/pages/text_editing_page.dart';
import '../../../features/class_management/presentation/pages/classroom_detail_page.dart';
import '../../../features/class_management/presentation/pages/classrooms_page.dart';
import '../../../features/class_management/presentation/pages/classroom_creation_page.dart';
import '../../../features/class_management/presentation/pages/classroom_update_page.dart';
import '../../../features/student_management/presentation/pages/create_student_page.dart';
import '../../../features/student_management/presentation/pages/students_page.dart';
import '../../../features/text_management/presentation/pages/texts_page.dart';
import '../../../features/user_management/presentation/bloc/login_form_bloc.dart';
import '../../../features/user_management/presentation/pages/guest.dart';
import '../../../features/user_management/presentation/bloc/signup_form_bloc.dart';
import '../../../features/user_management/presentation/pages/signup_success.dart';
import '../../../features/user_management/presentation/pages/login.dart';
import '../../../features/user_management/presentation/pages/signup.dart';
import '../../../features/user_management/presentation/pages/update_user.dart';
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
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/signup':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => GetIt.instance<SignupFormBloc>(),
            child: Signup(),
          ),
        );
      case '/guest':
        return MaterialPageRoute(builder: (_) => Guest());
      case '/update_user':
        return MaterialPageRoute(builder: (_) => UpdateUser());
      case '/signup_success':
        return MaterialPageRoute(builder: (_) => SignUpSuccess());
      case '/list_students':
        return MaterialPageRoute(builder: (_) => StudentsPage());
      case '/add_student':
        return MaterialPageRoute(builder: (_) => CreateStudentPage());
      case '/list_classes':
        return MaterialPageRoute(builder: (_) => ClassroomsPage());
      case '/add_class':
        return MaterialPageRoute(builder: (_) => ClassroomCreationPage());
      case '/list_texts':
        return MaterialPageRoute(builder: (_) => TextsPage());
      case '/add_text':
        return MaterialPageRoute(builder: (_) {
          final Map arguments = settings.arguments as Map;
          final text = arguments != null ? arguments['textToEdit'] : null;

          return TextEditingPage(textToEdit: text);
        });
      case '/detail_class':
        return MaterialPageRoute(builder: (_) => ClassroomDetailPage());

      case '/update_class':
        return MaterialPageRoute(builder: (_) => ClassroomUpdatePage());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: Text('Error')),
          body: Center(child: Text('Page not Found')),
        );
      },
    );
  }
}
