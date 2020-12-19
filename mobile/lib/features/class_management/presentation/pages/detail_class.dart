import 'package:flutter/material.dart';
import '../../domain/entities/classroom.dart';

enum MenuOption { Assign, Edit, Remove }

class ClassDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Class Details'), //Text(_schoolClass.name.toString()),
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
                  Navigator.of(context).pushNamed(
                    '/detail_class',
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
          ]),
    );
  }
}
