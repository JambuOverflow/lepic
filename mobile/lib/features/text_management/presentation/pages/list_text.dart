import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/text_management/presentation/bloc/text_bloc.dart';

import '../../domain/entities/text.dart';
import 'detail_text.dart';
import '../../../user_management/presentation/widgets/drawer_overlay.dart';

class ShowTexts extends StatefulWidget {
  ShowTexts({Key key}) : super(key: key);

  @override
  _ShowTextsState createState() => _ShowTextsState();
}

class _ShowTextsState extends State<ShowTexts> {
  @override
  Widget build(BuildContext context) {
    final _bloc = BlocProvider.of<TextBloc>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Texts')),
      drawer: DrawerOverlay(),
      body: ListView.builder(
        itemCount: _bloc.texts.length,
        itemBuilder: (context, index) {
          final text = _bloc.texts[index];
          return ItemText(text);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('/add_text');
        },
      ),
    );
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
