import 'package:flutter/material.dart';

class TextTitleField extends StatelessWidget {
  final TextEditingController _titleController;
  final String title;

  const TextTitleField({
    Key key,
    this.title,
    @required TextEditingController titleController,
  })  : _titleController = titleController,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    insertTextIfExists();

    return TextField(
      maxLines: 1,
      controller: _titleController,
      decoration: InputDecoration(
        hintText: 'Title',
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
      style: TextStyle(fontSize: textTheme.headline6.fontSize),
    );
  }

  void insertTextIfExists() {
    if (title != null) _titleController.text = title;
  }
}
