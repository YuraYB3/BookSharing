// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

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
      // ignore: avoid_print
      print(e.toString());
    }
  }
}
