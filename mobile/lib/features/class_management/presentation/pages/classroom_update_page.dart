import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/class_management/presentation/widgets/classroom_form_field.dart';

import '../bloc/classroom_bloc.dart';

class ClassroomUpdatePage extends StatefulWidget {
  @override
  _ClassroomUpdatePageState createState() => _ClassroomUpdatePageState();
}

class _ClassroomUpdatePageState extends State<ClassroomUpdatePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _gradeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update class'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            ClasroomFormField(
              label: 'Current Name',
              textController: _nameController,
            ),
            ClasroomFormField(
              label: 'Current Grade',
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
                  padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
                  child: RaisedButton(
                    child: Text(
                      'Update',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {},
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
