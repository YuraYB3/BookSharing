// ignore_for_file: file_names

class Books {
  final String name;
  final String title;
  final String userId;
  final String bookId;
  final String available;
  final String cover;
  final String description;

  Books(
      {required this.name,
      required this.title,
      required this.userId,
      required this.bookId,
      required this.available,
      required this.cover,
      required this.description});

  static Books fromJson(Map<String, dynamic> json) => Books(
      name: json['name'],
      title: json['title'],
      userId: json['userID'],
      bookId: json['bookID'],
      available: json['available'],
      cover: json['cover'],
      description: json['description']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'title': title,
        'userID': userId,
        "bookID": bookId,
        'available': available,
        'cover': cover,
        'description': description
      };
}
