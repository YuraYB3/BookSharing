// ignore_for_file: file_names

class Books {
  final String name;
  final String title;
  final String userId;
  final String bookId;
  final String available;
  final String cover;

  Books({
    required this.name,
    required this.title,
    required this.userId,
    required this.bookId,
    required this.available,
    required this.cover,
  });

  static Books fromJson(Map<String, dynamic> json) => Books(
        name: json['name'],
        title: json['title'],
        userId: json['userID'],
        bookId: json['bookID'],
        available: json['available'],
        cover: json['cover'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'title': title,
        'userID': userId,
        "bookID": bookId,
        'available': available,
        'cover': cover,
      };
}
