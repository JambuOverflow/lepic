import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/user_management/presentation/bloc/bloc/user_bloc.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart';

import 'features/user_management/data/models/user_model.dart';
import 'features/user_management/presentation/route_generator.dart';

void main() {
  // This setting overrides the default serializer to our custom one
  moorRuntimeOptions.defaultSerializer = UserSerializer();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(
      create: (context) => UserBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.blue[900],
          accentColor: Colors.blueAccent[700],
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.blue[900],
            textTheme: ButtonTextTheme.primary,
          ),
        ),
        initialRoute: '/login',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
