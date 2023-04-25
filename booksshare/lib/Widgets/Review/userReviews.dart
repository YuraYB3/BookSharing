// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../Models/reviewModel.dart';
import '../../Screens/Library/bookDetailsScreen.dart';
import '../../Services/reviewService.dart';
import '../../Shared/appTheme.dart';
import 'readMoreButton.dart';

class UserReviews extends StatelessWidget {
  final String userID;

  const UserReviews({super.key, required this.userID});

  @override
  Widget build(BuildContext context) {
    CollectionReference book = FirebaseFirestore.instance.collection("books");
    ReviewService reviewObj = ReviewService();
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
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Користувач не залишав відгуків',
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.textColor),
                      ),
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
                            return SizedBox(
                              height: 80,
                              child: Card(
                                  elevation: 10,
                                  borderOnForeground: false,
                                  shadowColor: AppTheme.secondBackgroundColor,
                                  color: Colors.amber[100],
                                  margin: const EdgeInsets.all(10),
                                  child: Container(
                                    color: Colors.amber[50],
                                    margin: const EdgeInsets.all(10),
                                    child: const Center(
                                      child: Text(
                                        'Книгу було видалено :(',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  )),
                            );
                          }
                          Map<String, dynamic> bookdata =
                              bookSnapshot.data!.data() as Map<String, dynamic>;
                          return reviewCard(context, bookdata, review);
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

  Widget reviewCard(
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookDetailsScreen(
                                bookID: bookdata['bookID'],
                                userID: bookdata['userID'],
                                bookAvalaible: bookdata['available'],
                                bookCover: bookdata['cover'],
                                bookDescription: bookdata['description'],
                                bookName: bookdata['name'],
                                bookTitle: bookdata['title'],
                              ),
                            ));
                      },
                      child: SizedBox(
                          height: 100,
                          width: 100,
                          child: Image.network(
                            bookdata['cover'],
                            fit: BoxFit.contain,
                          )),
                    ),
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
                        child: review.review.length > 32
                            ? Text('${review.review.substring(0, 32)}...')
                            : Text('${review.review}...'),
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
