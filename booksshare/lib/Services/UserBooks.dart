// ignore_for_file: file_names

import 'package:booksshare/Models/BooksModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BookService {
  final String? documnetID;

  const BookService(this.documnetID);
  Stream<List<Books>> readUserBooks() => FirebaseFirestore.instance
      .collection('books')
      .where('userID', isEqualTo: documnetID)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Books.fromJson(doc.data())).toList());
  Stream<List<Books>> readAllUsersBooks() => FirebaseFirestore.instance
      .collection('books')
      .where('userID', isNotEqualTo: documnetID)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Books.fromJson(doc.data())).toList());

  Future<void> addBooks(String name, String title) async {
    String imageURL = '';
    final CollectionReference booksCollection =
        FirebaseFirestore.instance.collection('books');
    final newDocRef = booksCollection.doc();
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
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
    }
  }

  Future<void> deleteBook(String bookId) async {
    try {
      await FirebaseFirestore.instance.collection('books').doc(bookId).delete();
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }
}
