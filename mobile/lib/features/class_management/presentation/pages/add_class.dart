import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/classroom.dart';
import '../bloc/class_bloc.dart';

class AddClass extends StatefulWidget {
  @override
  _AddClassState createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _gradeController = TextEditingController();
  TextEditingController _tutorIdController = TextEditingController();
  TextEditingController _levelSelected = TextEditingController();
  ClassroomBloc _classBloc;

  @override
  Widget build(BuildContext context) {
    //WELP ME PLIS
    _classBloc = BlocProvider.of<ClassroomBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Create class'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView(children: <Widget>[
          ClasroomForm(
            label: 'Class name',
            textController: _nameController,
          ),
          ClasroomForm(
            label: 'Grade',
            textController: _gradeController,
            numeric: true,
          ),
          ClasroomForm(
            label: 'Tutor',
            textController: _tutorIdController,
            numeric: true,
          ),
          ClasroomForm(
            label: 'Id - for tests',
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
                    'Create class',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    print("creating class");
                    //print(_classBloc.value);                     _
                    _classBloc.add(CreateNewClassroomEvent(
                      int.tryParse(_tutorIdController.text),
                      int.tryParse(_levelSelected.text),
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

///aqui vai provavelmente precisar de um bloc listener também
//if class created -> navigator pop
//if operation_fails -> show error screen/pop up/snack bar
/*BlocListener <ClassBloc, ClassState>(
listener: (context, state) {
    if (state is Error) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
        ),
      );
    }
    else if(state is ClassCreated){
      Navigator.pop(context);
    };
  },
  child: blocbuilder
),*/

/*
 void _createClass(BuildContext context) {
    final String name = _nameController.text;
    final int grade = _gradeController.text as int;
    final int tutorId = _tutorIdController.text as int;
    final int id = 1;

    if (name != null && grade != null) {
      final createdClass = Classroom(
        tutorId: tutorId,
        grade: grade,
        name: name,
      );
]      _classBloc.add(CreateNewClassEvent(tutorId, id, grade, name));
      N//avigator.pop(context, createdClass);
    }//
  }
*/
//
