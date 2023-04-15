// ignore_for_file: file_names

class MessageModel {
  final String message;
  final String senderID;
  final DateTime sendTime;

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
