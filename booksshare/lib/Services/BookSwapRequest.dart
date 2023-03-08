import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BookSwapRequest {
  Future<void> addBookSwapRequest(
      String? senderID, String receiverID, String desiredBookID) async {
    final CollectionReference bookSwapRequestCollection =
        FirebaseFirestore.instance.collection('swapRequest');

    // Query the collection for existing requests with the same senderID, receiverID, and desiredBookID.
    final existingRequests = await bookSwapRequestCollection
        .where('senderID', isEqualTo: senderID)
        .where('receiverID', isEqualTo: receiverID)
        .where('desiredBookID', isEqualTo: desiredBookID)
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
        'senderID': senderID,
        'receiverID': receiverID,
        'desiredBookID': desiredBookID,
        'seenByReceiver': false,
        "message": 'I want to swap book!!!!'
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
}
