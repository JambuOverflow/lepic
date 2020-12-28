import 'package:flutter/material.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';

class TextDetailPage extends StatelessWidget {
  final MyText _text;

  TextDetailPage(this._text);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_text.title.toString()),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return Constants.choices.map(
                (String choice) {
                  return PopupMenuItem<String>(
                    child: Text(choice),
                    value: choice,
                  );
                },
              ).toList();
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(_text.body.toString()),
            Text(_text.classId.toString()),
            Text(_text.localId.toString()),
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
            child: Text('Assign text'),
            value: MenuOption.Assign,
          ),
          PopupMenuItem(
            child: Text('Edit text'),
            value: MenuOption.Edit,
          ),
          PopupMenuItem(
            child: Text('Remove text'),
            value: MenuOption.Remove,
          ),
        ];
      },
    );
  }
}

class Constants {
  static const String assign = 'Assign text';
  static const String edit = 'Edit text';
  static const String remove = 'Remove text';

  static const List<String> choices = <String>[
    assign,
    edit,
    remove,
  ];
}

void choiceAction(String choice) {
  switch (choice) {
    case Constants.assign:
      print('add text');
      break;
    case Constants.edit:
      print('edit text');
      break;
    case Constants.remove:
      print('remove this text');
      break;
    default:
      print('error');
  }
}
