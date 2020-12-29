import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import '../bloc/classroom_bloc.dart';

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
      appBar: AppBar(
        title: const Text('My classes'),
      ),
      body: Center(
        child: BlocListener<ClassroomBloc, ClassroomState>(
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
    return BlocBuilder<ClassroomBloc, ClassroomState>(
      builder: (context, state) {
        if (state is GettingClassrooms) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ClassroomsGot) {
          return Column(
            children: <Widget>[
              Text("Total classes:${state.classrooms.length}"),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.classrooms.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: UniqueKey(),
                      background: Container(
                        color: Colors.blue,
                      ),
                      child: ListTile(
                        title: Text(
                          '${state.classrooms[index].name}',
                        ),
                        subtitle: Text(
                          '${state.classrooms[index].grade}',
                        ),
                        trailing: Wrap(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                              ),
                              onPressed: () => _modalUpdate(
                                classroom: state.classrooms[index],
                                context: context,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onDismissed: (DismissDirection direction) {
                        BlocProvider.of<ClassroomBloc>(context).add(
                          DeleteClassroomEvent(
                            classroom: state.classrooms[index],
                          ),
                        );

                        // Then show a snackbar.
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                          "student ${state.classrooms[index].name} deleted",
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
  String _name;
  String _grade;
  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Create new class'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  onChanged: (newName) => _name = newName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Class name',
                  ),
                ),
                TextFormField(
                  onChanged: (newGrade) => _grade = newGrade,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Class grade',
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
                BlocProvider.of<ClassroomBloc>(context).add(
                  CreateClassroomEvent(
                    name: _name,
                    grade: _grade,
                  ),
                );

                Navigator.pop(context);
              },
              child: Text('Add class'),
            ),
          ],
        );
      });
}

_modalUpdate({Classroom classroom, BuildContext context}) {
  String _name = classroom.name;
  String _grade = classroom.grade.toString();
  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Edit class"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  initialValue: classroom.name,
                  onChanged: (newName) => _name = newName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '${classroom.name}',
                  ),
                ),
                TextFormField(
                  initialValue: classroom.grade.toString(),
                  onChanged: (newGrade) => _grade = newGrade,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '${classroom.grade}',
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
                BlocProvider.of<ClassroomBloc>(context).add(
                  UpdateClassroomEvent(
                    classroom: classroom,
                    name: _name,
                    grade: _grade,
                  ),
                );
                Navigator.pop(context);
              },
              child: Text('Edit'),
            ),
          ],
        );
      });
}
