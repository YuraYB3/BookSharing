// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SwapRequestService {
  Future<void> addBookSwapRequest(
      String? senderID, String receiverID, String desiredBookID) async {
    final CollectionReference bookSwapRequestCollection =
        FirebaseFirestore.instance.collection('notification');

    // Query the collection for existing requests with the same senderID, receiverID, and desiredBookID.
    final existingRequests = await bookSwapRequestCollection
        .where('senderID', isEqualTo: senderID)
        .where('receiverID', isEqualTo: receiverID)
        .where('desiredBookID', isEqualTo: desiredBookID)
        .where('notificationType', isEqualTo: 'Swap')
        .get();

    // If there is at least one existing request, notify the user and return without executing the request.
    if (existingRequests.docs.isNotEmpty) {
      Fluttertoast.showToast(
        msg: 'You have already sent a request for this book.',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }
    // Otherwise, execute the request and notify the user.
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
      // Handle any errors that occur during the request.
    }
  }

  Future<void> updateData(String swapReqID, String bookID) async {
    final CollectionReference swapReqRef =
        FirebaseFirestore.instance.collection('notification');
    final DocumentReference swapReqDocRef = swapReqRef.doc(swapReqID);
    final CollectionReference bookRef =
        FirebaseFirestore.instance.collection('books');
    final DocumentReference bookDocRef = bookRef.doc(bookID);

    try {
      await swapReqDocRef.update({'seenByReceiver': true});
    } catch (e) {}

    try {
      await bookDocRef.update({'available': 'no'});
    } catch (e) {}
  }

  Future<void> deleteData(String swapReqID) async {
    final CollectionReference swapReqRef =
        FirebaseFirestore.instance.collection('notification');
    final DocumentReference swapReqDocRef = swapReqRef.doc(swapReqID);

    try {
      await swapReqDocRef.delete();
    } catch (e) {}
  }
}
