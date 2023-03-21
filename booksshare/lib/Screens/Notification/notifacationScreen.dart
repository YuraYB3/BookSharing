// ignore_for_file: file_names

import 'package:booksshare/Models/BookSwapRequestModel.dart';
import 'package:booksshare/Screens/AppBar/userAppBar.dart';
import 'package:booksshare/Services/Auth.dart';
import 'package:booksshare/Services/BookSwap.dart';
import 'package:booksshare/Services/BookSwapNotifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/userModel.dart';
import '../../Services/BookSwapRequest.dart';
import '../../Services/DatabaseUser.dart';
import '../Panel/UserPanel.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  UserAppBar userAppBar = UserAppBar();
  AuthService _authService = AuthService();
  BookSwap bookSwap = BookSwap();
  BookSwapRequest b = BookSwapRequest();

  @override
  Widget build(BuildContext context) {
    var userID = _authService.getUserID();
    CollectionReference user = FirebaseFirestore.instance.collection("users");
    BookSwapNotifier bookSwapNotifier = BookSwapNotifier(receiverID: userID);
    CollectionReference book = FirebaseFirestore.instance.collection("books");
    return Scaffold(
        appBar: userAppBar.headerBar(context),
        backgroundColor: Colors.white,
        body: StreamBuilder<List<BookSwapRequestModel>>(
            stream: bookSwapNotifier.getNewRequests(),
            builder: (BuildContext context,
                AsyncSnapshot<List<BookSwapRequestModel>> snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              if (snapshot.hasData) {
                final notificationData = snapshot.data!;
                return ListView.builder(
                    itemCount: notificationData.length,
                    itemBuilder: (context, index) {
                      final notify = notificationData[index];
                      if (notify.seenByReceiver == false) {
                        return FutureBuilder<DocumentSnapshot>(
                            future: user.doc(notify.senderID).get(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                              if (userSnapshot.connectionState ==
                                  ConnectionState.done) {
                                Map<String, dynamic> userdata =
                                    userSnapshot.data!.data()
                                        as Map<String, dynamic>;

                                return FutureBuilder<DocumentSnapshot>(
                                    future:
                                        book.doc(notify.desiredBookID).get(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<DocumentSnapshot>
                                            bookSnapshot) {
                                      if (bookSnapshot.connectionState ==
                                          ConnectionState.done) {
                                        Map<String, dynamic> bookdata =
                                            bookSnapshot.data!.data()
                                                as Map<String, dynamic>;
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 100,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0,
                                                    left: 10,
                                                    right: 10),
                                                child: Card(
                                                    shadowColor:
                                                        Colors.blueGrey,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            left: 10,
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  "Користувач: ${userdata['name']}"),
                                                              const Text(
                                                                  "Хоче взяти від вас книгу:"),
                                                              Text(bookdata[
                                                                      'name']
                                                                  .toString()),
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            IconButton(
                                                              onPressed:
                                                                  () async {
                                                                bookSwap.addBookSwap(
                                                                    notify
                                                                        .swapReqID,
                                                                    notify
                                                                        .senderID,
                                                                    notify
                                                                        .receiverID,
                                                                    notify
                                                                        .desiredBookID);
                                                                b.updateData(notify
                                                                    .swapReqID);
                                                              },
                                                              icon: const Icon(
                                                                Icons.done,
                                                                color: Colors
                                                                    .green,
                                                                size: 20,
                                                              ),
                                                            ),
                                                            IconButton(
                                                              onPressed:
                                                                  () async {
                                                                b.deleteData(notify
                                                                    .swapReqID);
                                                              },
                                                              icon: const Icon(
                                                                Icons.close,
                                                                color:
                                                                    Colors.red,
                                                                size: 20,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    )),
                                              ),
                                            )
                                          ],
                                        );
                                      } else {
                                        return Container();
                                      }
                                    });
                              } else {
                                return Container();
                              }
                            });
                      } else {
                        return Container();
                      }
                    });
              } else {
                return Container();
              }
            }),
        drawer: UserPanel());
  }
}
/* Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 60,
                  child: Card(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Користувач: апава"),
                            Text("Хоче взяти від вас книгу: авапа"),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.done,
                              color: Colors.green,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
                )
              ],
            ),*/