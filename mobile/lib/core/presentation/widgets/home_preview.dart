import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/user_management/domain/entities/user.dart';
import '../../../features/user_management/presentation/bloc/auth_bloc.dart';

class HomePreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = BlocProvider.of<AuthBloc>(context).state.user;
    return Center(
      child: Text(
        "Welcome, " +
            user.firstName.toUpperCase() +
            '\n\n' +
            'Nothing here... for now.',
        textAlign: TextAlign.center,
        style:
            TextStyle(fontSize: Theme.of(context).textTheme.headline6.fontSize),
      ),
    );
  }
}
