import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/student.dart';
import '../bloc/student_bloc.dart';

class AddStudent extends StatefulWidget {
  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _idController = TextEditingController();
  TextEditingController _classroomIdController = TextEditingController();
  StudentBloc _studentBloc;

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
          StudentForm(
            label: 'First name',
            textController: _firstnameController,
          ),
          StudentForm(
            label: 'Last name',
            textController: _lastnameController,
          ),
          StudentForm(
            label: 'Classroom',
            textController: _classroomIdController,
            numeric: true,
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
                    'Create student',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    print("creating student");
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

class StudentForm extends StatefulWidget {
  final TextEditingController textController;
  final String label;
  final bool numeric;

  StudentForm({
    this.textController,
    this.label,
    this.numeric,
  });

  @override
  _StudentFormState createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
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
