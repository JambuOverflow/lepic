import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/widgets/drawer_overlay.dart';

import '../../domain/entities/classroom.dart';
import '../bloc/class_bloc.dart';
import 'detail_class.dart';

class ShowClasses extends StatefulWidget {
  //ShowClasses({Key key}) : super(key: key);
  //final List<Classroom> _listClasses = List();

  @override
  _ShowClassesState createState() => _ShowClassesState();
}

class _ShowClassesState extends State<ShowClasses> {
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //final Classroom _schoolClass;
  //ItemClass(this._schoolClass);
  /*ScrollController _controller;
  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener); //the listener for up and down.
    super.initState();
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        //you can do anything here
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        //you can do anything here
      });
    }
  }*/

  TextEditingController tutorIdController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  ClassBloc _classBloc;
  @override
  Widget build(BuildContext context) {
    _classBloc = BlocProvider.of<ClassBloc>(context); //aqui começa o erro
    return Scaffold(
        //key: _scaffoldKey,
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
          Container(
              height: 80,
              child: ListTile(
                  title: Text('Class Name'),
                  subtitle: Text('Class Grade'),
                  trailing: IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          '/detail_class',
                        );
                      }))),
        ])));
  }
  /*
      /*body: ListView.builder(
        itemCount: widget._listClasses.length,
        itemBuilder: (context, indice) {
          final schoolclass = widget._listClasses[indice];
          return ItemClass(schoolclass);
        },
      ),*/
      body: Container(
        child:
            /*Padding(
        padding: EdgeInsets.all(8.0),
        child: */
            ListView(
          children: <Widget>[
            /*SizedBox(
              width: 100,
              height: 100,
              child:*/
            /*Card(
              child: ListTile(
                //title: Text(_schoolClass.name.toString()),
                //subtitle: Text(_schoolClass.grade.toString()),
                title: Text('Class Name'),
                subtitle: Text('Class Grade'),
                trailing: IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/detail_class',
                    );
                  },
                ),
              ),
              //),
            ),*/
            Container(
              height: 50,
              color: Colors.amber[600],
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: tutorIdController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText:
                      'Tutor ID', // same as user id if the user is a teacher (should be automatic for them)
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Class Name',
                ),
              ),
            ),
            BlocListener<ClassBloc, ClassState>(
              listener: (context, state) {
                if (state is Error) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                    ),
                  );
                }
              },
              child:
                  BlocBuilder<ClassBloc, ClassState>(builder: (context, state) {
                return Container(
                  height: 80,
                  padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
                  child: ListTile(
                    //title: Text(_schoolClass.name.toString()),
                    //subtitle: Text(_schoolClass.grade.toString()),
                    title: Text('Class Name2'),
                    subtitle: Text('Class Grade2'),
                    trailing: IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: () {
                        print("Redirecting to detailed class");
                        print("name: " + nameController.text);
                        print("tutorID: " + tutorIdController.text as int);
                        /*GetClassEvent(
                          tutorIdController.text as int,
                          nameController.text,
                        );*/
                      },
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(
            '/add_class',
          ) /*
              .then(
                (createdClass) => _atualiza(createdClass),
              )*/
              ;
        },
      ),
      //child: Text('hello world!'),
    );
  }
}
//}

//card widget pra cada turma
*/
}
