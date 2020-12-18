import 'package:flutter/material.dart';

class DrawerOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: DrawerBuildHeader(context)),
          DrawerBuildButton(context, 'Home', '/home', 0),
          DrawerBuildButton(context, 'Classes', '/classes', 1),
          DrawerBuildButton(context, 'Students', '/students', 2),
          DrawerBuildButton(context, 'Texts', '/texts', 3),
          DrawerBuildButton(context, 'Edit Profile', '/update_user', 4),
          DrawerBuildButton(context, 'Settings', '/settings', 5),
          DrawerBuildButton(context, 'Logout', '/login', 6),
        ],
      ),
    );
  }

  Widget DrawerBuildHeader(BuildContext context) {
    //Get info later
    return Column(
      children: [
        //Image.asset('assets/images/JambuOverflow.jpg'),
        Text(
          '(Name)', //GetUserName
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        Text(
          '(Role)', //GetUserRole
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        Text(
          '(ID)', //GetUserID - check if that info should be avaiable or not
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  List<IconData> _icons = [
// The underscore declares a variable as private in dart.
    Icons.home,
    Icons.class__rounded,
    Icons.people,
    Icons.text_fields,
    Icons.account_circle,
    Icons.settings,
    Icons.exit_to_app,
  ];

  Widget DrawerBuildButton(BuildContext context, String textTitle,
      String nameOfRoute, int iconIndex) {
    return ListTile(
      leading: Icon(_icons[iconIndex]),
      title: Text(textTitle),
      onTap: () {
        Navigator.of(context).pushNamed(
          nameOfRoute,
        );
      },
    );
  }
}
