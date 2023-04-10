// ignore_for_file: file_names
import 'package:booksshare/Services/authService.dart';
import 'package:booksshare/Services/bookService.dart';
import 'package:booksshare/Services/friendshipRequestService.dart';
import 'package:booksshare/Services/friendshipService.dart';
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
  String userID;
  UserProfile({required this.userID});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool _areFriends = false;
  UserAppBar userAppBar = UserAppBar();
  AuthService authService = AuthService();
  ReviewService reviewService = ReviewService();
  @override
  void initState() {
    super.initState();
    _checkIfFriends();
  }

  void _checkIfFriends() async {
    FriendshipService friendshipService = FriendshipService();
    bool areFriends = await friendshipService.areUsersFriends(widget.userID);
    setState(() {
      _areFriends = areFriends;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserList userInfo = UserList();
    var currentUser = authService.getUserID();
    BookService bookService = BookService(widget.userID);
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
                    height: 300,
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
                            margin: const EdgeInsets.only(top: 15),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: userInfo.UserImage(widget.userID))),
                        Container(
                          height: 10,
                        ),
                        userInfo.UserName(widget.userID),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                                height: 100,
                                child: FutureBuilder<int>(
                                  future: bookService.readUserBooksCount(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator
                                            .adaptive(),
                                      );
                                    }
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
                                            style: const TextStyle(
                                                color: Colors.white),
                                          )
                                        ],
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text("Error: ${snapshot.error}");
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                )),
                            SizedBox(
                                height: 100,
                                child: FutureBuilder<int>(
                                  future: reviewService
                                      .readUserReviewsCount(widget.userID),
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
                                            style: const TextStyle(
                                                color: Colors.white),
                                          )
                                        ],
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text("Error: ${snapshot.error}");
                                    } else {
                                      return Container();
                                    }
                                  },
                                ))
                          ],
                        ),
                        currentUser != widget.userID
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: !_areFriends
                                    ? Center(
                                        child: ElevatedButton(
                                        onPressed: () async {
                                          FrienshipRequestService
                                              frienshipRequestService =
                                              FrienshipRequestService();
                                          frienshipRequestService
                                              .addFriendshipRequest(
                                                  currentUser, widget.userID);
                                        },
                                        style: const ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll<Color>(
                                                    AppTheme
                                                        .secondBackgroundColor)),
                                        child: const Text('Send request'),
                                      ))
                                    : Center(
                                        child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushReplacementNamed(
                                              context, '/messenger');
                                        },
                                        style: const ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll<Color>(
                                                    Color.fromARGB(
                                                        255, 208, 18, 18))),
                                        child: const Text('Message'),
                                      )))
                            : Container()
                      ],
                    ),
                  ),
                ),
              ],
            ),
            drawer: UserPanel()));
  }
}
