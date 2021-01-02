import 'package:flutter/material.dart';

class TextBodyField extends StatelessWidget {
  final TextEditingController _textController;
  final String body;

  const TextBodyField({
    Key key,
    this.body,
    @required TextEditingController textController,
  })  : _textController = textController,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    insertTextIfExists();

    return TextField(
      autofocus: true,
      controller: _textController,
      decoration: InputDecoration(
        hintText: 'Text',
        border: InputBorder.none,
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
      maxLines: null,
      maxLength: 2000,
    );
  }

  void insertTextIfExists() {
    if (body != null) _textController.text = body;
  }
}
