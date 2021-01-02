import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/presentation/widgets/background_app_bar.dart';
import 'package:mobile/features/text_management/presentation/bloc/text_bloc.dart';

import '../../domain/entities/text.dart';
import 'text_detail_page.dart';

class TextsPage extends StatefulWidget {
  TextsPage({Key key}) : super(key: key);

  @override
  _TextsPageState createState() => _TextsPageState();
}

class _TextsPageState extends State<TextsPage> {
  @override
  Widget build(BuildContext context) {
    final _bloc = BlocProvider.of<TextBloc>(context);

    return Scaffold(
      appBar: BackgroundAppBar(title: 'Texts'),
      body: ListView.builder(
        itemCount: _bloc.texts.length,
        itemBuilder: (context, index) {
          final text = _bloc.texts[index];
          return TextItem(text);
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

class TextItem extends StatelessWidget {
  final MyText _text;
  TextItem(this._text);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: ListTile(
            title: Hero(
              tag: 'title_${_text.title}',
              child: Text(
                _text.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            subtitle: Hero(
              tag: 'body_${_text.body}',
              child: Text(
                _text.body,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios)),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TextDetailPage(_text),
          ),
        );
      },
    );
  }
}
