import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
              return Dismissible(
                key: UniqueKey(),
                background: Container(),
                child: ClassroomItem(index: index),
                onDismissed: (_) {
                  emitDeleteClassroomEvent(context: context, index: index);
                  showDeletedClassroomSnackBar(context, index);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void emitDeleteClassroomEvent(
      {@required BuildContext context, @required int index}) {
    BlocProvider.of<ClassroomBloc>(context).add(
      DeleteClassroomEvent(
        classroom: BlocProvider.of<ClassroomBloc>(context).classrooms[index],
      ),
    );
  }

  void showDeletedClassroomSnackBar(BuildContext context, int index) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "student ${BlocProvider.of<ClassroomBloc>(context).classrooms[index].name} deleted",
        ),
      ),
    );
  }
}
