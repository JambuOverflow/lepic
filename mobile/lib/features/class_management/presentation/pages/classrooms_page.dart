import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/class_management/presentation/widgets/create_classroom_dialog.dart';

import '../../../../core/presentation/widgets/add_to_list_button.dart';
import '../widgets/classroom_list_view.dart';
import '../bloc/classroom_bloc.dart';

class ClassroomsPage extends StatefulWidget {
  @override
  _ClassroomsPageState createState() => _ClassroomsPageState();
}

class _ClassroomsPageState extends State<ClassroomsPage> {
  ClassroomBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<ClassroomBloc>(context);
    _bloc.add(LoadClassroomsEvent());
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
      floatingActionButton: AddToListButton(
        bloc: _bloc,
        text: 'Add Classroom',
        dialog: CreateClassroomDialog(),
      ),
    );
  }
}
