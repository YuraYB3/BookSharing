// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MessageService {
  Future<void> sendMessage(
      String frienshipID, String message, String userID) async {
    final CollectionReference reviewCollection =
        FirebaseFirestore.instance.collection('message');
    final newReviewRef =
        reviewCollection.doc(frienshipID).collection('dialogue');
    try {
      await newReviewRef.doc().set({
        'message': message,
        'senderID': userID,
        'timeSend': FieldValue.serverTimestamp()
      });
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
