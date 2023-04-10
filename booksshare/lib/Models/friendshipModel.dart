class FriendshipModel {
  final String user1_ID;
  final String user2_ID;
  final String friendshipID;

  FriendshipModel(
      {required this.user1_ID,
      required this.user2_ID,
      required this.friendshipID});

  static FriendshipModel fromJson(Map<String, dynamic> json) => FriendshipModel(
        user1_ID: json['user1_ID'],
        user2_ID: json['user2_ID'],
        friendshipID: json['friendshipID'],
      );

  Map<String, dynamic> toJson() => {
        'user1_ID': user1_ID,
        'user2_ID': user2_ID,
        'friendshipID': friendshipID,
      };
}
