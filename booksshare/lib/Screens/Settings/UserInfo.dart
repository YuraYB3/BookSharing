// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserList extends StatelessWidget {
  final String documnetID;
  const UserList(this.documnetID, {super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference user = FirebaseFirestore.instance.collection("users");

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
          return Row(children: <Widget>[
            const Icon(
              Icons.person,
              color: Colors.white,
            ),
            Text(
              "${data['name']} ${data['surname']}",
              style: const TextStyle(color: Colors.white),
            ),
          ]);
        }
        return const Text("");
      },
    );
  }
}
