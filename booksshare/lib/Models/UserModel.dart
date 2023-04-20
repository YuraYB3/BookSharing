// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? userNickName;
  final String? userEmail;
  final String? userImage;
  final int? userAge;
  final String? userPassword;
  final String uid;
  final String? userToken;

  UserModel(
      {required this.uid,
      this.userNickName,
      this.userEmail,
      this.userAge,
      this.userImage,
      this.userPassword,
      this.userToken});

  toJson() {
    return {
      "name": userNickName,
      "email": userEmail,
      'userImage': userImage,
      'userAge': userAge,
      'userPassword': userPassword,
      'uid': uid,
      'userToken': userToken
    };
  }

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
      userNickName: json['name'],
      userEmail: json['email'],
      userImage: json['userImage'],
      userAge: json['userAge'],
      userPassword: json['userPassword'],
      uid: json['uid'],
      userToken: json['userToken']);
}
