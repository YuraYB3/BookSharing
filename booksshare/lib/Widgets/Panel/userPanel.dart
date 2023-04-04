// ignore_for_file: file_names

import 'package:booksshare/Shared/appTheme.dart';
import 'package:flutter/material.dart';

import '../../Services/authService.dart';
import '../userInfo.dart';

class UserPanel extends StatelessWidget {
  final AuthService _auth = AuthService();

  UserPanel({super.key});
  @override
  Widget build(BuildContext context) {
    UserList userList = UserList(_auth.getUserID()!);
    return Drawer(
      backgroundColor: AppTheme.secondBackgroundColor,
      width: 250,
      child: ListView(
        children: <Widget>[
          DrawerHeader(
              decoration: const BoxDecoration(
                color: AppTheme.secondBackgroundColor,
              ),
              child: userList.UserInfo()),
          ListTile(
            title: const Text(
              'My profile',
              style: TextStyle(color: AppTheme.textColor),
            ),
            leading: const Icon(
              Icons.account_circle_outlined,
              color: AppTheme.iconColor,
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/profile');
            },
          ),
          ListTile(
            title: const Text('My library',
                style: TextStyle(color: AppTheme.textColor)),
            leading:
                const Icon(Icons.my_library_books, color: AppTheme.iconColor),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            title: const Text('Exchange',
                style: TextStyle(color: AppTheme.textColor)),
            leading: const Icon(Icons.menu_book, color: AppTheme.iconColor),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/exchange');
            },
          ),
          ListTile(
            title: const Text('Settings',
                style: TextStyle(color: AppTheme.textColor)),
            leading: const Icon(Icons.settings, color: AppTheme.iconColor),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/settings');
            },
          ),
          ListTile(
            title: const Text('Log out',
                style: TextStyle(color: AppTheme.textColor)),
            leading: const Icon(Icons.logout, color: AppTheme.iconColor),
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
