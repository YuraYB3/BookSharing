// ignore_for_file: file_names
import 'package:booksshare/Services/authService.dart';
import 'package:booksshare/Services/bookService.dart';
import 'package:booksshare/Services/reviewService.dart';
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
  ReviewService reviewService = ReviewService();

  @override
  Widget build(BuildContext context) {
    var userID = authService.getUserID();
    UserList userInfo = UserList();
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
                                child: userInfo.UserImage(userID!))),
                        Container(
                          height: 10,
                        ),
                        userInfo.UserName(userID!),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                                height: 100,
                                child: FutureBuilder<int>(
                                  future: bookService.readUserBooksCount(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Text(
                                            'К-ть книг:',
                                            style: TextStyle(
                                                color: AppTheme.textColor),
                                          ),
                                          Text(
                                            snapshot.data.toString(),
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text("Error: ${snapshot.error}");
                                    } else {
                                      return CircularProgressIndicator();
                                    }
                                  },
                                )),
                            SizedBox(
                                height: 100,
                                child: FutureBuilder<int>(
                                  future: reviewService
                                      .readUserReviewsCount(userID),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Text(
                                            'Рецензій:',
                                            style: TextStyle(
                                                color: AppTheme.textColor),
                                          ),
                                          Text(
                                            snapshot.data.toString(),
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text("Error: ${snapshot.error}");
                                    } else {
                                      return CircularProgressIndicator();
                                    }
                                  },
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
