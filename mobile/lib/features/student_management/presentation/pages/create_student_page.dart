import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/student.dart';
import '../bloc/student_bloc.dart';

class AddClass extends StatefulWidget {
  @override
  _AddClassState createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _idController = TextEditingController();
  TextEditingController _classroomIdController = TextEditingController();
  StudentBloc _studentBloc;
  int _levelSelected;
  final List<int> levels = [
    1,
    2,
    2,
    4,
  ];

  @override
  Widget build(BuildContext context) {
    //WELP ME PLIS
    _studentBloc = BlocProvider.of<StudentBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('New student'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView(children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _firstnameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'First name',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _classroomIdController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Class ID',
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
          BlocListener<StudentBloc, StudentState>(
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
            child: BlocBuilder<StudentBloc, StudentState>(
                builder: (context, state) {
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
                    _studentBloc.add(CreateNewStudentEvent(
                      _firstnameController.text,
                      _lastnameController.text,
                      _idController.text as int,
                      _classroomIdController.text as int,
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
