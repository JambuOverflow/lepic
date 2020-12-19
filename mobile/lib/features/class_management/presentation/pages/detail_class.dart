import 'package:flutter/material.dart';
import '../../domain/entities/classroom.dart';

class ClassDetailPage extends StatelessWidget {
  //final Classroom _schoolClass;

  //ClassDetailPage(this._schoolClass);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Class Details'), //Text(_schoolClass.name.toString()),
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
            //Text(_schoolClass.grade.toString()),
            //Text(_schoolClass.tutorId.toString()),
            //Text(_schoolClass.id.toString()),
            Text('Class grade'),
            Text('Tutor ID'),
            Text('Class ID'),
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
            child: Text('Edit class'),
            value: MenuOption.Edit,
          ),
          PopupMenuItem(
            child: Text('Remove class'),
            value: MenuOption.Remove,
          ),
        ];
      },
    );
  }
}

class Constants {
  static const String assign = 'Assign Student';
  static const String edit = 'Edit class';
  static const String remove = 'Remove class';

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
      print('edit list');
      break;
    case Constants.remove:
      print('remove this class');
      break;
    default:
      print('error');
  }
}
