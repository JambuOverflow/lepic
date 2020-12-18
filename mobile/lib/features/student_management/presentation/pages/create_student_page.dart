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
          TextForm(
            label: 'First name',
            textController: _firstnameController,
          ),
          TextForm(
            label: 'Last name',
            textController: _lastnameController,
          ),
          TextForm(
            label: 'id',
            textController: _idController,
            numeric: true,
          ),
          TextForm(
            label: 'Class id',
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

class TextForm extends StatefulWidget {
  final TextEditingController textController;
  final String label;
  final bool numeric;

  const TextForm({
    @required this.textController,
    @required this.label,
    this.numeric,
  });

  @override
  _TextFormState createState() => _TextFormState();
}

class _TextFormState extends State<TextForm> {
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
