import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/classroom_bloc.dart';
import 'classroom_item.dart';

class ClassroomListView extends StatelessWidget {
  final ClassroomsGot _state;

  const ClassroomListView({Key key, @required ClassroomsGot state})
      : _state = state,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("Total classes:${_state.classrooms.length}"),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Dismissible(
                key: UniqueKey(),
                background: Container(),
                child: ClassroomItem(index: index, state: _state),
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
        classroom: _state.classrooms[index],
      ),
    );
  }

  void showDeletedClassroomSnackBar(BuildContext context, int index) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "student ${_state.classrooms[index].name} deleted",
        ),
      ),
    );
  }
}
