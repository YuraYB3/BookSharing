// ignore_for_file: file_names

class NotificationModel {
  final String notificationID;
  final String senderID;
  final String receiverID;
  final String message;
  final String notificationType;
  final bool seenByReceiver;
  final String? desiredBookID;

  NotificationModel({
    required this.notificationID,
    required this.message,
    required this.receiverID,
    required this.senderID,
    required this.notificationType,
    required this.seenByReceiver,
    this.desiredBookID,
  });

  static NotificationModel fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        notificationID: json['swapReqID'],
        senderID: json['senderID'],
        receiverID: json['receiverID'],
        message: json['message'],
        notificationType: json['notificationType'],
        seenByReceiver: json['seenByReceiver'],
        desiredBookID: json['desiredBookID'],
      );

  Map<String, dynamic> toJson() => {
        'swapReqID': notificationID,
        'senderID': senderID,
        'receiverID': receiverID,
        "message": message,
        'notificationType': notificationType,
        'seenByReceiver': seenByReceiver,
        'desiredBookID': desiredBookID,
      };
}
