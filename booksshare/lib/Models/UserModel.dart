// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? name;
  final String? surname;
  final String? email;
  final String? uid;

  UserModel({this.uid, this.name, this.surname, this.email});

  toJson() {
    return {"name": name, "surname": surname, "email": email};
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
        name: data['name'], email: data['email'], surname: data['surname']);
  }
}
