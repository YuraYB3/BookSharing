// ignore_for_file: file_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SwapRequestService {
  Future<void> addBookSwapRequest(
      String? senderID, String receiverID, String desiredBookID) async {
    final CollectionReference bookSwapRequestCollection =
        FirebaseFirestore.instance.collection('notification');

    final existingRequests = await bookSwapRequestCollection
        .where('senderID', isEqualTo: senderID)
        .where('receiverID', isEqualTo: receiverID)
        .where('desiredBookID', isEqualTo: desiredBookID)
        .where('notificationType', isEqualTo: 'Swap')
        .get();

    if (existingRequests.docs.isNotEmpty) {
      Fluttertoast.showToast(
        msg: 'You have already sent a request for this book.',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }
    final newSwapReqRef = bookSwapRequestCollection.doc();
    try {
      await newSwapReqRef.set({
        'swapReqID': newSwapReqRef.id,
        'senderID': senderID,
        'receiverID': receiverID,
        'desiredBookID': desiredBookID,
        'seenByReceiver': false,
        "message": 'I want to swap book!!!!',
        'notificationType': 'Swap'
      });
      Fluttertoast.showToast(
        msg: 'Request sent',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateBookAvalaible(String bookID) async {
    final CollectionReference bookRef =
        FirebaseFirestore.instance.collection('books');
    final DocumentReference bookDocRef = bookRef.doc(bookID);
    try {
      await bookDocRef.update({'available': 'no'});
    } catch (e) {
      print(e.toString());
    }
  }
}
