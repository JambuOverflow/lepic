import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/presentation/widgets/basic_form.dart';
import '../bloc/student_bloc.dart';

class AddStudent extends StatefulWidget {
  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New student'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: BlocConsumer<StudentBloc, StudentState>(
          builder: (context, state) {
            return Column(
              children: <Widget>[
                BasicForm(
                  label: 'First name',
                  textController: _firstNameController,
                ),
                BasicForm(
                  label: 'Last name',
                  textController: _lastNameController,
                ),
                Container(
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
                    onPressed: () {},
                  ),
                ),
              ],
            );
          },
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
        ),
      ),
    );
  }
}
