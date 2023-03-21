// ignore_for_file: file_names

class BookSwapRequestModel {
  final String swapReqID;
  final String senderID;
  final String receiverID;
  final String desiredBookID;
  final String message;
  final bool seenByReceiver;

  BookSwapRequestModel(
      {required this.swapReqID,
      required this.desiredBookID,
      required this.message,
      required this.receiverID,
      required this.senderID,
      required this.seenByReceiver});

  static BookSwapRequestModel fromJson(Map<String, dynamic> json) =>
      BookSwapRequestModel(
          swapReqID: json['swapReqID'],
          senderID: json['senderID'],
          receiverID: json['receiverID'],
          desiredBookID: json['desiredBookID'],
          message: json['message'],
          seenByReceiver: json['seenByReceiver']);

  Map<String, dynamic> toJson() => {
        'swapReqID': swapReqID,
        'senderID': senderID,
        'receiverID': receiverID,
        'desiredBookID': desiredBookID,
        "message": message,
        'seenByReceiver': seenByReceiver
      };
}
