// ignore_for_file: file_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Models/notificationModel.dart';

class NotificationService {
  final CollectionReference bookSwapRequestCollection =
      FirebaseFirestore.instance.collection('notification');

  Future<int> getNewRequestCount(String receiverID) async {
    final querySnapshot = await bookSwapRequestCollection
        .where('receiverID', isEqualTo: receiverID)
        .where('seenByReceiver', isEqualTo: false)
        .get();
    return querySnapshot.docs.length;
  }

  Stream<List<NotificationModel>> getNewRequests(String receiverID) =>
      FirebaseFirestore.instance
          .collection('notification')
          .where("receiverID", isEqualTo: receiverID)
          .where('seenByReceiver', isEqualTo: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => NotificationModel.fromJson(doc.data()))
              .toList());

  Future<void> updateSeenByReceiver(String notifyID) async {
    final CollectionReference swapReqRef =
        FirebaseFirestore.instance.collection('notification');
    final DocumentReference swapReqDocRef = swapReqRef.doc(notifyID);

    try {
      await swapReqDocRef.update({'seenByReceiver': true});
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Щось пішло не так',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 187, 38, 38),
        textColor: Colors.white,
      );
    }
  }

  Future<void> deleteData(String swapReqID) async {
    final CollectionReference swapReqRef =
        FirebaseFirestore.instance.collection('notification');
    final DocumentReference swapReqDocRef = swapReqRef.doc(swapReqID);

    try {
      await swapReqDocRef.delete();
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Щось пішло не так',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 187, 38, 38),
        textColor: Colors.white,
      );
    }
  }
}
