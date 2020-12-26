import 'package:flutter/material.dart';

class ClasroomForm extends StatefulWidget {
  final TextEditingController textController;
  final String label;
  final bool numeric;

  ClasroomForm({
    this.textController,
    this.label,
    this.numeric,
  });

  @override
  _ClasroomFormState createState() => _ClasroomFormState();
}

class _ClasroomFormState extends State<ClasroomForm> {
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
