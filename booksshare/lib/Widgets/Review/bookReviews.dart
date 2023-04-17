// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../Models/reviewModel.dart';
import '../../Services/reviewService.dart';
import '../../Shared/appTheme.dart';
import '../userInfo.dart';
import 'readMoreButton.dart';

class ReviewWidget extends StatelessWidget {
  final String bookID;

  const ReviewWidget({super.key, required this.bookID});

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
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(
                    child: Text(
                      'В книги немає рецензій',
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.textColor),
                    ),
                  )
                ],
              );
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
                            return reviewCard(context, userdata, review);
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        });
                  });
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }

  Widget reviewCard(
      BuildContext context, Map<String, dynamic> userdata, ReviewModel review) {
    UserInformation userInfo = UserInformation();
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
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: userInfo.userImage(userdata['uid'])),
                    ),
                    SizedBox(
                      width: 50,
                      height: 20,
                      child: Center(
                        child: Text(
                          userdata['name'],
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
