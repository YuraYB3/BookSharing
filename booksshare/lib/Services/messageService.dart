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
        'timeSend': Timestamp.now()
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
