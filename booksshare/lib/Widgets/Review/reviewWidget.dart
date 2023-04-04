import 'package:booksshare/Shared/appTheme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../Models/reviewModel.dart';
import '../../Services/reviewService.dart';

class ReviewWidget extends StatelessWidget {
  final String bookID;

  ReviewWidget({required this.bookID});

  @override
  Widget build(BuildContext context) {
    CollectionReference user = FirebaseFirestore.instance.collection("users");
    ReviewService reviewObj = ReviewService();
    return Container(
        color: AppTheme.secondBackgroundColor,
        height: 550,
        child: StreamBuilder<List<ReviewModel>>(
          stream: reviewObj.readBookReviews(bookID),
          builder: (BuildContext context,
              AsyncSnapshot<List<ReviewModel>> snapshot) {
            if (!snapshot.hasData) {
              return const Text('here4');
            }
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            if (snapshot.hasData) {
              final reviewData = snapshot.data!;
              return ListView.builder(
                  itemCount: reviewData.length,
                  itemBuilder: (context, index) {
                    final review = reviewData[index];
                    return FutureBuilder<DocumentSnapshot>(
                        future: user.doc(review.userId).get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                          if (userSnapshot.connectionState ==
                              ConnectionState.done) {
                            Map<String, dynamic> userdata = userSnapshot.data!
                                .data() as Map<String, dynamic>;
                            return Card(
                                elevation: 10,
                                borderOnForeground: false,
                                shadowColor: AppTheme.secondBackgroundColor,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                          ),
                                          Container(
                                            width: 50,
                                            height: 20,
                                            color: Colors.white,
                                            child: Center(
                                              child: Text(
                                                userdata['name'],
                                                style: const TextStyle(
                                                    color: Colors.black),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Container(
                                                color: Colors.white,
                                                child: Text(review.review
                                                    .substring(0, 32)),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                SizedBox(
                                                  height: 30,
                                                  child: TextButton(
                                                    onPressed: () {},
                                                    style: const ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStatePropertyAll<
                                                                    Color>(
                                                                Colors.amber)),
                                                    child: const Text(
                                                      "Read more",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                )
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
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4.0),
                                              itemBuilder: (context, _) =>
                                                  const Icon(
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
                                ));
                          } else {
                            return const Center(
                              child: Text('data'),
                            );
                          }
                        });
                  });
            } else {
              return const Text('here2');
            }
          },
        ));
  }
}
/* */