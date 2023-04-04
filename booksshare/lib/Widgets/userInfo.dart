// ignore_for_file: file_names

import 'package:booksshare/Shared/appTheme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserList {
  CollectionReference user = FirebaseFirestore.instance.collection("users");

  Widget UserInfo(String documnetID) {
    return FutureBuilder<DocumentSnapshot>(
      future: user.doc(documnetID).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text(
            "Something went wrong!",
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.start,
            textDirection: TextDirection.ltr,
          );
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text(
            "Document hasnt exist",
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.start,
            textDirection: TextDirection.ltr,
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Container(
            color: AppTheme.secondBackgroundColor,
            child: Center(
              child: Column(children: <Widget>[
                Stack(
                  children: [
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child:
                            Image.network(data['userImage'], fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "${data['name']}",
                  style: const TextStyle(color: AppTheme.textColor),
                ),
              ]),
            ),
          );
        }
        return const Text("");
      },
    );
  }

  Widget UserName(String documnetID) {
    return FutureBuilder<DocumentSnapshot>(
      future: user.doc(documnetID).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text(
            "Something went wrong!",
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.start,
            textDirection: TextDirection.ltr,
          );
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text(
            "Document hasnt exist",
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.start,
            textDirection: TextDirection.ltr,
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text("${data['name']}",
              style: const TextStyle(color: AppTheme.textColor));
        }
        return const Text("");
      },
    );
  }

  Widget UserImage(String documnetID) {
    return FutureBuilder<DocumentSnapshot>(
      future: user.doc(documnetID).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text(
            "Something went wrong!",
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.start,
            textDirection: TextDirection.ltr,
          );
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text(
            "Document hasnt exist",
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.start,
            textDirection: TextDirection.ltr,
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Image.network(data['userImage'], fit: BoxFit.cover);
        }
        return const Text("");
      },
    );
  }
}
