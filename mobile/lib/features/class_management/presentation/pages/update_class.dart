import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/classroom.dart';
import '../bloc/class_bloc.dart';

class UpdateClass extends StatefulWidget {
  @override
  _UpdateClassState createState() => _UpdateClassState();
}

class _UpdateClassState extends State<UpdateClass> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _gradeController = TextEditingController();
  TextEditingController _tutorIdController = TextEditingController();
  TextEditingController _levelSelected = TextEditingController();
  ClassroomBloc _classBloc;

  @override
  Widget build(BuildContext context) {
    _classBloc = BlocProvider.of<ClassroomBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Update class'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView(children: <Widget>[
          ClasroomForm(
            label: 'Current Name',
            textController: _nameController,
          ),
          ClasroomForm(
            label: 'Current Grade',
            textController: _gradeController,
            numeric: true,
          ),
          ClasroomForm(
            label: 'Current Tutor',
            textController: _tutorIdController,
            numeric: true,
          ),
          ClasroomForm(
            //This does not make much sense to be together
            label: 'Current Id - for tests',
            textController: _levelSelected,
            numeric: true,
          ),
          BlocListener<ClassroomBloc, ClassroomState>(
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
            child: BlocBuilder<ClassroomBloc, ClassroomState>(
                builder: (context, state) {
              return Container(
                height: 80,
                padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
                child: RaisedButton(
                  child: Text(
                    'Update',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    print("Updating class");
                    _classBloc.add(//não devia ser update?
                        UpdateClassroomEvent(
                      //tutorId, id, grade, name
                      int.tryParse(_tutorIdController.text),
                      int.tryParse(_levelSelected.text), //era pra ser id
                      int.tryParse(_gradeController.text),
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

class ClasroomForm extends StatefulWidget {
  final TextEditingController textController;
  final String label;
  final bool numeric;

  ClasroomForm({
    this.textController,
    this.label,
    this.numeric,
  });

  @override
  _ClasroomFormState createState() => _ClasroomFormState();
}

class _ClasroomFormState extends State<ClasroomForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        controller: widget.textController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: widget.label,
        ),
        keyboardType:
            widget.numeric != null ? TextInputType.number : TextInputType.text,
      ),
    );
  }
}
