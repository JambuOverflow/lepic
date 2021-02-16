import 'package:flutter/material.dart';

class AppBarBottomTextTitle extends PreferredSize {
  final String title;

  const AppBarBottomTextTitle({Key key, @required this.title});

  @override
  Size get preferredSize => Size.fromHeight(32);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.headline6.fontSize,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}
