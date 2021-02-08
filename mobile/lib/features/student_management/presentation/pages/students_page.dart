import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/presentation/widgets/add_to_list_button.dart';

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
            return _buildStudentsList(state, _bloc);
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
      floatingActionButton: AddToListButton(
        bloc: _bloc,
        text: 'Add Student',
        dialog: CreateStudentDialog(),
      ),
    );
  }

  StatelessWidget _buildStudentsList(StudentsLoaded state, StudentBloc _bloc) {
    if (state.students.isEmpty) {
      return EmptyListText(
        'Nothing here 😢 Try creating students for your class!',
        fontSize: 16,
      );
    } else {
      return ListView.builder(
        itemCount: _bloc.students.length,
        itemBuilder: (context, index) => StudentItem(studentIndex: index),
      );
    }
  }
}
