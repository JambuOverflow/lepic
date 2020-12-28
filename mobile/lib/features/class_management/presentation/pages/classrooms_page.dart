import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/widgets/drawer_overlay.dart';
import '../bloc/classroom_bloc.dart';

class ClassroomsPage extends StatefulWidget {
  @override
  _ClassroomsPageState createState() => _ClassroomsPageState();
}

class _ClassroomsPageState extends State<ClassroomsPage> {
  TextEditingController tutorIdController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Classes')),
      drawer: DrawerOverlay(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(
            '/add_class',
          );
        },
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            RaisedButton(child: Text('Search Class'), onPressed: null),
            BlocConsumer<ClassroomBloc, ClassroomState>(
              listener: (context, state) {
                if (state is Error) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                    ),
                  );
                }
              },
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
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
