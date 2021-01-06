import 'package:flutter/material.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';

class StudentDetailPage extends StatelessWidget {
  final Student student;

  const StudentDetailPage({Key key, this.student}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(student.firstName),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(student.lastName),
            Text(student.classroomId.toString()),
            Text(student.id.toString()),
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
