//Não tava previsto na sprint - mas é requisito pra classe
//Não tá implementado ainda
// O que eu fizer pra classes vou replicar aqui ou transformar numa lista que só chama parâmetros diferentes como tu querias
/*
import 'package:flutter/material.dart';
import 'package:lepic_screen_test/components/item_student.dart';
import 'package:lepic_screen_test/models/student.dart';
import 'package:lepic_screen_test/screens/drawer_overlay.dart';

class ShowClasses extends StatefulWidget {
  ShowClasses({Key key}) : super(key: key);
  final List<Student> _listClasses = List();

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
      appBar: AppBar(title: Text('Students')),
      drawer: DrawerOverlay(),
      body: ListView.builder(
        itemCount: widget._listClasses.length,
        itemBuilder: (context, indice) {
          final schoolclass = widget._listClasses[indice];
          return ItemStudent(schoolclass);
        },
      ),
    );
  }
}
*/
