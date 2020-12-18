import 'package:flutter/material.dart';
import 'package:mobile/features/student_management/presentation/widgets/drawer_overlay.dart';
//import '../widgets/drawer_overlay.dart';

class HomeScreen extends StatefulWidget {
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Text("Home has no content, may become some sort of catalog"),
      drawer: DrawerOverlay(),
    );
  }
}
