// ignore_for_file: file_names

import 'package:booksshare/Screens/AppBar/userAppBar.dart';
import 'package:booksshare/Screens/Panel/userPanel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/userModel.dart';
import '../../Services/DatabaseUser.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({super.key});

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  UserAppBar u = UserAppBar();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<UserModel>?>.value(
        value: DatabaseUserService(uid: '').users,
        initialData: null,
        child: Scaffold(
            appBar: u.headerBar(context),
            backgroundColor: Colors.white,
            body: const Text("User Settings :)"),
            drawer: UserPanel()));
  }
}
