import 'package:flutter/material.dart';

import '../../Services/authService.dart';
import '../../Services/bookSwapNotifierService.dart';

class NotifyIcon {
  Future<IconButton> GetNotifyIcon(BuildContext context) async {
    AuthService authService = AuthService();
    var userID = authService.getUserID();
    BookSwapNotifierService bookSwapNotifier =
        BookSwapNotifierService(receiverID: userID);
    final requestCount = await bookSwapNotifier.getNewRequestCount();
    if (requestCount != 0) {
      return IconButton(
        icon: const Icon(Icons.notification_important),
        onPressed: () {
          const snackBar = SnackBar(content: Text('Has request'));
          Navigator.pushNamed(context, '/notification');
        },
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.notifications_rounded),
        onPressed: () {
          Navigator.pushNamed(context, '/notification');
        },
      );
    }
  }
}
