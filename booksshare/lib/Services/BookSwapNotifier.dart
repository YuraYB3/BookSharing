import 'package:cloud_firestore/cloud_firestore.dart';

class BookSwapNotifier {
  final String? receiverID;
  final CollectionReference bookSwapRequestCollection =
      FirebaseFirestore.instance.collection('swapRequest');

  BookSwapNotifier({required this.receiverID});

  // Get the number of new swap requests for the receiver.
  Future<int> getNewRequestCount() async {
    final querySnapshot = await bookSwapRequestCollection
        .where('receiverID', isEqualTo: receiverID)
        .where('seenByReceiver', isEqualTo: false)
        .get();
    return querySnapshot.docs.length;
  }

  // Get a list of new swap requests for the receiver.
  Future<List<DocumentSnapshot>> getNewRequests() async {
    final querySnapshot = await bookSwapRequestCollection
        .where('receiverID', isEqualTo: receiverID)
        .where('seenByReceiver', isEqualTo: false)
        .get();
    return querySnapshot.docs;
  }

  // Mark a swap request as seen by the receiver.
  Future<void> markRequestAsSeen(String requestID) async {
    final requestRef = bookSwapRequestCollection.doc(requestID);
    await requestRef.update({'seenByReceiver': true});
  }
}
