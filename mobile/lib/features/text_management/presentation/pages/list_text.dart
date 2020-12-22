import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mobile/features/text_management/presentation/bloc/text_bloc.dart';
import 'package:mobile/features/text_management/presentation/pages/detail_text.dart';
import 'package:mobile/features/user_management/presentation/widgets/drawer_overlay.dart';

class ShowTexts extends StatefulWidget {
  ShowTexts({Key key}) : super(key: key);
  final List<MyText> _listTexts = List();

  @override
  _ShowTextsState createState() => _ShowTextsState();
}

class _ShowTextsState extends State<ShowTexts> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextBloc _textBloc;
  @override
  Widget build(BuildContext context) {
    _textBloc = BlocProvider.of<TextBloc>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Texts')),
      drawer: DrawerOverlay(),
      body: ListView.builder(
        itemCount: widget._listTexts.length,
        itemBuilder: (context, indice) {
          final text = widget._listTexts[indice];
          return ItemText(text);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .pushNamed(
                '/add_text',
              )
              .then(
                (createdText) => _atualiza(createdText),
              );
        },
      ),
    );
  }

  void _atualiza(MyText createdText) {
    if (createdText != null) {
      setState(() {
        widget._listTexts.add(createdText);
      });
    }
  }
}

class ItemText extends StatelessWidget {
  final MyText _text;
  ItemText(this._text);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(_text.title.toString()),
        subtitle: Text(_text.classId.toString()),
        trailing: IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TextDetailPage(
                    _text), // depois ajeitar pra receber parâmetro (args) no generate route
              ),
            );
          },
        ),
      ),
    );
  }
}
