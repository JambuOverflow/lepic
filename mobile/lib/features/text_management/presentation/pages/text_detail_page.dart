import 'package:flutter/material.dart';

import '../widgets/word_count_area.dart';
import '../../../../core/presentation/widgets/background_app_bar.dart';
import '../../domain/entities/text.dart';
import '../widgets/text_area.dart';
import '../widgets/text_view_popup_menu_button.dart';

class TextDetailPage extends StatelessWidget {
  final MyText _text;

  final _scrollControler = ScrollController();

  TextDetailPage(this._text);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackgroundAppBar(
        title: '${_text.title}',
        actions: <Widget>[TextViewPopupMenuButton()],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () => Navigator.of(context).popAndPushNamed(
          '/add_text',
          arguments: {'textToEdit': _text},
        ),
      ),
      body: Scrollbar(
        isAlwaysShown: true,
        controller: _scrollControler,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextArea(
              textBody: _text.body,
              scrollControler: _scrollControler,
            ),
            SizedBox(height: 12),
            WordCountText(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
