// ignore_for_file: file_names

import 'package:booksshare/Widgets/userBooksList.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../../Models/userModel.dart';
import '../../Services/authService.dart';
import '../../Services/bookService.dart';
import '../../Services/databaseUserService.dart';
import '../../Services/friendshipRequestService.dart';
import '../../Services/friendshipService.dart';
import '../../Services/reviewService.dart';
import '../../Shared/appTheme.dart';
import '../../Widgets/AppBar/userAppBar.dart';
import '../../Widgets/Panel/userPanel.dart';
import '../../Widgets/Review/userReviews.dart';
import '../../Widgets/userInfo.dart';

class UserProfile extends StatefulWidget {
  final String userID;
  const UserProfile({super.key, required this.userID});

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
    UserInformation userInfo = UserInformation();
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
                                child: userInfo.userImage(widget.userID))),
                        Container(
                          height: 10,
                        ),
                        userInfo.userName(widget.userID),
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
                                          ElevatedButton(
                                            onPressed: () async {
                                              if (snapshot.data! > 0) {
                                                UserBooksList userBooksList =
                                                    UserBooksList();
                                                BookService bookService =
                                                    BookService(widget.userID);
                                                userBooksList
                                                    .listOfBooks(bookService);
                                                showMaterialModalBottomSheet(
                                                    bounce: true,
                                                    context: context,
                                                    enableDrag: true,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Container(
                                                        height: 550,
                                                        color: AppTheme
                                                            .secondBackgroundColor,
                                                        child: userBooksList
                                                            .listOfBooks(
                                                                bookService),
                                                      );
                                                    });
                                              } else {
                                                showMaterialModalBottomSheet(
                                                    bounce: true,
                                                    context: context,
                                                    enableDrag: true,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Container(
                                                          height: 550,
                                                          color: AppTheme
                                                              .secondBackgroundColor,
                                                          child: const Center(
                                                            child: Text(
                                                              'У користувача немає книг!',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                  fontSize: 22),
                                                            ),
                                                          ));
                                                    });
                                              }
                                            },
                                            style: ButtonStyle(
                                              foregroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                AppTheme.textColor,
                                              ),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                AppTheme.secondBackgroundColor,
                                              ),
                                            ),
                                            child: Text(
                                              snapshot.data.toString(),
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
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
                                          ElevatedButton(
                                            onPressed: () async {
                                              showMaterialModalBottomSheet(
                                                  bounce: true,
                                                  context: context,
                                                  enableDrag: true,
                                                  builder:
                                                      (BuildContext context) {
                                                    return UserReviews(
                                                        userID: widget.userID);
                                                  });
                                            },
                                            style: ButtonStyle(
                                              foregroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                AppTheme.textColor,
                                              ),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                AppTheme.secondBackgroundColor,
                                              ),
                                            ),
                                            child: Text(
                                              snapshot.data.toString(),
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
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
                                        child: const Text('Надіслати запит'),
                                      ))
                                    : Container())
                            : Container()
                      ],
                    ),
                  ),
                ),
              ],
            ),
            drawer: currentUser == widget.userID ? UserPanel() : null));
  }
}
