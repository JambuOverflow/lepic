import 'package:flutter/material.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';

class StudentDetailPage extends StatelessWidget {
  final Student _student;

  StudentDetailPage(this._student);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_student.firstName.toString()),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(_student.lastName.toString()),
            Text(_student.classroomId.toString()),
            Text(_student.id.toString()),
          ],
        ),
      ),
    );
  }
}

enum MenuOption { Assign, Edit, Remove }

class PopupMenuOption extends StatelessWidget {
  const PopupMenuOption({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuOption>(
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<MenuOption>>[
          PopupMenuItem(
            child: Text('Assign student'),
            value: MenuOption.Assign,
          ),
          PopupMenuItem(
            child: Text('Edit student'),
            value: MenuOption.Edit,
          ),
          PopupMenuItem(
            child: Text('Remove student'),
            value: MenuOption.Remove,
          ),
        ];
      },
    );
  }
}
