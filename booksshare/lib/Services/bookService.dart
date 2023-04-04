// ignore_for_file: file_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../Models/bookModel.dart';

class BookService {
  final String? documnetID;

  const BookService(this.documnetID);
  Stream<List<BookModel>> readUserBooks() => FirebaseFirestore.instance
      .collection('books')
      .where('userID', isEqualTo: documnetID)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => BookModel.fromJson(doc.data())).toList());
  Stream<List<BookModel>> readAllUsersBooks() => FirebaseFirestore.instance
      .collection('books')
      .where('userID', isNotEqualTo: documnetID)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => BookModel.fromJson(doc.data())).toList());

  Future<void> addBooks(
      String name, String title, XFile file, String description) async {
    String imageURL = '';
    final CollectionReference booksCollection =
        FirebaseFirestore.instance.collection('books');
    final newDocRef = booksCollection.doc();
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
    }
  }

  Future<int> readUserBooksCount() async {
    var querySnapsnot = await FirebaseFirestore.instance
        .collection('books')
        .where('userID', isEqualTo: documnetID)
        .get();
    return querySnapsnot.docs.length;
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
