import 'package:booksshare/Shared/appTheme.dart';
import 'package:booksshare/Widgets/userInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../Models/reviewModel.dart';
import '../../Services/reviewService.dart';
import 'readMoreButton.dart';

class UserReviews extends StatelessWidget {
  final String userID;

  const UserReviews({super.key, required this.userID});

  @override
  Widget build(BuildContext context) {
    CollectionReference book = FirebaseFirestore.instance.collection("books");
    ReviewService reviewObj = ReviewService();
    UserList userInfo = UserList();
    return Container(
        color: AppTheme.secondBackgroundColor,
        height: 550,
        child: StreamBuilder<List<ReviewModel>>(
          stream: reviewObj.readUserReviews(userID),
          builder: (BuildContext context,
              AsyncSnapshot<List<ReviewModel>> snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(
                    child: Text(
                      'User doesnt have reviews',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.textColor),
                    ),
                  )
                ],
              );
            }
            final reviewData = snapshot.data!;
            return ListView.builder(
                itemCount: reviewData.length,
                itemBuilder: (context, index) {
                  final review = reviewData[index];
                  return FutureBuilder<DocumentSnapshot>(
                      future: book.doc(review.bookId).get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> bookSnapshot) {
                        if (bookSnapshot.connectionState ==
                            ConnectionState.done) {
                          if (!bookSnapshot.hasData ||
                              bookSnapshot.data!.data() == null) {
                            return const Center(
                              child: Text(
                                'Book was delited :(',
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }
                          Map<String, dynamic> bookdata =
                              bookSnapshot.data!.data() as Map<String, dynamic>;
                          return ReviewCard(context, bookdata, review);
                        } else {
                          return const Center(
                            child: Text('Loading...'),
                          );
                        }
                      });
                });
          },
        ));
  }

  Widget ReviewCard(
      BuildContext context, Map<String, dynamic> bookdata, ReviewModel review) {
    return Card(
        elevation: 10,
        borderOnForeground: false,
        shadowColor: AppTheme.secondBackgroundColor,
        color: Colors.amber[100],
        margin: const EdgeInsets.all(10),
        child: Container(
          color: Colors.amber[50],
          margin: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        height: 50,
                        width: 50,
                        child: Image.network(bookdata['cover'])),
                    SizedBox(
                      width: 50,
                      height: 20,
                      child: Center(
                        child: Text(
                          bookdata['name'],
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 100,
                  width: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('${review.review.substring(0, 32)}...'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ReadMoreButton(
                              context: context, review: review.review)
                        ],
                      ),
                      RatingBar.builder(
                        ignoreGestures: true,
                        initialRating: review.rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        itemCount: 5,
                        itemSize: 20.0,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 5.0,
                        ),
                        onRatingUpdate: (rating) {},
                      ),
                      Container(
                        height: 5,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
