import 'package:flutter/material.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';

class RoleDropdownButton extends StatelessWidget {
  const RoleDropdownButton({
    Key key,
  }) : super(key: key);

  // todo: Update Dropdown 'value' after selection
  @override
  Widget build(BuildContext context) {
    return DropdownButton<Role>(
      value: Role.teacher,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.black87),
      onChanged: (Role newValue) {
        newValue = newValue;
      },
      items: <Role>[Role.teacher, Role.researcher, Role.support ]
          .map<DropdownMenuItem<Role>>((Role value) {
        return DropdownMenuItem<Role>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    );
  }
}
