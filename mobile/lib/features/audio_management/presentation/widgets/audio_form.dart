import 'package:flutter/material.dart';

class AudioForm extends StatelessWidget {
  final TextEditingController titleController;

  const AudioForm({
    Key key,
    @required this.titleController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: titleController,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Audio title',
      ),
    );
  }
}
