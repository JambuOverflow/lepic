import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/widgets/drawer_overlay.dart';

import '../../domain/entities/classroom.dart';
import '../bloc/class_bloc.dart';
import 'detail_class.dart';

class ShowClasses extends StatefulWidget {
  @override
  _ShowClassesState createState() => _ShowClassesState();
}

class _ShowClassesState extends State<ShowClasses> {
  TextEditingController tutorIdController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  ClassroomBloc _classBloc;
  @override
  Widget build(BuildContext context) {
    _classBloc = BlocProvider.of<ClassroomBloc>(context); //aqui começa o erro
    return Scaffold(
        appBar: AppBar(title: Text('Classes')),
        drawer: DrawerOverlay(),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(
                '/add_class',
              );
            }),
        body: Container(
            child: ListView(children: <Widget>[
          RaisedButton(child: Text('Search Class'), onPressed: null),
          BlocListener<ClassroomBloc, ClassroomState>(
              listener: (context, state) {
            if (state is Error) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          }, child: BlocBuilder<ClassroomBloc, ClassroomState>(
                  builder: (context, state) {
            return Container(
                height: 80,
                padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
                child: ListTile(
                    title: Text('Class Name'),
                    subtitle: Text('Class Grade'),
                    trailing: IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: () {
                          print("Redirecting to detailed class");
                          print("name: " + nameController.text);
                          print("tutorID: " + tutorIdController.text); //as int
                          Navigator.of(context).pushNamed(
                            '/detail_class',
                          );
                          /*GetClassEvent(
                          tutorIdController.text as int,
                          nameController.text,
                        );*/
                        })));
          }))
        ])));
  }

//card widget pra cada turma

}
