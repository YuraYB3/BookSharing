import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ReminderService {
  Future<void> sendBookReminder(
      String? senderID, String receiverID, String desiredBookID) async {
    final CollectionReference notificationCollection =
        FirebaseFirestore.instance.collection('notification');

    final existingRequests = await notificationCollection
        .where('senderID', isEqualTo: receiverID)
        .where('receiverID', isEqualTo: senderID)
        .where('desiredBookID', isEqualTo: desiredBookID)
        .where('notificationType', isEqualTo: 'Reminder')
        .where(
          'seenByReceiver',
          isEqualTo: false,
        )
        .get();

    if (existingRequests.docs.isNotEmpty) {
      Fluttertoast.showToast(
        msg: 'Ви вже нагадували про книгу!',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }
    final newSwapReqRef = notificationCollection.doc();
    try {
      await newSwapReqRef.set({
        'swapReqID': newSwapReqRef.id,
        'senderID': receiverID,
        'receiverID': senderID,
        'desiredBookID': desiredBookID,
        'seenByReceiver': false,
        'notificationType': 'Reminder'
      });
      Fluttertoast.showToast(
        msg: 'Нагадування відправлено!',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      print(e.toString());
    }
  }
}
