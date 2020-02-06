import 'package:flutter/material.dart';

class LeftMenu extends StatelessWidget {
  final Function onLogout;

  LeftMenu({this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(color: Colors.deepOrange),
          child: Text('Account',
              style: TextStyle(color: Colors.white, fontSize: 24)),
        ),
        ListTile(
            leading: Icon(Icons.delete_outline),
            title: Text('Log out'),
            onTap: onLogout)
      ]),
    );
  }
}
