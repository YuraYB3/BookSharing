// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? userNickName;
  final String? userEmail;
  final String? userImage;
  final int? userAge;
  final String uid;
  final String? userToken;
  final bool? emailVerified;

  UserModel(
      {required this.uid,
      this.userNickName,
      this.userEmail,
      this.userAge,
      this.userImage,
      this.userToken,
      this.emailVerified});

  toJson() {
    return {
      "name": userNickName,
      "email": userEmail,
      'userImage': userImage,
      'userAge': userAge,
      'uid': uid,
      'userToken': userToken,
      'emailVerified': emailVerified
    };
  }

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
      userNickName: json['name'],
      userEmail: json['email'],
      userImage: json['userImage'],
      userAge: json['userAge'],
      uid: json['uid'],
      userToken: json['userToken'],
      emailVerified: json['emailVerified']);
}
