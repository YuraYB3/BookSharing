// ignore_for_file: file_names

import 'package:booksshare/Services/auth.dart';
import 'package:flutter/material.dart';

import '../Settings/UserInfo.dart';

class UserPanel extends StatelessWidget {
  final AuthService _auth = AuthService();

  UserPanel({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xff008787)),
              child: UserList(_auth.getUserID()!)),
          ListTile(
            title: const Text('My profile'),
            leading: const Icon(Icons.account_circle_outlined),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            title: const Text('My books'),
            leading: const Icon(Icons.my_library_books),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            title: const Text('Reads'),
            leading: const Icon(Icons.menu_book),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/library');
            },
          ),
          ListTile(
            title: const Text('Settings'),
            leading: const Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
          ListTile(
            title: const Text('Log out'),
            leading: const Icon(Icons.logout),
            onTap: () async {
              await _auth.signOut();
              // ignore: use_build_context_synchronously
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
