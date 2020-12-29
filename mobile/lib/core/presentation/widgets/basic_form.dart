import 'package:flutter/material.dart';

class BasicForm extends StatefulWidget {
  final TextEditingController textController;
  final String label;
  final bool numeric;

  BasicForm({
    this.textController,
    this.label,
    this.numeric,
  });

  @override
  _BasicFormState createState() => _BasicFormState();
}

class _BasicFormState extends State<BasicForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        controller: widget.textController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: widget.label,
        ),
        keyboardType:
            widget.numeric != null ? TextInputType.number : TextInputType.text,
      ),
    );
  }
}
