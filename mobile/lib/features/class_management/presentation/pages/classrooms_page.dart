import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/classroom_bloc.dart';

import 'widgets/classroom_list_view.dart';
import 'widgets/create_classroom_dialog.dart';

class ClassroomsPage extends StatefulWidget {
  @override
  _ClassroomsPageState createState() => _ClassroomsPageState();
}

class _ClassroomsPageState extends State<ClassroomsPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ClassroomBloc>(context).add(GetClassroomsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My classes')),
      body: Center(
        child: BlocConsumer<ClassroomBloc, ClassroomState>(
          listener: (context, state) {
            if (state is Error) {
              Scaffold.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is GettingClassrooms) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ClassroomsGot) {
              if (state.classrooms.isEmpty)
                return Center(child: Text('Nothing here'));
              else
                return ClassroomListView(state: state);
            } else
              return Center(child: const Text('No data'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 10,
        onPressed: () => showDialog(
          barrierDismissible: true,
          context: context,
          builder: (_) => CreateClassroomDialog(),
        ),
      ),
    );
  }
}

class FakeAppBarButtons extends StatelessWidget {
  const FakeAppBarButtons({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.filter_alt_rounded),
        SizedBox(width: 16),
        Icon(Icons.search_rounded),
        SizedBox(width: 16),
      ],
    );
  }
}
