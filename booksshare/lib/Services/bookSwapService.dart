// ignore_for_file: file_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Models/bookSwapModel.dart';

class BookSwapService {
  final CollectionReference bookSwapCollection =
      FirebaseFirestore.instance.collection('bookSwap');
  Future<void> addBookSwap(String swapReqID, String? senderID,
      String receiverID, String desiredBookID) async {
    final newSwapReqRef = bookSwapCollection.doc();
    try {
      await newSwapReqRef.set({
        'bookSwapID': newSwapReqRef.id,
        'swapReqID': swapReqID,
        'senderID': senderID,
        'receiverID': receiverID,
        'desiredBookID': desiredBookID,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<List<BookSwapModel>> getBookSwap(String user, String userID) {
    return FirebaseFirestore.instance
        .collection('bookSwap')
        .where(user, isEqualTo: userID)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BookSwapModel.fromJson(doc.data()))
            .toList());
  }

  Future<int> getBookSwapCount(String user, String userID) async {
    final querySnapshot =
        await bookSwapCollection.where(user, isEqualTo: userID).get();
    return querySnapshot.docs.length;
  }

  Future<void> returnBook(String swapReqID, String bookID) async {
    final CollectionReference bookRef =
        FirebaseFirestore.instance.collection('books');
    final DocumentReference bookDocRef = bookRef.doc(bookID);
    final CollectionReference bookSwapRef =
        FirebaseFirestore.instance.collection('bookSwap');
    final DocumentReference bookSwapDocRef = bookSwapRef.doc(swapReqID);
    try {
      await bookDocRef.update({'available': 'yes'});
      await bookSwapDocRef.delete();
      Fluttertoast.showToast(
        msg: 'Книгу повернуто!',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Щось пішло не так',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 187, 38, 38),
        textColor: Colors.white,
      );
    }
  }
}
