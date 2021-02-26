import 'package:flutter/material.dart';

class BackgroundAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final double elevation;
  final List<Widget> actions;

  BackgroundAppBar({this.title, this.actions, this.elevation = 0});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: Theme.of(context).canvasColor,
      elevation: elevation,
      iconTheme: IconThemeData(color: theme.iconTheme.color),
      title: Text(
        title,
        style: TextStyle(color: theme.iconTheme.color),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50);
}
