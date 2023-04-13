// ignore_for_file: file_names

class FriendshipModel {
  final String firstUser;
  final String secondUser;
  final String friendshipID;

  FriendshipModel(
      {required this.firstUser,
      required this.secondUser,
      required this.friendshipID});

  static FriendshipModel fromJson(Map<String, dynamic> json) => FriendshipModel(
        firstUser: json['user1_ID'],
        secondUser: json['user2_ID'],
        friendshipID: json['friendshipID'],
      );

  Map<String, dynamic> toJson() => {
        'user1_ID': firstUser,
        'user2_ID': secondUser,
        'friendshipID': friendshipID,
      };
}
