// ignore_for_file: file_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Models/reviewModel.dart';

class ReviewService {
  Future<void> addBookReview(
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
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Щось пішло не так',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 187, 38, 38),
        textColor: Colors.white,
      );
    }
  }

  Stream<List<ReviewModel>> readBookReviews(String bookID) =>
      FirebaseFirestore.instance
          .collection('review')
          .where('bookID', isEqualTo: bookID)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => ReviewModel.fromJson(doc.data()))
              .toList());

  Stream<List<ReviewModel>> readUserReviews(String userID) =>
      FirebaseFirestore.instance
          .collection('review')
          .where('userID', isEqualTo: userID)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => ReviewModel.fromJson(doc.data()))
              .toList());

  Future<int> readUserReviewsCount(String userID) async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('review')
        .where('userID', isEqualTo: userID)
        .get();
    return querySnapshot.docs.length;
  }
}
