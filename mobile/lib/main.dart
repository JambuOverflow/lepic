import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/features/student_management/presentation/bloc/student_bloc.dart';
import 'package:mobile/features/text_management/presentation/bloc/text_bloc.dart';
import 'package:mobile/features/user_management/presentation/bloc/user_bloc.dart';
import 'package:moor/moor.dart';


import 'core/data/serializer.dart';
import 'core/presentation/pages/route_generator.dart';
import 'features/class_management/presentation/bloc/classroom_bloc.dart';
import 'features/user_management/data/models/user_model.dart';
import 'injection_container.dart';

const IS_IN_DEVELOPMENT = true;

void main() async {
  // This setting overrides the default serializer to our custom one
  moorRuntimeOptions.defaultSerializer = Serializer();
  WidgetsFlutterBinding.ensureInitialized();
  await setUpLocator();

  runApp(
    MultiBlocProvider(providers: [
      BlocProvider<UserBloc>(create: (_) => GetIt.instance<UserBloc>()),
      BlocProvider<ClassroomBloc>(
          create: (_) => GetIt.instance<ClassroomBloc>()),
      BlocProvider<StudentBloc>(create: (_) => GetIt.instance<StudentBloc>()),
      BlocProvider<TextBloc>(create: (_) => GetIt.instance<TextBloc>()),
    ], child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
