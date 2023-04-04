// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? userNickName;
  final String? userEmail;
  final String? userImage;
  final int? userAge;
  final String? userPassword;
  final String uid;

  UserModel(
      {required this.uid,
      this.userNickName,
      this.userEmail,
      this.userAge,
      this.userImage,
      this.userPassword});

  toJson() {
    return {
      "name": userNickName,
      "email": userEmail,
      'userImage': userImage,
      'userAge': userAge,
      'userPassword': userPassword,
      'uid': uid
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
        userNickName: data['name'],
        userEmail: data['email'],
        userImage: data['userImage'],
        userAge: data['userAge'],
        userPassword: data['userPassword'],
        uid: data['uid']);
  }
}
