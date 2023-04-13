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
        FutureBuilder(
          future: NotifyIcon().getNotifyIcon(context),
          builder: (BuildContext context, AsyncSnapshot<IconButton> snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!;
            } else {
              return IconButton(
                icon: const Icon(
                  Icons.notifications_off_rounded,
                  color: AppTheme.iconColor,
                ),
                onPressed: () {},
              );
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
