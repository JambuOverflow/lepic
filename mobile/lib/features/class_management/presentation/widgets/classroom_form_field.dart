import 'package:flutter/material.dart';

class ClasroomFormField extends StatefulWidget {
  final TextEditingController textController;
  final String label;
  final bool numeric;

  ClasroomFormField({
    this.textController,
    this.label,
    this.numeric,
  });

  @override
  _ClasroomFormFieldState createState() => _ClasroomFormFieldState();
}

class _ClasroomFormFieldState extends State<ClasroomFormField> {
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
