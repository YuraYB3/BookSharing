// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../Shared/appTheme.dart';
import 'notifyIcon.dart';

class UserAppBar {
  NotifyIcon notifyIcon = NotifyIcon();
  AppBar headerBar(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: AppTheme.iconColor),
      automaticallyImplyLeading: true,
      toolbarHeight: 80,
      backgroundColor: AppTheme.secondBackgroundColor,
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.search,
            color: AppTheme.iconColor,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/search');
          },
        ),
        FutureBuilder<IconButton>(
          future: NotifyIcon().getNotifyIcon(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return snapshot.data!;
            } else {
              return Container();
            }
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.account_circle_outlined,
            color: AppTheme.iconColor,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/profile');
          },
        ), //IconButton
      ],
    );
  }
}
