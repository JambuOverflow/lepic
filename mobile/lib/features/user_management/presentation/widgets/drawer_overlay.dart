//esse código é muito replicado, vou tentar mudar ele pra uma screen de overlay e usar on pressed e on tap pra entrar nela
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
            child: Text(
              //'Drawer Header'
              '(Photo or Logo/Name/Role/ID)',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                print('Home');
                Navigator.of(context).pushNamed(
                  '/home',
                );
              }),
          ListTile(
            leading: Icon(Icons.class__rounded),
            title: Text('Classes'),
            onTap: () {
              print('classes');
              Navigator.of(context).pushNamed(
                '/seventh',
                //'/eighth',
              );
            },
          ),
          ListTile(
              leading: Icon(Icons.people),
              title: Text('Students'),
              onTap: () {
                print('students screen not created, returned home');
                Navigator.of(context).pushNamed(
                  '/home',
                );
              }),
          ListTile(
            leading: Icon(Icons.text_fields),
            title: Text('Texts'),
            onTap: () {
              print('texts screen created but not on sprint, returned home');
              Navigator.of(context).pushNamed(
                '/home',
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Edit Profile'),
            onTap: () {
              print('edit');
              Navigator.of(context).pushNamed(
                '/update_user',
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              print('settings screen not created, returned home');
              Navigator.of(context).pushNamed(
                '/home',
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              print('logout');
              Navigator.of(context).pushNamed(
                '/login',
              );
            },
          ),
        ],
      ),
    );
  }
}
