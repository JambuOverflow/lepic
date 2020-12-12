//This file defines all the routing logic so it won't be anywhere else in the code
import 'package:flutter/material.dart';
import 'package:lepic_screen_test/screens/login.dart';
import 'package:lepic_screen_test/screens/home.dart';
import 'package:lepic_screen_test/screens/signup.dart';
import 'package:lepic_screen_test/screens/guest.dart';
import 'package:lepic_screen_test/screens/add_class.dart';
import 'package:lepic_screen_test/screens/add_student.dart';
import 'package:lepic_screen_test/screens/show_classes.dart';
import 'package:lepic_screen_test/screens/update_class.dart';
import 'package:lepic_screen_test/screens/update_user.dart';
//Não tem texto nessa user story
//import 'package:lepic_screen_test/screens/text_detail.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //Getting arguments passed in while calling Navigator.pushNamed
    switch (settings.name) {
      case '/': //caso o nome da rota comece com /
        return MaterialPageRoute(
          builder: (_) => Login(),
        ); //sla o que é esse _
      case '/second':
        // if (args is String) { //O problema era nesse if já que eu não estava passando argumento algum então sempre dava falso
        //making sure it's the proper type of data we specified on our page definition
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
        );
      //break;
      //return _errorRoute();
      case '/third':
        return MaterialPageRoute(
          builder: (_) => Signup(),
        );
      case '/fourth':
        return MaterialPageRoute(
          builder: (_) => Guest(),
        );
      case '/fifth':
        return MaterialPageRoute(
          builder: (_) => AddClass(),
        );
      case '/sixth':
        return MaterialPageRoute(
          builder: (_) => AddStudent(),
        );
      case '/seventh':
        return MaterialPageRoute(
          builder: (_) => ShowClasses(),
        );
      case '/eighth':
        return MaterialPageRoute(
          builder: (_) => UpdateClass(),
        );
      case '/nineth':
        return MaterialPageRoute(
          //Texto não tá nessa user story
          //builder: (_) => TextDetailPage(),
          builder: (_) => UpdateUser(),
        );
      default: //se não existir uma rota com esse nome, e.g. /third (uma outra página só de erro)
        throw Exception(
            'Invalid route: ${settings.name}'); //sai no terminal, mas omite a tela de error
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
