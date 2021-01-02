import 'package:flutter/material.dart';

import '../pages/text_detail_page.dart';
import '../../domain/entities/text.dart';

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
