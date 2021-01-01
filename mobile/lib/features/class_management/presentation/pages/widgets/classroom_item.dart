import 'package:flutter/material.dart';
import '../../bloc/classroom_bloc.dart';
import 'update_classroom_dialog.dart';

class ClassroomItem extends StatelessWidget {
  final int index;
  final ClassroomsGot state;

  const ClassroomItem({Key key, this.index, this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        '${state.classrooms[index].name}',
      ),
      subtitle: Text(
        '${state.classrooms[index].grade}',
      ),
      trailing: Wrap(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => showDialog(
              barrierDismissible: true,
              context: context,
              builder: (_) => UpdateClassroomDialog(
                classroom: state.classrooms[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
