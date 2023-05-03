// ignore_for_file: file_names

import 'package:booksshare/Services/authService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Models/friendshipModel.dart';

class FriendshipService {
  final CollectionReference friendshipCollection =
      FirebaseFirestore.instance.collection('friendship');
  Future<void> addFriendship(String? senderID, String receiverID) async {
    final newFriendshipRef = friendshipCollection.doc();
    try {
      await newFriendshipRef.set({
        'friendshipID': newFriendshipRef.id,
        'user1_ID': senderID,
        'user2_ID': receiverID,
      });
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future<List<FriendshipModel>> getUserFriends(String userID) async {
    final friendsQuery = FirebaseFirestore.instance
        .collection('friendship')
        .where('user1_ID', isEqualTo: userID)
        .get()
        .then((querySnapshot) => querySnapshot.docs
            .map((doc) => FriendshipModel.fromJson(doc.data()))
            .toList());
    final otherFriendsQuery = FirebaseFirestore.instance
        .collection('friendship')
        .where('user2_ID', isEqualTo: userID)
        .get()
        .then((querySnapshot) => querySnapshot.docs
            .map((doc) => FriendshipModel.fromJson(doc.data()))
            .toList());
    final friends = await Future.wait([friendsQuery, otherFriendsQuery]);
    return friends.expand((i) => i).toList();
  }

  Future<bool> areUsersFriends(String userID_1) async {
    AuthService authService = AuthService();
    var userID_2 = authService.getUserID();
    final firstQuery = FirebaseFirestore.instance
        .collection('friendship')
        .where('user1_ID', isEqualTo: userID_1)
        .where('user2_ID', isEqualTo: userID_2)
        .get();

    final secondQuery = FirebaseFirestore.instance
        .collection('friendship')
        .where('user1_ID', isEqualTo: userID_2)
        .where('user2_ID', isEqualTo: userID_1)
        .get();

    final queryResults = await Future.wait([firstQuery, secondQuery]);

    return queryResults.any((querySnapshot) => querySnapshot.docs.isNotEmpty);
  }
}
