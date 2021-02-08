import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'preview_card.dart';
import '../../domain/entities/text.dart';
import '../bloc/text_bloc.dart';
import '../pages/text_detail_page.dart';
import '../pages/text_editing_page.dart';

class TextPreviewCard extends StatelessWidget {
  const TextPreviewCard({
    Key key,
    @required MyText text,
  })  : _text = text,
        super(key: key);

  final MyText _text;

  @override
  Widget build(BuildContext context) {
    return PreviewCard(
      title: 'TEXT',
      content: [
        buildTextPreviewArea(context),
        buildButtons(context),
      ],
    );
  }

  Padding buildButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            child: Text('EDIT'),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<TextBloc>(context),
                  child: TextEditingPage(textToEdit: _text),
                ),
              ),
            ),
          ),
          FlatButton(
            child: Text('SEE MORE'),
            onPressed: () => navigateToDetails(context),
          ),
        ],
      ),
    );
  }

  Padding buildTextPreviewArea(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        splashColor: Colors.blue[100].withOpacity(0.5),
        highlightColor: Colors.blue[100].withAlpha(0),
        onTap: () => navigateToDetails(context),
        child: Text(
          _text.body,
          maxLines: 6,
          textAlign: TextAlign.justify,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  void navigateToDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: BlocProvider.of<TextBloc>(context),
          child: TextDetailPage(_text),
        ),
      ),
    );
  }
}
