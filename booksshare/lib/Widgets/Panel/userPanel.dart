// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../Services/authService.dart';
import '../../Shared/appTheme.dart';
import '../userInfo.dart';

class UserPanel extends StatelessWidget {
  final AuthService _auth = AuthService();

  UserPanel({super.key});
  @override
  Widget build(BuildContext context) {
    UserInformation userList = UserInformation();
    return Drawer(
      backgroundColor: AppTheme.secondBackgroundColor,
      width: 250,
      child: ListView(
        children: <Widget>[
          DrawerHeader(
              decoration: const BoxDecoration(
                color: AppTheme.secondBackgroundColor,
              ),
              child: userList.userInfo(_auth.getUserID()!)),
          ListTile(
            title: const Text(
              'Мій профіль',
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
            title: const Text('Бібліотека',
                style: TextStyle(color: AppTheme.textColor)),
            leading:
                const Icon(Icons.my_library_books, color: AppTheme.iconColor),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            title: const Text('Друзі',
                style: TextStyle(color: AppTheme.textColor)),
            leading: const Icon(Icons.people, color: AppTheme.iconColor),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/friends');
            },
          ),
          ListTile(
            title: const Text('Обмін',
                style: TextStyle(color: AppTheme.textColor)),
            leading: const Icon(Icons.menu_book, color: AppTheme.iconColor),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/exchange');
            },
          ),
          ListTile(
            title: const Text('Налаштування',
                style: TextStyle(color: AppTheme.textColor)),
            leading: const Icon(Icons.settings, color: AppTheme.iconColor),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/settings');
            },
          ),
          ListTile(
            title: const Text('Вийти',
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
