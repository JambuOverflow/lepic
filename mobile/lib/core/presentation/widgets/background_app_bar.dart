import 'package:flutter/material.dart';

class BackgroundAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final List<Widget> actions;

  BackgroundAppBar({this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: Theme.of(context).canvasColor,
      elevation: 0,
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
