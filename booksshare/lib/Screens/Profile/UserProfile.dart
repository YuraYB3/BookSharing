// ignore_for_file: file_names
import 'package:booksshare/Services/authService.dart';
import 'package:booksshare/Services/bookService.dart';
import 'package:booksshare/Widgets/userInfo.dart';
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
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    var userID = authService.getUserID();
    UserList userInfo = UserList(userID!);
    BookService bookService = BookService(userID);
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
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
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
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: userInfo.UserImage())),
                        Container(
                          height: 10,
                        ),
                        userInfo.UserName(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                                height: 100,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Text(
                                      'К-ть книг:',
                                      style:
                                          TextStyle(color: AppTheme.textColor),
                                    ),
                                    Text(bookService
                                        .readUserBooks()
                                        .length
                                        .toString())
                                  ],
                                )),
                            SizedBox(
                                height: 100,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: const [
                                    Text('Рецензії',
                                        style: TextStyle(
                                            color: AppTheme.textColor)),
                                    Text('12',
                                        style: TextStyle(
                                            color: AppTheme.textColor))
                                  ],
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            drawer: UserPanel()));
  }
}
