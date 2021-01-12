import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/class_management/presentation/widgets/classroom_list_view.dart';
import 'package:mobile/features/class_management/presentation/widgets/create_classroom_dialog.dart';
import '../bloc/classroom_bloc.dart';

class ClassroomsPage extends StatefulWidget {
  @override
  _ClassroomsPageState createState() => _ClassroomsPageState();
}

class _ClassroomsPageState extends State<ClassroomsPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ClassroomBloc>(context).add(LoadClassroomsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Classes')),
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
            if (state is ClassroomsLoadInProgress) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ClassroomsLoaded) {
              return ClassroomListView();
            } else
              return Center(child: const Text('No data'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, key: Key("createClass"),),
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
