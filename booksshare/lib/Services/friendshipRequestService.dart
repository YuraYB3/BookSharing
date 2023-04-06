import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FrienshipRequestService {
  Future<void> addFriendshipRequest(String? senderID, String receiverID) async {
    final CollectionReference friendshipRequestCollection =
        FirebaseFirestore.instance.collection('notification');

    // Query the collection for existing requests with the same senderID, receiverID, and desiredBookID.
    final existingRequests = await friendshipRequestCollection
        .where('senderID', isEqualTo: senderID)
        .where('receiverID', isEqualTo: receiverID)
        .where('notificationType', isEqualTo: 'Friendship')
        .get();

    // If there is at least one existing request, notify the user and return without executing the request.
    if (existingRequests.docs.isNotEmpty) {
      Fluttertoast.showToast(
        msg: 'You have already sent a request for friendship',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }
    // Otherwise, execute the request and notify the user.
    final newSwapReqRef = friendshipRequestCollection.doc();
    try {
      await newSwapReqRef.set({
        'swapReqID': newSwapReqRef.id,
        'senderID': senderID,
        'receiverID': receiverID,
        'seenByReceiver': false,
        "message": 'I want to be your friend!!!',
        'notificationType': 'Friendship',
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
