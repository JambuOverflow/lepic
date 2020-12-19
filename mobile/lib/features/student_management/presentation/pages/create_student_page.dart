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

  @override
  Widget build(BuildContext context) {
    _studentBloc = BlocProvider.of<StudentBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('New student'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView(children: <Widget>[
          ClassFormWidget(context, _idController, _firstnameController,
              _lastnameController, _classroomIdController),
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

  Widget ClassFormWidget(
      BuildContext context,
      TextEditingController _idController,
      TextEditingController _firstnameController,
      TextEditingController _lastnameController,
      TextEditingController _classroomIdController) {
    return ListView(children: <Widget>[
      ClassForm(
        label: 'id',
        textController: _idController,
        numeric: true,
      ),
      ClassForm(
        label: 'First name',
        textController: _firstnameController,
      ),
      ClassForm(
        label: 'Last name',
        textController: _lastnameController,
      ),
      ClassForm(
        label: 'Classroom',
        textController: _classroomIdController,
        numeric: true,
      ),
    ]);
  }
}

class ClassForm extends StatefulWidget {
  final TextEditingController textController;
  final String label;
  final bool numeric;

  ClassForm({
    this.textController,
    this.label,
    this.numeric,
  });

  @override
  _ClassFormState createState() => _ClassFormState();
}

class _ClassFormState extends State<ClassForm> {
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
//}
}
