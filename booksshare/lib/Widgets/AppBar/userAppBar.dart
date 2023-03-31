import 'package:flutter/material.dart';

import 'notifyIcon.dart';

class UserAppBar {
  NotifyIcon notifyIcon = NotifyIcon();
  AppBar headerBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      toolbarHeight: 80,
      backgroundColor: const Color(0xff008787),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            Navigator.pushNamed(context, '/search');
          },
        ),
        FutureBuilder(
          future: NotifyIcon().GetNotifyIcon(context),
          builder: (BuildContext context, AsyncSnapshot<IconButton> snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!;
            } else {
              return IconButton(
                icon: const Icon(Icons.notifications_off_rounded),
                onPressed: () {
                  print("WORKED?");
                },
              );
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.account_circle_outlined),
          onPressed: () {
            Navigator.pushNamed(context, '/profile');
          },
        ), //IconButton
      ],
    );
  }
}
