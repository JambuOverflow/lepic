//Não tava previsto na sprint
import 'package:flutter/material.dart';
import 'package:lepic_screen_test/models/text.dart';

class TextDetailPage extends StatelessWidget {
  final MyText _myText;

  TextDetailPage(this._myText);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_myText.title.toString()),
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
            Text(_myText.level.toString()),
            Text(_myText.text.toString()),
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
  static const String edit = 'Edit class';
  static const String remove = 'Remove class';

  static const List<String> choices = <String>[
    edit,
    remove,
  ];
}

void choiceAction(String choice) {
  switch (choice) {
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
