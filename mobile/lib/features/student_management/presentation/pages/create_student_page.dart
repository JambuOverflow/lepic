import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/presentation/widgets/basic_form.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import '../bloc/student_bloc.dart';

class CreateStudentPage extends StatefulWidget {
  const CreateStudentPage({Key key}) : super(key: key);

  @override
  _CreateStudentPageState createState() => _CreateStudentPageState();
}

class _CreateStudentPageState extends State<CreateStudentPage> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();

  _CreateStudentPageState();

  @override
  Widget build(BuildContext context) {
    final _bloc = BlocProvider.of<StudentBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('New Student'),
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
                      'Create Student',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      _bloc.add(
                        CreateStudentEvent(
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                        ),
                      );
                    },
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
