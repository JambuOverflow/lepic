import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../user_management/presentation/widgets/drawer_overlay.dart';
import '../../domain/entities/classroom.dart';
import '../bloc/class_bloc.dart';
import 'detail_class.dart';

class ShowClasses extends StatefulWidget {
  ShowClasses({Key key}) : super(key: key);
  final List<Classroom> _listClasses = List();

  @override
  _ShowClassesState createState() => _ShowClassesState();
}

class _ShowClassesState extends State<ShowClasses> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ClassroomBloc _classBloc;
  @override
  Widget build(BuildContext context) {
    _classBloc = BlocProvider.of<ClassroomBloc>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Classes')),
      drawer: DrawerOverlay(),
      body: ListView.builder(
        itemCount: widget._listClasses.length,
        itemBuilder: (context, indice) {
          final schoolclass = widget._listClasses[indice];
          return ItemClass(schoolclass);
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
                (createdClass) => _atualiza(createdClass),
              );
        },
      ),
    );
  }

  void _atualiza(Classroom createdClass) {
    if (createdClass != null) {
      setState(() {
        widget._listClasses.add(createdClass);
      });
    }
  }
}

class ItemClass extends StatelessWidget {
  final Classroom _schoolClass;
  ItemClass(this._schoolClass);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(_schoolClass.name.toString()),
        subtitle: Text(_schoolClass.grade.toString()),
        trailing: IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ClassDetailPage(
                    _schoolClass), // depois ajeitar pra receber parâmetro (args) no generate route
              ),
            );
          },
        ),
      ),
    );
  }
}
