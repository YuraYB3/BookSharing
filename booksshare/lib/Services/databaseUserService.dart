// ignore_for_file: file_names

import 'package:booksshare/Models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseUserService {
  final String? uid;

  DatabaseUserService({required this.uid});

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future updateUserData(String name, String surname, String email) async {
    return await usersCollection
        .doc(uid)
        .set({'name': name, 'surname': surname, 'email': email, 'userID': uid});
  }

  List<UserModel>? _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserModel(
          name: doc.get('name') ?? "", surname: doc.get('surname') ?? "");
    }).toList();
  }

  Stream<List<UserModel>?> get users {
    return usersCollection.snapshots().map(_userListFromSnapshot);
  }
}
