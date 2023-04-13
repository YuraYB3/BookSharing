// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../Services/authService.dart';
import '../../Services/notificationService.dart';
import '../../Shared/appTheme.dart';

class NotifyIcon {
  Future<IconButton> getNotifyIcon(BuildContext context) async {
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
