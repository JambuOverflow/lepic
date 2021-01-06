import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/core/presentation/bloc/bottom_navigation_bloc.dart';
import 'package:mobile/features/student_management/presentation/bloc/student_bloc.dart';
import 'package:moor/moor.dart';

import 'core/presentation/pages/route_generator.dart';
import 'features/class_management/presentation/bloc/classroom_bloc.dart';
import 'features/user_management/data/models/user_model.dart';
import 'features/user_management/presentation/bloc/auth_bloc.dart';
import 'injection_container.dart';

const IS_IN_DEVELOPMENT = true;

void main() async {
  // This setting overrides the default serializer to our custom one
  moorRuntimeOptions.defaultSerializer = UserSerializer();
  WidgetsFlutterBinding.ensureInitialized();
  await setUpLocator();

  final authBloc = await GetIt.instance<AuthBloc>();
  authBloc.add(AppStartedEvent());

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<BottomNavigationBloc>(
            create: (_) => GetIt.instance<BottomNavigationBloc>()),
        BlocProvider<AuthBloc>(create: (_) => authBloc),
        BlocProvider<ClassroomBloc>(
            create: (_) => GetIt.instance<ClassroomBloc>()),
      ],
      child: MyApp(),
    ),
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
      initialRoute: BlocProvider.of<AuthBloc>(context).state.status ==
              AuthStatus.authenticated
          ? '/home'
          : '/login',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
