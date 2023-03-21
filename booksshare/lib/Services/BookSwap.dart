// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class BookSwap {
  Future<void> addBookSwap(String swapReqID, String? senderID,
      String receiverID, String desiredBookID) async {
    final CollectionReference bookSwapCollection =
        FirebaseFirestore.instance.collection('bookSwap');
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
      print(e);
    }
  }
}
