import 'package:flutter/material.dart';

class TextBodyField extends StatelessWidget {
  final TextEditingController _textController;

  const TextBodyField({
    Key key,
    @required TextEditingController textController,
  })  : _textController = textController,
        super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
