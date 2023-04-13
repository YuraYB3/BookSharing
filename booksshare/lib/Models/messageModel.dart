// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String message;
  final String senderID;
  final Timestamp sendTime;

  MessageModel(
      {required this.message, required this.senderID, required this.sendTime});

  static MessageModel fromJson(Map<String, dynamic> json) => MessageModel(
        message: json['message'],
        senderID: json['senderID'],
        sendTime: json['sendTime'],
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'senderID': senderID,
        'sendTime': sendTime,
      };
}
