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
      userId: json['userID'],
      bookId: json['bookID'],
      review: json['review'],
      rating: json['rating']);

  Map<String, dynamic> toJson() =>
      {'userID': userId, "bookID": bookId, 'review': review, 'rating': rating};
}
