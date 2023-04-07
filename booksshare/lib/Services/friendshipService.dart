import 'package:cloud_firestore/cloud_firestore.dart';

class FriendshipService {
  final CollectionReference bookSwapCollection =
      FirebaseFirestore.instance.collection('friendship');
  Future<void> addFriendship(String? senderID, String receiverID) async {
    final newFriendshipRef = bookSwapCollection.doc();
    try {
      await newFriendshipRef.set({
        'friendshipID': newFriendshipRef.id,
        'senderID': senderID,
        'receiverID': receiverID,
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
