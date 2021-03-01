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

    return TextFormField(
      controller: _textController,
      decoration: InputDecoration(
        hintText: 'Click here to start adding the text body or hold to paste',
        hintMaxLines: 2,
        border: InputBorder.none,
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
      validator: (value) {
        if (!value.contains('.*[a-zA-Z].*')) return 'Please enter a valid text';
        if (value.isEmpty) return 'A text body is required';
        return null;
      },
      maxLines: null,
      maxLength: 2000,
    );
  }

  void insertTextIfExists() {
    if (body != null) _textController.text = body;
  }
}
