import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:mobile/features/user_management/presentation/bloc/auth_bloc.dart';

import '../widgets/drawer_overlay.dart';

class HomeScreen extends StatefulWidget {
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final User user = BlocProvider.of<AuthBloc>(context).state.user;

    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Text(
          "Welcome, " +
              user.firstName.toUpperCase() +
              '\n\n' +
              'Nothing here... for now.',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: Theme.of(context).textTheme.headline6.fontSize),
        ),
      ),
      drawer: DrawerOverlay(),
    );
  }
}
