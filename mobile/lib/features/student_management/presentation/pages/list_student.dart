import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/widgets/drawer_overlay.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/student_management/presentation/bloc/student_bloc.dart';
import 'package:mobile/features/student_management/presentation/pages/detail_student.dart';

class ShowStudents extends StatefulWidget {
  ShowStudents({Key key}) : super(key: key);
  final List<Student> _listStudents = List();

  @override
  _ShowStudentsState createState() => _ShowStudentsState();
}

class _ShowStudentsState extends State<ShowStudents> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  StudentBloc _studentBloc;
  @override
  Widget build(BuildContext context) {
    _studentBloc = BlocProvider.of<StudentBloc>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Students')),
      drawer: DrawerOverlay(),
      body: ListView.builder(
        itemCount: widget._listStudents.length,
        itemBuilder: (context, indice) {
          final student = widget._listStudents[indice];
          return ItemStudent(student);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .pushNamed(
                '/fifth',
              )
              .then(
                (createdStudent) => _atualiza(createdStudent),
              );
        },
      ),
    );
  }

  void _atualiza(Student createdStudent) {
    if (createdStudent != null) {
      setState(() {
        widget._listStudents.add(createdStudent);
      });
    }
  }
}

class ItemStudent extends StatelessWidget {
  final Student _student;
  ItemStudent(this._student);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(_student.firstName.toString()),
        subtitle: Text(_student.classroomId.toString()),
        trailing: IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => StudentDetailPage(
                    _student), // depois ajeitar pra receber parâmetro (args) no generate route
              ),
            );
          },
        ),
      ),
    );
  }
}
