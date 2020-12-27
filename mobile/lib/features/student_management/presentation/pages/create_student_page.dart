import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/student_bloc.dart';

class AddStudent extends StatefulWidget {
  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();

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
        child: ListView(
          children: <Widget>[
            StudentFormWidget(
              firstNameController: _firstNameController,
              lastNameController: _lastNameController,
            ),
            BlocConsumer<StudentBloc, StudentState>(
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 16.0,
                  ),
                  child: RaisedButton(
                    child: Text(
                      'Create student',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      print("creating student");
                      // _studentBloc.add(
                      //   CreateNewStudentEvent(
                      //     _firstNameController.text,
                      //     _lastNameController.text,
                      //   ),
                      // );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class StudentFormWidget extends StatelessWidget {
  final TextEditingController _firstnameController;
  final TextEditingController _lastnameController;

  const StudentFormWidget({
    Key key,
    @required TextEditingController firstNameController,
    @required TextEditingController lastNameController,
  })  : this._firstnameController = firstNameController,
        this._lastnameController = lastNameController,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        StudentForm(
          label: 'First name',
          textController: _firstnameController,
        ),
        StudentForm(
          label: 'Last name',
          textController: _lastnameController,
        ),
      ],
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
