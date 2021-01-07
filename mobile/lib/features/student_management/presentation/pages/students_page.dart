import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/widgets/empty_list_text.dart';
import '../widgets/create_student_dialog.dart';
import '../bloc/student_bloc.dart';
import '../widgets/student_item.dart';

class StudentsPage extends StatefulWidget {
  @override
  _StudentsPageState createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<StudentBloc>(context).add(LoadStudentsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final _bloc = BlocProvider.of<StudentBloc>(context);

    return Scaffold(
      body: BlocConsumer<StudentBloc, StudentState>(
        builder: (context, state) {
          if (state is StudentsLoaded) {
            if (state.students.isEmpty)
              return EmptyListText(
                'Nothing here 😢 Try creating students for your class!',
                fontSize: 16,
              );
            else
              return ListView.builder(
                itemCount: _bloc.students.length,
                itemBuilder: (context, index) =>
                    StudentItem(studentIndex: index),
              );
          } else
            return CircularProgressIndicator();
        },
        listener: (context, state) {
          if (state is Error)
            Scaffold.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 10,
        onPressed: () => showDialog(
          barrierDismissible: true,
          context: context,
          builder: (_) => BlocProvider.value(
            value: _bloc,
            child: CreateStudentDialog(),
          ),
        ),
      ),
    );
  }
}
