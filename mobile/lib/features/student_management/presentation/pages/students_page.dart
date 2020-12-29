import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/student_management/presentation/bloc/student_bloc.dart';
import '../../domain/entities/student.dart';

class StudentsPage extends StatefulWidget {
  StudentsPage({Key key}) : super(key: key);

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('My students'),
      ),
      body: Center(
        child: BlocListener<StudentBloc, StudentState>(
          listener: (context, state) {
            if (state is Error) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          child: _blocBuilder(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        elevation: 10,
        onPressed: () => _modalAdd(context: context),
      ),
    );
  }

  _blocBuilder() {
    return BlocBuilder<StudentBloc, StudentState>(
      builder: (context, state) {
        if (state is GettingStudents) {
          return Center(child: CircularProgressIndicator());
        } else if (state is StudentsGot) {
          return Column(
            children: <Widget>[
              Text("Total students:${state.students.length}"),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.students.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: UniqueKey(),
                      background: Container(
                        color: Colors.blue,
                      ),
                      child: ListTile(
                        title: Text(
                          '${state.students[index].firstName} ${state.students[index].lastName}',
                        ),
                        trailing: Wrap(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                              ),
                              onPressed: () => _modalUpdate(
                                student: state.students[index],
                                context: context,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onDismissed: (DismissDirection direction) {
                        BlocProvider.of<StudentBloc>(context).add(
                            DeleteStudentEvent(student: state.students[index]));

                        // Then show a snackbar.
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                          "student ${state.students[index].firstName} ${state.students[index].lastName} deleted",
                        )));
                      },
                    );
                  },
                ),
              ),
            ],
          );
        } else if (state is Error) {
          return Center(child: Text("Error"));
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'No data',
              ),
            ],
          ),
        );
      },
    );
  }
}

_modalAdd({BuildContext context}) {
  String _fistName;
  String _lastName;
  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Create new student'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  onChanged: (newFirstName) => _fistName = newFirstName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'First name',
                  ),
                ),
                TextFormField(
                  onChanged: (newLastName) => _lastName = newLastName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Last name',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            FlatButton(
              onPressed: () {
                BlocProvider.of<StudentBloc>(context).add(CreateNewStudentEvent(
                  classroom: null,
                  firstName: _fistName,
                  lastName: _lastName,
                ));

                Navigator.pop(context);
              },
              child: Text('Add student'),
            ),
          ],
        );
      });
}

_modalUpdate({Student student, BuildContext context}) {
  var _firstName = student.firstName;
  var _lastName = student.lastName;
  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Edit Student"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  initialValue: student.firstName,
                  onChanged: (newFirstName) => _firstName = newFirstName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '${student.firstName}',
                  ),
                ),
                TextFormField(
                  initialValue: student.lastName,
                  onChanged: (newLastName) => _lastName = newLastName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '${student.lastName}',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            FlatButton(
              onPressed: () {
                BlocProvider.of<StudentBloc>(context).add(UpdateStudentEvent(
                  firstName: _firstName,
                  lastName: _lastName,
                  student: student,
                ));
                Navigator.pop(context);
              },
              child: Text('Edit'),
            ),
          ],
        );
      });
}
