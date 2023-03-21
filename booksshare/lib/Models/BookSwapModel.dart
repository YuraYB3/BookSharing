class BookSwapModel {
  final String bookSwapID;
  final String swapReqID;
  final String senderID;
  final String receiverID;
  final String desiredBookID;

  BookSwapModel({
    required this.bookSwapID,
    required this.swapReqID,
    required this.desiredBookID,
    required this.receiverID,
    required this.senderID,
  });

  static BookSwapModel fromJson(Map<String, dynamic> json) => BookSwapModel(
        bookSwapID: json['bookSwapID'],
        swapReqID: json['swapReqID'],
        senderID: json['senderID'],
        receiverID: json['receiverID'],
        desiredBookID: json['desiredBookID'],
      );

  Map<String, dynamic> toJson() => {
        'bookSwapID': bookSwapID,
        'swapReqID': swapReqID,
        'senderID': senderID,
        'receiverID': receiverID,
        'desiredBookID': desiredBookID,
      };
}
