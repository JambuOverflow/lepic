import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/core/presentation/bloc/bottom_navigation_bloc.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/user_management/domain/use_cases/get_logged_in_user_use_case.dart';
import 'package:moor/moor.dart';

import 'core/presentation/pages/route_generator.dart';
import 'features/class_management/presentation/bloc/classroom_bloc.dart';
import 'features/user_management/data/models/user_model.dart';
import 'features/user_management/domain/entities/user.dart';
import 'features/user_management/presentation/bloc/auth_bloc.dart';
import 'injection_containers/injection_container.dart';
import 'core/data/database.dart';
import 'package:flutter/services.dart' show rootBundle;

const IS_IN_DEVELOPMENT = true;

void main() async {
  // This setting overrides the default serializer to our custom one
  moorRuntimeOptions.defaultSerializer = UserSerializer();
  WidgetsFlutterBinding.ensureInitialized();
  setUpServiceLocator();

  final Database database = GetIt.instance.get<Database>();

  final GetLoggedInUserCase getLoggedInUserCase =
      GetIt.instance.get<GetLoggedInUserCase>();
  final NoParams noParams = NoParams();
  final userOutput = await getLoggedInUserCase(noParams);
  User user;
  userOutput.fold((l) => null, (r) {
    user = r;
  });

  final ClassroomModelsCompanion classroom1 = ClassroomModelsCompanion(
      grade: Value(1),
      name: Value("A"),
      tutorId: Value(user.localId),
      deleted: Value(false),
      clientLastUpdated: Value(DateTime(2020)),
      lastUpdated: Value(DateTime(2020)));

  final ClassroomModelsCompanion classroom2 = ClassroomModelsCompanion(
      grade: Value(1),
      name: Value("B"),
      deleted: Value(false),
      tutorId: Value(user.localId),
      clientLastUpdated: Value(DateTime(2020)),
      lastUpdated: Value(DateTime(2020)));

  final ClassroomModelsCompanion classroom3 = ClassroomModelsCompanion(
      grade: Value(2),
      name: Value("A"),
      deleted: Value(false),
      tutorId: Value(user.localId),
      clientLastUpdated: Value(DateTime(2020)),
      lastUpdated: Value(DateTime(2020)));

  final StudentModelsCompanion student1 = StudentModelsCompanion(
    firstName: Value("Paul"),
    lastName: Value("Philips"),
    classroomId: Value(1),
  );

  final StudentModelsCompanion student2 = StudentModelsCompanion(
    firstName: Value("Vanessa"),
    lastName: Value("Isabel"),
    classroomId: Value(1),
  );

  final StudentModelsCompanion student3 = StudentModelsCompanion(
    firstName: Value("Victor"),
    lastName: Value("Singer"),
    classroomId: Value(2),
  );


  Future<String> loadAsset(String name) async {
    return await rootBundle.loadString(name);
  }

  final String pot = await loadAsset('assets/texts/pot.txt');
  final String fox = await loadAsset('assets/texts/fox.txt');
  final String lionShare = await loadAsset('assets/texts/lion_share.txt');
  final String ant = await loadAsset('assets/texts/ant_and_grasshopper.txt');
  final String turtle = await loadAsset('assets/texts/turtle.txt');


  final String title1 = "The Earthen Pot and The Brass Pot";
  final TextModelsCompanion text1 = TextModelsCompanion(
    title: Value(title1),
    tutorId: Value(user.localId),
    body: Value(pot),
    studentId: Value(1),
    creationDate: Value(DateTime(2021, 1, 1)),
  );

  final TextModelsCompanion text2 = TextModelsCompanion(
    title: Value(title1),
    tutorId: Value(user.localId),
    body: Value(pot),
    studentId: Value(2),
    creationDate: Value(DateTime(2021, 1, 1)),
  );

  final String title2 = "The Fox and The Grapes";
  final TextModelsCompanion text3 = TextModelsCompanion(
    title: Value(title2),
    tutorId: Value(user.localId),
    body: Value(fox),
    studentId: Value(1),
    creationDate: Value(DateTime(2021, 1, 2)),
  );

  final TextModelsCompanion text4 = TextModelsCompanion(
    title: Value(title2),
    tutorId: Value(user.localId),
    body: Value(fox),
    studentId: Value(2),
    creationDate: Value(DateTime(2021, 1, 2)),
  );

  final String title3 = "The Lion's Share";
  final TextModelsCompanion text5 = TextModelsCompanion(
    title: Value(title3),
    tutorId: Value(user.localId),
    body: Value(lionShare),
    studentId: Value(1),
    creationDate: Value(DateTime(2021, 1, 3)),
  );

  final TextModelsCompanion text6 = TextModelsCompanion(
    title: Value(title3),
    tutorId: Value(user.localId),
    body: Value(lionShare),
    studentId: Value(2),
    creationDate: Value(DateTime(2021, 1, 3)),
  );

  final String title4 = "The Ant and the Grasshopper";
  final TextModelsCompanion text7 = TextModelsCompanion(
    title: Value(title4),
    tutorId: Value(user.localId),
    body: Value(ant),
    studentId: Value(1),
    creationDate: Value(DateTime(2021, 1, 4)),
  );

  final TextModelsCompanion text8 = TextModelsCompanion(
    title: Value(title4),
    tutorId: Value(user.localId),
    body: Value(ant),
    studentId: Value(2),
    creationDate: Value(DateTime(2021, 1, 4)),
  );

  final String title5 = "Tortoise and The Hare";
  final TextModelsCompanion text9 = TextModelsCompanion(
    title: Value(title5),
    tutorId: Value(user.localId),
    body: Value(turtle),
    studentId: Value(1),
    creationDate: Value(DateTime(2021, 1, 5)),
  );

  final TextModelsCompanion text10 = TextModelsCompanion(
    title: Value(title5),
    tutorId: Value(user.localId),
    body: Value(turtle),
    studentId: Value(2),
    creationDate: Value(DateTime(2021, 1, 5)),
  );

  await database.insertClassroom(classroom1);
  await database.insertClassroom(classroom3);
  await database.insertClassroom(classroom2);
  await database.insertStudent(student1);
  await database.insertStudent(student2);
  await database.insertStudent(student3);
  await database.insertText(text1);
  await database.insertText(text2);
  await database.insertText(text3);
  await database.insertText(text4);
  await database.insertText(text5);
  await database.insertText(text6);
  await database.insertText(text7);
  await database.insertText(text8);
  await database.insertText(text9);
  await database.insertText(text10);

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
          ? 'home'
          : 'login',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
