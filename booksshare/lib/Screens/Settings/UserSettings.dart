// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/userModel.dart';
import '../../Services/databaseUserService.dart';
import '../../Shared/appTheme.dart';
import '../../Widgets/AppBar/userAppBar.dart';
import '../../Widgets/Panel/userPanel.dart';

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
            backgroundColor: AppTheme.backgroundColor,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                      height: 350,
                      width: 300,
                      color: Colors.amber[200],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Text('Змінити пароль'),
                            ),
                            Container(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Text('Змінити email'),
                            ),
                            Container(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Text('Змінити фото'),
                            ),
                            Container(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Text('Видалити профіль'),
                            )
                          ],
                        ),
                      )),
                )
              ],
            ),
            drawer: UserPanel()));
  }
}
