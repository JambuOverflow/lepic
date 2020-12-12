import 'package:flutter/material.dart';
import 'package:lepic_screen_test/components/item_class.dart';
import 'package:lepic_screen_test/models/class.dart';
import 'package:lepic_screen_test/screens/drawer_overlay.dart';

class ShowClasses extends StatefulWidget {
  ShowClasses({Key key}) : super(key: key);
  final List<SchoolClass> _listClasses = List();

  @override
  _ShowClassesStatefulWidgetState createState() =>
      _ShowClassesStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _ShowClassesStatefulWidgetState extends State<ShowClasses> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
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

  void _atualiza(SchoolClass createdClass) {
    if (createdClass != null) {
      setState(() {
        widget._listClasses.add(createdClass);
      });
    }
  }
}
