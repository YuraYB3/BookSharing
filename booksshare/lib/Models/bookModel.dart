// ignore_for_file: file_names

class BookModel {
  final String name;
  final String author;
  final String userId;
  final String bookId;
  final String available;
  final String cover;
  final String description;

  BookModel(
      {required this.name,
      required this.author,
      required this.userId,
      required this.bookId,
      required this.available,
      required this.cover,
      required this.description});

  static BookModel fromJson(Map<String, dynamic> json) => BookModel(
      name: json['name'],
      author: json['author'],
      userId: json['userID'],
      bookId: json['bookID'],
      available: json['available'],
      cover: json['cover'],
      description: json['description']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'author': author,
        'userID': userId,
        "bookID": bookId,
        'available': available,
        'cover': cover,
        'description': description
      };
}
