import 'package:booksshare/Shared/appTheme.dart';
import 'package:flutter/material.dart';

import '../../Services/authService.dart';
import '../../Services/notificationService.dart';

class NotifyIcon {
  Future<IconButton> GetNotifyIcon(BuildContext context) async {
    AuthService authService = AuthService();
    var userID = authService.getUserID();
    NotificationService bookSwapNotifier =
        NotificationService(receiverID: userID);
    final requestCount = await bookSwapNotifier.getNewRequestCount();
    if (requestCount != 0) {
      return IconButton(
        icon: const Icon(
          Icons.notification_important,
          color: AppTheme.iconColor,
        ),
        onPressed: () {
          const snackBar = SnackBar(content: Text('Has request'));
          Navigator.pushNamed(context, '/notification');
        },
      );
    } else {
      return IconButton(
        icon: const Icon(
          Icons.notifications_rounded,
          color: AppTheme.iconColor,
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/notification');
        },
      );
    }
  }
}
