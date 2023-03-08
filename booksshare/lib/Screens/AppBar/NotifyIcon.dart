import 'package:booksshare/Services/Auth.dart';
import 'package:booksshare/Services/BookSwapNotifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotifyIcon {
  Future<IconButton> GetNotifyIcon(BuildContext context) async {
    AuthService authService = AuthService();
    var userID = authService.getUserID();
    BookSwapNotifier bookSwapNotifier = BookSwapNotifier(receiverID: userID);
    final requestCount = await bookSwapNotifier.getNewRequestCount();
    if (requestCount != 0) {
      return IconButton(
        icon: const Icon(Icons.notification_important),
        onPressed: () {
          const snackBar = SnackBar(content: Text('Notify tapped'));

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.notifications_rounded),
        onPressed: () {
          const snackBar = SnackBar(content: Text('Notify tapped'));

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
      );
    }
  }
}
