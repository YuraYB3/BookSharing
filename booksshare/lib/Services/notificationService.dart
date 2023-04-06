// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/notificationModel.dart';

class NotificationService {
  final String? receiverID;
  final CollectionReference bookSwapRequestCollection =
      FirebaseFirestore.instance.collection('swapRequest');

  NotificationService({required this.receiverID});

  // Get the number of new swap requests for the receiver.
  Future<int> getNewRequestCount() async {
    final querySnapshot = await bookSwapRequestCollection
        .where('receiverID', isEqualTo: receiverID)
        .get();
    return querySnapshot.docs.length;
  }

  // Get a list of new swap requests for the receiver.

  Stream<List<NotificationModel>> getNewRequests() => FirebaseFirestore.instance
      .collection('swapRequest')
      .where("receiverID", isEqualTo: receiverID)
      .where('seenByReceiver', isEqualTo: false)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => NotificationModel.fromJson(doc.data()))
          .toList());

  // Mark a swap request as seen by the receiver.
  Future<void> markRequestAsSeen(String requestID) async {
    final requestRef = bookSwapRequestCollection.doc(requestID);
    await requestRef.update({'seenByReceiver': true});
  }
}
