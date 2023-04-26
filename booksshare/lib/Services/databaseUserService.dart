// ignore_for_file: file_names, avoid_print, unnecessary_brace_in_string_interps
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../Models/userModel.dart';

class DatabaseUserService {
  final String? uid = FirebaseAuth.instance.currentUser!.uid;

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future updateUserData(
      String name, int age, String email, XFile imageURL) async {
    final userToken = await FirebaseMessaging.instance.getToken();
    // ignore: unnecessary_null_comparison
    if (imageURL != null) {
      String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();
      uniqueFileName += imageURL.name;
      Reference reference = FirebaseStorage.instance.ref();
      Reference referenceDirImages = reference.child('userProfileImages');
      Reference referenceImagesToUpload =
          referenceDirImages.child(uniqueFileName);
      try {
        await referenceImagesToUpload.putFile(File(imageURL.path));
        var imgURL = await referenceImagesToUpload.getDownloadURL();
        return await usersCollection.doc(uid).set({
          'name': name,
          'userAge': age,
          'userEmail': email,
          'uid': uid,
          'userImage': imgURL,
          'userToken': userToken,
          'emailVerified': false
        });
      } catch (e) {
        print(e.toString());
      }
    } else {
      return await usersCollection.doc(uid).set({
        'name': name,
        'userAge': age,
        'userEmail': email,
        'uid': uid,
        'userImage':
            'https://firebasestorage.googleapis.com/v0/b/bookshare-bd71e.appspot.com/o/userProfileImages%2F1680538512167420IMG_20230403_191352_347.jpg?alt=media&token=c283712e-8ad6-4dc4-b273-ad850bed9bf4',
        'userToken': userToken
      });
    }
  }

  List<UserModel>? _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserModel(
          userNickName: doc.get('name') ?? "",
          uid: doc.get('uid'),
          userAge: doc.get('userAge'),
          userEmail: doc.get('userEmail'),
          userImage: doc.get('userImage'));
    }).toList();
  }

  Stream<List<UserModel>?> get users {
    return usersCollection.snapshots().map(_userListFromSnapshot);
  }

  Stream<List<UserModel>> readAllUsers() => FirebaseFirestore.instance
      .collection('users')
      .where('uid', isNotEqualTo: uid)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList());

  Stream<List<UserModel>> readUser(String userID) => FirebaseFirestore.instance
      .collection('users')
      .where('uid', isEqualTo: userID)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList());

  Future<void> updateToken() async {
    final userToken = await FirebaseMessaging.instance.getToken();
    final CollectionReference swapReqRef =
        FirebaseFirestore.instance.collection('users');
    final DocumentReference userDocRef = swapReqRef.doc(uid);

    try {
      final docSnapshot = await userDocRef.get();
      final Map<String, dynamic>? data =
          docSnapshot.data() as Map<String, dynamic>?;
      final oldToken = data?['userToken'];
      if (data != null) {
        if (userToken != oldToken) {
          await userDocRef.update({'userToken': userToken});
          print("UPDATED");
        } else {
          print("NOT UPDATED");
        }
      }
    } catch (e) {
      print("error: ${e.toString()}");
      print("token: ${userToken}");
    }
  }

  Future<void> updateName(String newName) async {
    final CollectionReference swapReqRef =
        FirebaseFirestore.instance.collection('users');
    final DocumentReference userDocRef = swapReqRef.doc(uid);

    await userDocRef.update({'name': newName});
    print("UPDATED");
  }

  Future<void> updatePassword() async {
    final email = _getCurrentUserEmail();
    if (email != null) {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } else {
      Fluttertoast.showToast(
        msg: 'Проблеми з електронною адресою!',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 181, 25, 25),
        textColor: Colors.white,
      );
    }
  }

  String? _getCurrentUserEmail() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return currentUser.email;
    } else {
      return null;
    }
  }
}
