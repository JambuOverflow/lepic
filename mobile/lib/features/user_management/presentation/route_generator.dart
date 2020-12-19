//This file defines all the routing logic so it won't be anywhere else in the code
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/features/user_management/presentation/bloc/user_form_bloc.dart';
import 'package:mobile/features/user_management/presentation/pages/signup_success.dart';
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
          builder: (_) => BlocProvider(
            create: (_) => GetIt.instance<UserFormBloc>(),
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
