import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: Text('Test Page'),
            onTap: () {
              Navigator.pop(context);
              if (ModalRoute.of(context)!.settings.name == "/test") {
                return;
              }
              Navigator.pushReplacementNamed(context, "/test");
            },
          ),
          ListTile(
            title: Text('Test page 2'),
            onTap: () {
              Navigator.pop(context);
              if (ModalRoute.of(context)!.settings.name == "/testtwo") {
                return;
              }
              Navigator.pushReplacementNamed(context, "/testtwo");
            },
          ),
        ],
      ),
    );
  }
}
