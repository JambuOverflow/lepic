import 'package:flutter/material.dart';

enum MenuOption { Assign, Edit, Remove }

class ClassroomDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Class Details'),
        actions: <Widget>[
          PopupMenuButton<MenuOption>(
            onSelected: (MenuOption result) {
              if (result == MenuOption.Assign) {
                Navigator.of(context).pushNamed(
                  '/list_texts',
                );
              } else if (result == MenuOption.Edit) {
                Navigator.of(context).pushNamed(
                  '/update_class',
                );
              } else if (result == MenuOption.Remove) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('Are you sure you want to remove this class?'),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<MenuOption>>[
                PopupMenuItem(
                  child: Text('Assign student'),
                  value: MenuOption.Assign,
                ),
                PopupMenuItem(
                  child: Text('Edit class'),
                  value: MenuOption.Edit,
                ),
                PopupMenuItem(
                  child: Text('Remove class'),
                  value: MenuOption.Remove,
                ),
              ];
            },
          ),
        ],
      ),
    );
  }
}
