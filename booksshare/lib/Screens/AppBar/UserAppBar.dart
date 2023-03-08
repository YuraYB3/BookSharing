// ignore_for_file: file_names

import 'package:booksshare/Screens/AppBar/NotifyIcon.dart';
import 'package:flutter/material.dart';

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
            /* const snackBar = SnackBar(content: Text('Search tapped'));

            ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
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
                onPressed: () {},
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
