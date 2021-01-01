import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/class_management/presentation/bloc/classroom_bloc.dart';
import 'package:mobile/features/class_management/presentation/pages/classroom_detail_page.dart';
import 'update_classroom_dialog.dart';

class ClassroomItem extends StatelessWidget {
  final int index;

  const ClassroomItem({Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ClassroomBloc>(context);

    return GestureDetector(
      child: ListTile(
        title: Hero(
          tag: bloc.classrooms[index].name,
          child: Text(
            'Class: ${bloc.classrooms[index].name}',
          ),
        ),
        subtitle: Hero(
          tag: bloc.classrooms[index].name,
          child: Text(
            'Grade: ${bloc.classrooms[index].grade}',
          ),
        ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ClassroomDetailPage(
              classroom: bloc.classrooms[index],
            ),
          ),
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
      ),
    );
  }
}
