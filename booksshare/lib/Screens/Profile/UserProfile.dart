// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/userModel.dart';
import '../../Services/databaseUserService.dart';
import '../../Shared/appTheme.dart';
import '../../Widgets/AppBar/userAppBar.dart';
import '../../Widgets/Panel/userPanel.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  UserAppBar userAppBar = UserAppBar();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<UserModel>?>.value(
        value: DatabaseUserService(uid: '').users,
        initialData: null,
        child: Scaffold(
            appBar: userAppBar.headerBar(context),
            backgroundColor: AppTheme.backgroundColor,
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Container(
                    height: 250,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: AppTheme.secondBackgroundColor),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        Container(
                          height: 10,
                        ),
                        Container(
                          child: Text("Name"),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                                height: 100,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [Text('К-ть книг'), Text('0')],
                                )),
                            Container(
                                height: 100,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [Text('Рецензії'), Text('12')],
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            drawer: UserPanel()));
  }
}
