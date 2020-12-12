import 'package:flutter/material.dart';
import 'package:lepic_screen_test/models/text.dart';

class AddText extends StatefulWidget {
  @override
  _AddTextState createState() => _AddTextState();
}

class _AddTextState extends State<AddText> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _textController = TextEditingController();

  String _levelSelected;
  final List<String> levels = [
    "A1",
    "A2",
    "A3",
    "A4",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new Text'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Text title',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Text content',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                hint: Text("Select text level"),
                value: _levelSelected,
                onChanged: (newValue) {
                  setState(() {
                    _levelSelected = newValue;
                  });
                },
                items: levels.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              )),
            ),
            Container(
              height: 80,
              padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
              child: RaisedButton(
                child: Text(
                  'Add text',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  print("Text Added");
                  _createClass(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createClass(BuildContext context) {
    final String textTitle = _titleController.text;
    final String textContent = _textController.text;
    final String textLevel = _levelSelected;
    if (textTitle != null && textContent != null) {
      final createdClass = MyText(
        textContent,
        textContent,
        textLevel,
      );
      Navigator.pop(context, createdClass);
    }
  }
}
