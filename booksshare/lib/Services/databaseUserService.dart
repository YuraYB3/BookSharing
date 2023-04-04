// ignore_for_file: file_names
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../Models/userModel.dart';

class DatabaseUserService {
  final String? uid;

  DatabaseUserService({required this.uid});

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future updateUserData(String name, int age, String password, String email,
      XFile imageURL) async {
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
          'userPassword': password,
          'userImage': imgURL
        });
      } catch (e) {}
    } else {
      return await usersCollection.doc(uid).set({
        'name': name,
        'userAge': age,
        'userEmail': email,
        'uid': uid,
        'userPassword': password,
        'userImage':
            'https://firebasestorage.googleapis.com/v0/b/bookshare-bd71e.appspot.com/o/userProfileImages%2F1680538512167420IMG_20230403_191352_347.jpg?alt=media&token=c283712e-8ad6-4dc4-b273-ad850bed9bf4'
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
          userPassword: doc.get('userPassword'),
          userImage: doc.get('userImage'));
    }).toList();
  }

  Stream<List<UserModel>?> get users {
    return usersCollection.snapshots().map(_userListFromSnapshot);
  }
}
 /*if (file != null) {
      String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();
      uniqueFileName += file.name;
      Reference reference = FirebaseStorage.instance.ref();
      Reference referenceDirImages = reference.child('book_covers');
      Reference referenceImagesToUpload =
          referenceDirImages.child(uniqueFileName);
      try {
        await referenceImagesToUpload.putFile(File(file.path));
        imageURL = await referenceImagesToUpload.getDownloadURL();
        await newDocRef.set({
          'name': name,
          'title': title,
          "userID": documnetID,
          "bookID": newDocRef.id,
          "available": 'yes',
          'cover': imageURL,
          'description': description
        });
        Fluttertoast.showToast(
          msg: 'Book added successfully!',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'Book not added!',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 187, 38, 38),
          textColor: Colors.white,
        );
      }
    } else {
      // ignore: avoid_print
      print('Some Error');
    }*/