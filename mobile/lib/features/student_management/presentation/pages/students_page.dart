import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/student_management/presentation/bloc/student_bloc.dart';
import 'package:mobile/features/student_management/presentation/pages/create_student_page.dart';

import '../../domain/entities/student.dart';
import '../widgets/student_item.dart';

class StudentsPage extends StatefulWidget {
  StudentsPage({Key key}) : super(key: key);
  final List<Student> _listStudents = List();

  @override
  _StudentsPageState createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<StudentBloc>(context).add(GetStudentsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final _bloc = BlocProvider.of<StudentBloc>(context);

    return Scaffold(
      body: BlocConsumer<StudentBloc, StudentState>(
        builder: (context, state) {
          if (state is StudentsLoaded) {
            return ListView.builder(
              itemCount: _bloc.students.length,
              itemBuilder: (context, index) {
                final student = _bloc.students[index];
                return StudentItem(student);
              },
            );
          } else
            return CircularProgressIndicator();
        },
        listener: (context, state) {
          if (state is Error)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<CreateStudentPage>(
              builder: (_) => BlocProvider.value(
                value: BlocProvider.of<StudentBloc>(context),
                child: CreateStudentPage(),
              ),
            ),
          );
        },
      ),
    );
  }
}
