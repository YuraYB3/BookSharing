import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  Future<void> addBookSwap(
      String bookID, String userID, String review, double rating) async {
    final CollectionReference reviewCollection =
        FirebaseFirestore.instance.collection('review');
    final newReviewRef = reviewCollection.doc();
    try {
      await newReviewRef.set({
        'bookID': bookID,
        'userID': userID,
        'review': review,
        'rating': rating
      });
    } catch (e) {}
  }
}
