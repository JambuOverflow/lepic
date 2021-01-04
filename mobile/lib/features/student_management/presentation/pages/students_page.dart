import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/student_management/presentation/widgets/create_student_dialog.dart';
import 'package:mobile/features/student_management/presentation/widgets/student_list_view.dart';
import '../bloc/student_bloc.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('My Students')),
      body: Center(
        child: BlocConsumer<StudentBloc, StudentState>(
          listener: (context, state) {
            if (state is Error) {
              Scaffold.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is StudentsLoadInProgress) {
              return Center(child: CircularProgressIndicator());
            } else if (state is StudentsLoaded) {
              return StudentListView();
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
          builder: (_) => CreateStudentDialog(),
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
