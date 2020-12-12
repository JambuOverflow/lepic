import 'package:flutter/material.dart';
import 'package:lepic_screen_test/models/class.dart';

class ClassDetailPage extends StatelessWidget {
  final SchoolClass _schoolClass;

  ClassDetailPage(this._schoolClass);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_schoolClass.className.toString()),
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
            Text(_schoolClass.level.toString()),
            Text(_schoolClass.schoolName.toString()),
            Text(_schoolClass.country.toString()),
            Text(_schoolClass.state.toString()),
            Text(_schoolClass.city.toString()),
            //Listar os alunos da turma também, só os nomes (não lembro agora se podia ou não ver os dados deles e editar)
          ],
        ),
      ),
    );
  }
}

//daqui pra baixo tá errado, isso não pode ficar fora
//https://api.flutter.dev/flutter/material/PopupMenuButton-class.html
//Tem que criar um estado, pois não dá pra trocar de tela como tá

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
    //devia ter passar um texto pra turma e adicionar aluno(ou ao menos poder adicionar alunos enquanto cria/edita a sala - vou botar na edição pelo memos)
  ];
}

void choiceAction(String choice) {
  switch (choice) {
    case Constants.assign:
      print('add student');
      break;
    case Constants.edit:
      print(
          'edit list(seria classe? a tela de editar classe tá organizada mas não dá pra chamar por aqui ainda)');
      break;
    case Constants.remove:
      print('remove this class(not on sprint)');
      break;
    default:
      print('error');
  }
}
