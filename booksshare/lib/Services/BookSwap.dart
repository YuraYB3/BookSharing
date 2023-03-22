// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/BookSwapModel.dart';

class BookSwap {
  final CollectionReference bookSwapCollection =
      FirebaseFirestore.instance.collection('bookSwap');
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
    } catch (e) {}
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
}
