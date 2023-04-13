// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FrienshipRequestService {
  Future<void> addFriendshipRequest(String? senderID, String receiverID) async {
    final CollectionReference friendshipRequestCollection =
        FirebaseFirestore.instance.collection('notification');

    final existingRequests = await friendshipRequestCollection
        .where('senderID', isEqualTo: senderID)
        .where('receiverID', isEqualTo: receiverID)
        .where('notificationType', isEqualTo: 'Friendship')
        .get();

    if (existingRequests.docs.isNotEmpty) {
      Fluttertoast.showToast(
        msg: 'You have already sent a request for friendship',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }
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
