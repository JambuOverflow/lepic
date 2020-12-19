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
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return Constants.choices.map((String choice) {
                return PopupMenuItem<String>(
                  child: Text(choice),
                  value: choice,
                );
              }).toList();
            },
          ),
        ],
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

class Constants {
  static const String assign = 'Assign student';
  static const String edit = 'Edit student';
  static const String remove = 'Remove student';

  static const List<String> choices = <String>[
    assign,
    edit,
    remove,
  ];
}

void choiceAction(String choice) {
  switch (choice) {
    case Constants.assign:
      print('add student');
      break;
    case Constants.edit:
      print('edit student');
      break;
    case Constants.remove:
      print('remove this student');
      break;
    default:
      print('error');
  }
}
