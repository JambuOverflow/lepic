import 'package:flutter/material.dart';

class RoleDropdownButton extends StatelessWidget {
  const RoleDropdownButton({
    Key key,
  }) : super(key: key);

  // todo: Update Dropdown 'value' after selection
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: '-',
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.black87),
      onChanged: (String newValue) {
        newValue = newValue;
      },
      items: <String>['-', 'Student', 'Professor', 'Researcher']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
