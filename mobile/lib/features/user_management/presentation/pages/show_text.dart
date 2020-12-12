//vou isolar aqui só a página de mostrar alunos pois mostrar estava junto com o código de drawer e na home

import 'package:flutter/material.dart';
import 'package:lepic_screen_test/models/text.dart';
import 'package:lepic_screen_test/screens/text_detail.dart';
//import 'package:lepic_screen_test/screens/drawer_overlay.dart';
import 'drawer_overlay.dart';

class ShowText extends StatefulWidget {
  ShowText({Key key}) : super(key: key);
  final List<MyText> _listTexts = List();

  @override
  _ShowTextState createState() => _ShowTextState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _ShowTextState extends State<ShowText> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Texts')),
      body: ListView.builder(
        itemCount: widget._listTexts.length,
        itemBuilder: (context, indice) {
          final texts = widget._listTexts[indice];
          return ItemText(texts);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          /*Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddClass();
          }))*/
          Navigator.of(context)
              .pushNamed(
                '/fifth',
              )
              .then(
                (createdText) => _atualiza(createdText),
              );
        },
      ),
      drawer: DrawerOverlay(),
    );
  }

  void _atualiza(MyText createdText) {
    if (createdText != null) {
      setState(() {
        widget._listTexts.add(createdText);
      });
    }
  } //se é só mostrar não sei se tem que atualizar algo,
  //devia só puxar a info direto independente se foi criado ou removido algo
}

class ItemText extends StatelessWidget {
  final MyText _myText;
  ItemText(this._myText);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(_myText.title.toString()),
        subtitle: Text(_myText.level.toString()),
        trailing: IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TextDetailPage(
                    _myText), // depois ajeitar pra receber parâmetro (args) no generate route
              ),
            );
          },
        ),
      ),
    );
  }
}
