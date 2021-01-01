import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/presentation/widgets/basic_form.dart';

import '../bloc/classroom_bloc.dart';

class ClassroomCreationPage extends StatefulWidget {
  @override
  _ClassroomCreationPageState createState() => _ClassroomCreationPageState();
}

class _ClassroomCreationPageState extends State<ClassroomCreationPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _gradeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Class'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            BasicForm(
              label: 'Class Name',
              textController: _nameController,
            ),
            BasicForm(
              label: 'Grade',
              textController: _gradeController,
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
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: RaisedButton(
                    child: Text(
                      'Create class',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      context.read<ClassroomBloc>().add(
                            CreateClassroomEvent(
                              grade: _gradeController.text,
                              name: _nameController.text,
                            ),
                          );
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
