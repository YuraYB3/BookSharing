// ignore_for_file: file_names

import 'package:booksshare/Screens/AppBar/userAppBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/userModel.dart';
import '../../Services/DatabaseUser.dart';
import '../Panel/UserPanel.dart';

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
            backgroundColor: Colors.white,
            body: const Text("User Profile :)"),
            drawer: UserPanel()));
  }
}
