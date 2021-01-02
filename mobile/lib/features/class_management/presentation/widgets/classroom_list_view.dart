import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/class_management/presentation/bloc/classroom_bloc.dart';
import 'classroom_item.dart';

class ClassroomListView extends StatelessWidget {
  const ClassroomListView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ClassroomBloc>(context);

    return Column(
      children: <Widget>[
        Text("Total classes:${bloc.classrooms.length}"),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: bloc.classrooms.length,
            itemBuilder: (context, index) {
              final classroom = bloc.classrooms[index];
              return Dismissible(
                key: UniqueKey(),
                background: Container(),
                child: ClassroomItem(index: index),
                onDismissed: (_) => _emitDeleteEventAndShowSnackBar(
                  classroom: classroom,
                  context: context,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _emitDeleteEventAndShowSnackBar({
    @required Classroom classroom,
    @required BuildContext context,
  }) {
    final bloc = BlocProvider.of<ClassroomBloc>(context);
    bloc.add(DeleteClassroomEvent(classroom: classroom));

    Scaffold.of(context).showSnackBar(
      SnackBar(content: Text("student ${classroom.name} deleted")),
    );
  }
}
