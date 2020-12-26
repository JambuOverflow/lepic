import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/classroom_form_field.dart';

import '../bloc/classroom_bloc.dart';

class ClassroomCreationPage extends StatefulWidget {
  @override
  _ClassroomCreationPageState createState() => _ClassroomCreationPageState();
}

class _ClassroomCreationPageState extends State<ClassroomCreationPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _gradeController = TextEditingController();
  TextEditingController _tutorIdController = TextEditingController();
  TextEditingController idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create class'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView(children: <Widget>[
          ClasroomFormField(
            label: 'Class name',
            textController: _nameController,
          ),
          ClasroomFormField(
            label: 'Grade',
            textController: _gradeController,
            numeric: true,
          ),
          ClasroomFormField(
            label: 'Tutor',
            textController: _tutorIdController,
            numeric: true,
          ),
          ClasroomFormField(
            label: 'Id - for tests',
            textController: idController,
            numeric: true,
          ),
          BlocConsumer<ClassroomBloc, ClassroomState>(
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
            builder: (context, state) {
              return Container(
                height: 80,
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: RaisedButton(
                  child: Text(
                    'Create class',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {},
                ),
              );
            },
          ),
        ]),
      ),
    );
  }
}
