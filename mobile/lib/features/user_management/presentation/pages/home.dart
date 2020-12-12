import 'package:flutter/material.dart';
import '../widgets/drawer_overlay.dart';

class HomeScreen extends StatefulWidget {
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<HomeScreen> {
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: _scaffoldKey,
      appBar: AppBar(title: Text('Home')),
      body: //Text("Home has no content, may become some sort of catalog"),
          Container(
        //height: 80, // esses parâmetros estão dando overflow, vou deixar comentado por enquanto
        //padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("Home has no content, may become some sort of catalog"),
            Text(
                "Esses botões são telas que não dá pra acessar pelo caminho normal que teriam, único jeito de mostrar por enquanto"),
            RaisedButton(
              child: Text(
                'Edit Class',
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () {
                print("Editing Class");
                Navigator.of(context).pushNamed(
                  '/eighth',
                );
              },
            ),
            RaisedButton(
              child: Text(
                'Text Detail',
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () {
                print(
                    "Text was created but is not on this user story, returned home");
                Navigator.of(context).pushNamed(
                  '/home',
                );
              },
            ),
          ],
        ),
      ),
      drawer: DrawerOverlay(),
    );
  }
}
