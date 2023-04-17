// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Shared/appTheme.dart';

class UserInformation {
  CollectionReference user = FirebaseFirestore.instance.collection("users");

  Widget userInfo(String documnetID) {
    return FutureBuilder<DocumentSnapshot>(
      future: user.doc(documnetID).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              "Щось пішло не так :(",
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.start,
              textDirection: TextDirection.ltr,
              overflow: TextOverflow.clip,
            ),
          );
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text(
            "Користувача не існує :(",
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.start,
            textDirection: TextDirection.ltr,
            overflow: TextOverflow.clip,
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

  Widget userName(String documnetID) {
    return FutureBuilder<DocumentSnapshot>(
      future: user.doc(documnetID).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              "Щось пішло не так :(",
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.start,
              textDirection: TextDirection.ltr,
              overflow: TextOverflow.clip,
            ),
          );
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text(
            "Користувача не існує :(",
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.start,
            textDirection: TextDirection.ltr,
            overflow: TextOverflow.clip,
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;
        return Text("${data['name']}",
            style: const TextStyle(color: AppTheme.textColor));
      },
    );
  }

  Widget userNameBlack(String documnetID) {
    return FutureBuilder<DocumentSnapshot>(
      future: user.doc(documnetID).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              "Щось пішло не так :(",
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.start,
              textDirection: TextDirection.ltr,
              overflow: TextOverflow.clip,
            ),
          );
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text(
            "Користувача не існує :(",
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.start,
            textDirection: TextDirection.ltr,
            overflow: TextOverflow.clip,
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text("${data['name']}",
              style: const TextStyle(color: Colors.black));
        }
        return const Text("");
      },
    );
  }

  Widget userImage(String documnetID) {
    return FutureBuilder<DocumentSnapshot>(
      future: user.doc(documnetID).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              "Щось пішло не так :(",
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.start,
              textDirection: TextDirection.ltr,
              overflow: TextOverflow.clip,
            ),
          );
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text(
            "Користувача не існує :(",
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.start,
            textDirection: TextDirection.ltr,
            overflow: TextOverflow.clip,
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
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
