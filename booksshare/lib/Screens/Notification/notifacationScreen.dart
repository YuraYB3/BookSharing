// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Models/notificationModel.dart';
import '../../Services/authService.dart';
import '../../Services/friendshipService.dart';
import '../../Services/notificationService.dart';
import '../../Services/swapRequestService.dart';
import '../../Services/bookSwapService.dart';
import '../../Shared/appTheme.dart';
import '../../Widgets/AppBar/userAppBar.dart';
import '../../Widgets/Panel/userPanel.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  UserAppBar userAppBar = UserAppBar();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    var userID = _authService.getUserID();
    CollectionReference user = FirebaseFirestore.instance.collection("users");
    NotificationService bookSwapNotifier =
        NotificationService(receiverID: userID);
    return Scaffold(
        appBar: userAppBar.headerBar(context),
        backgroundColor: AppTheme.backgroundColor,
        body: StreamBuilder<List<NotificationModel>>(
            stream: bookSwapNotifier.getNewRequests(),
            builder: (BuildContext context,
                AsyncSnapshot<List<NotificationModel>> snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Center(
                      child: Text(
                        'У вас немає сповіщеннь',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.secondBackgroundColor),
                      ),
                    )
                  ],
                );
              }
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
                              Map<String, dynamic> userdata = userSnapshot.data!
                                  .data() as Map<String, dynamic>;
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 100,
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, left: 10, right: 10),
                                        child: notificationCard(userdata,
                                            notify, bookSwapNotifier)),
                                  )
                                ],
                              );
                            } else {
                              return Container();
                            }
                          });
                    }
                    return null;
                  });
            }),
        drawer: UserPanel());
  }

  Widget notificationCard(Map<String, dynamic> userdata,
      NotificationModel notify, NotificationService bookSwapNotifier) {
    if (notify.notificationType == 'Swap' && notify.seenByReceiver == false) {
      return swapCard(notify, userdata, bookSwapNotifier);
    }

    if (notify.notificationType == 'Friendship') {
      return friendshipCard(notify, userdata, bookSwapNotifier);
    }
    if (notify.notificationType == 'Reminder') {
      return remindCard(userdata);
    } else {
      return Container();
    }
  }

  Widget swapCard(NotificationModel notify, Map<String, dynamic> userdata,
      NotificationService bookSwapNotifier) {
    BookSwapService bookSwap = BookSwapService();
    SwapRequestService bookSwapRequest = SwapRequestService();
    CollectionReference book = FirebaseFirestore.instance.collection("books");
    return FutureBuilder<DocumentSnapshot>(
        future: book.doc(notify.desiredBookID).get(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot> bookSnapshot) {
          if (bookSnapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> bookdata =
                bookSnapshot.data!.data() as Map<String, dynamic>;
            return Card(
                shadowColor: Colors.blueGrey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Користувач: ${userdata['name']}"),
                          const Text("Хоче взяти від вас книгу:"),
                          Text(bookdata['name'].toString()),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () async {
                            bookSwap.addBookSwap(
                                notify.notificationID,
                                notify.senderID,
                                notify.receiverID,
                                notify.desiredBookID!);
                            bookSwapRequest
                                .updateBookAvalaible(notify.desiredBookID!);
                            bookSwapNotifier
                                .updateSeenByReceiver(notify.notificationID);
                          },
                          icon: const Icon(
                            Icons.done,
                            color: Colors.green,
                            size: 20,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            bookSwapNotifier.deleteData(notify.notificationID);
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      ],
                    )
                  ],
                ));
          }
          return Container();
        });
  }

  Widget friendshipCard(NotificationModel notify, Map<String, dynamic> userdata,
      NotificationService bookSwapNotifier) {
    FriendshipService friendshipService = FriendshipService();
    return Card(
        shadowColor: Colors.blueGrey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Користувач: ${userdata['name']}"),
                  const Text("Хоче стати вашим другом:"),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    friendshipService.addFriendship(
                        notify.senderID, notify.receiverID);
                    bookSwapNotifier
                        .updateSeenByReceiver(notify.notificationID);
                  },
                  icon: const Icon(
                    Icons.done,
                    color: Colors.green,
                    size: 20,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    bookSwapNotifier.deleteData(notify.notificationID);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
              ],
            )
          ],
        ));
  }

  Widget remindCard(Map<String, dynamic> userdata) {
    return Card(
        shadowColor: Colors.blueGrey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Користувач: ${userdata['name']}"),
                  const Text("Нагадує вам про книгу:"),
                  const Text(''),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {},
                  icon: const Icon(
                    Icons.done,
                    color: Colors.green,
                    size: 20,
                  ),
                ),
                IconButton(
                  onPressed: () async {},
                  icon: const Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
