// ignore_for_file: file_names

class ReviewModel {
  final String bookId;
  final String userId;
  final String review;
  final double rating;

  ReviewModel(
      {required this.bookId,
      required this.userId,
      required this.review,
      required this.rating});

  static ReviewModel fromJson(Map<String, dynamic> json) => ReviewModel(
      bookId: json['bookID'],
      userId: json['userID'],
      review: json['review'],
      rating: json['rating']);

  Map<String, dynamic> toJson() =>
      {'bookID': bookId, 'userID': userId, 'review': review, 'rating': rating};
}
