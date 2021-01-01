import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/class_management/presentation/bloc/classroom_bloc.dart';
import 'update_classroom_dialog.dart';

class ClassroomItem extends StatelessWidget {
  final int index;

  const ClassroomItem({Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ClassroomBloc>(context);

    return ListTile(
      title: Text(
        '${bloc.classrooms[index].name}',
      ),
      subtitle: Text(
        '${bloc.classrooms[index].grade}',
      ),
      trailing: Wrap(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => showDialog(
              barrierDismissible: true,
              context: context,
              builder: (_) => UpdateClassroomDialog(
                classroom: bloc.classrooms[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
