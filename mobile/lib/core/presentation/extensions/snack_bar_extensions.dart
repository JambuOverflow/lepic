import 'package:flutter/material.dart';

extension FailureSnackBar on ScaffoldState {
  void showServerFailureSnackBar(context) {
    print(context.widget);
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Could not reach server'),
      ),
    );
  }
}
