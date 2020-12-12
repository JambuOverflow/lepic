import 'package:flutter/material.dart';
import 'package:lepic_screen_test/screens/drawer_overlay.dart';
import 'package:lepic_screen_test/models/class.dart';

class UpdateClass extends StatefulWidget {
  @override
  _UpdateClassStatefulWidgetState createState() =>
      _UpdateClassStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _UpdateClassStatefulWidgetState extends State<UpdateClass> {
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: _scaffoldKey,
      appBar: AppBar(title: Text('Edit Class')),
      body: Text("Editing Class"),
      drawer: DrawerOverlay(),
    );
  }*/

  TextEditingController _nameController = TextEditingController();
  TextEditingController _schoolController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _stateController = TextEditingController();

  String _levelSelected;
  final List<String> levels = [
    "A1",
    "A2",
    "A3",
    "A4",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: _scaffoldKey,
      appBar: AppBar(title: Text('Edit Class')),
      //body: Text("Editing Class"),
      drawer: DrawerOverlay(),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Current Class name', //Fazer um código que pegue
                  //como argumento do texto o dado da turma, tem coisa do tipo
                  //no show class ao pegar valores aleatórios que foram colocados
                  //nos campos de criar classe.
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _schoolController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Current School name',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _countryController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Current Country',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _stateController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Current State',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Current City',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                hint: Text("Current level"),
                value: _levelSelected,
                onChanged: (newValue) {
                  setState(() {
                    _levelSelected = newValue;
                  });
                },
                items: levels.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              )),
            ),
            Container(
              //height: 80, // esses parâmetros estão dando overflow, vou deixar comentado por enquanto
              //padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text(
                      '+ Add Students',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      print("Added Students");
                      Navigator.of(context).pushNamed(
                        '/sixth', //Tá só criando um aluno, devia abrir um diálogo e perguntar se quer inserir por id ou criar um novo aluno
                        //se for por id, falta uma página ou pop up pra inserir a partir do id
                        //também não existe uma página ou lugar que mostre ainda o id dos alunos existentes na plataforma, professor teria que adivinhar
                        //apesar de criar sala estar na sprint - criar aluno e adicionar eles na sala me parece outra user story (ver de criar uma nova)
                      );
                    },
                  ),
                  RaisedButton(
                    child: Text(
                      'Save Changes',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      print("Saved Changes");
                      _createClass(context);
                      Navigator.of(context).pushNamed(
                        '/seventh',
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createClass(BuildContext context) {
    final String className = _nameController.text;
    final String classLevel = _levelSelected;
    final String schoolName = _schoolController.text;
    final String coutry = _countryController.text;
    final String state = _stateController.text;
    final String city = _cityController.text;
    if (className != null && classLevel != null) {
      final createdClass = SchoolClass(
        className,
        classLevel,
        city,
        coutry,
        schoolName,
        state,
      );
      Navigator.pop(context, createdClass);
    }
  }
}
