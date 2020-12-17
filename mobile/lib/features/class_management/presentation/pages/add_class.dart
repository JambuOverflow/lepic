import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import '../../domain/entities/classroom.dart';
import '../bloc/class_bloc.dart';

class AddClass extends StatefulWidget {
  @override
  _AddClassState createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _gradeController = TextEditingController();
  TextEditingController _tutorIdController = TextEditingController();
  ClassBloc _classBloc;
  int _levelSelected;
  final List<int> levels = [
    1,
    2,
    2,
    4,
  ];

  @override
  Widget build(BuildContext context) {
    _classBloc = BlocProvider.of<ClassBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('New class'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView(children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Class name',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _tutorIdController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Class tutor',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonHideUnderline(
                child: DropdownButton(
              hint: Text("Select class grade"),
              value: _levelSelected,
              onChanged: (newValue) {
                setState(() {
                  _levelSelected = newValue;
                });
              },
              items: levels.map<DropdownMenuItem<String>>((int value) {
                return DropdownMenuItem<String>(
                  value: value.toString(),
                  child: Text(value.toString()),
                );
              }).toList(),
            )),
          ),
          BlocListener<ClassBloc, ClassState>(
            listener: (context, state) {
              if (state is Error) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
              } else if (state is Error) {
                Navigator.pop(context);
              }
            },
            child:
                BlocBuilder<ClassBloc, ClassState>(builder: (context, state) {
              return Container(
                height: 80,
                padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
                child: RaisedButton(
                  child: Text(
                    'Create class',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    print("creating class");
                    //print(_classBloc.value);                     _
                    _classBloc.add(CreateNewClassEvent(
                      _tutorIdController.text as int,
                      //1,//ID
                      _levelSelected, //era pra ser ID aqui -ter ID é estranho pois a pessoa não deveria poder editar o ID da classe
                      _gradeController.text as int,
                      _nameController.text,
                    ));
                  },
                ),
              );
            }),
          ),
        ]),
      ),
    );
  }
}
