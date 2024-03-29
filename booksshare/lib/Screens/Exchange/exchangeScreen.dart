// ignore_for_file: file_names
import 'package:booksshare/Services/reminderService.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../Models/bookSwapModel.dart';
import '../../Models/userModel.dart';
import '../../Services/authService.dart';
import '../../Services/bookSwapService.dart';
import '../../Services/databaseUserService.dart';
import '../../Services/reviewService.dart';
import '../../Shared/appTheme.dart';
import '../../Widgets/Panel/userPanel.dart';

class ExchangeScreen extends StatefulWidget {
  const ExchangeScreen({super.key});

  @override
  State<ExchangeScreen> createState() => _ExchangeScreenState();
}

class _ExchangeScreenState extends State<ExchangeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<UserModel>?>.value(
        value: DatabaseUserService().users,
        initialData: null,
        child: Scaffold(
            drawer: UserPanel(),
            appBar: AppBar(
              toolbarHeight: 50,
              backgroundColor: AppTheme.secondBackgroundColor,
              title: const Text(''),
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: AppTheme.iconColor,
                indicatorWeight: 3,
                labelColor: AppTheme.textColor,
                tabs: const [
                  Tab(text: 'Отримані'),
                  Tab(text: 'Надіслані'),
                ],
              ),
            ),
            backgroundColor: AppTheme.backgroundColor,
            body: TabBarView(
              controller: _tabController,
              children: [
                exchangeScreen('senderID', () {}, 'sender'),
                exchangeScreen('receiverID', () {}, 'receiver')
              ],
            )));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  StreamBuilder<List<BookSwapModel>> exchangeScreen(
      String user, Function action, String exchangeType) {
    BookSwapService bookSwap = BookSwapService();
    AuthService authService = AuthService();
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection("users");
    CollectionReference bookCollection =
        FirebaseFirestore.instance.collection("books");
    var id = authService.getUserID();
    return StreamBuilder<List<BookSwapModel>>(
        stream: bookSwap.getBookSwap(user, id!),
        builder: (BuildContext context,
            AsyncSnapshot<List<BookSwapModel>> snapshot) {
          if (snapshot.hasError) {
            return const Text("ERROR!!!");
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Center(
                  child: Text('Зараз тут пусто...'),
                )
              ],
            );
          }
          final swap = snapshot.data!;
          return ListView.builder(
              itemCount: swap.length,
              itemBuilder: (context, index) {
                final bookswap = swap[index];
                return FutureBuilder<DocumentSnapshot>(
                    future: userCollection
                        .doc(exchangeType == 'sender'
                            ? bookswap.receiverID
                            : bookswap.senderID)
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.done) {
                        Map<String, dynamic> userdata =
                            userSnapshot.data!.data() as Map<String, dynamic>;

                        return FutureBuilder<DocumentSnapshot>(
                            future: bookCollection
                                .doc(bookswap.desiredBookID)
                                .get(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> bookSnapshot) {
                              if (bookSnapshot.connectionState ==
                                  ConnectionState.done) {
                                Map<String, dynamic> bookdata =
                                    bookSnapshot.data!.data()
                                        as Map<String, dynamic>;
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    borderOnForeground: true,
                                    elevation: 5.5,
                                    shadowColor: AppTheme.secondBackgroundColor,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                                height: 150,
                                                width: 120,
                                                child: Image(
                                                    image:
                                                        CachedNetworkImageProvider(
                                                      bookdata['cover'],
                                                    ),
                                                    fit: BoxFit.cover)),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "Назва книги:",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Container(
                                                        width: 1,
                                                      ),
                                                      Text(
                                                        '${bookdata['name']}',
                                                        style: const TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        exchangeType == 'sender'
                                                            ? "Власник книги:"
                                                            : "Орендар:",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Container(
                                                        width: 1,
                                                      ),
                                                      Text(
                                                          '${userdata['name']}',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .grey)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        exchangeType == "sender"
                                            ? Container(
                                                color: AppTheme
                                                    .secondBackgroundColor,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      color: AppTheme
                                                          .secondBackgroundColor,
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 2),
                                                          child: returnBookButton(
                                                              bookswap
                                                                  .desiredBookID,
                                                              bookswap
                                                                  .bookSwapID,
                                                              bookswap
                                                                  .senderID)),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Container(
                                                color: AppTheme
                                                    .secondBackgroundColor,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      color: AppTheme
                                                          .secondBackgroundColor,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(right: 2),
                                                        child: TextButton(
                                                            onPressed:
                                                                () async {
                                                              ReminderService
                                                                  reminderService =
                                                                  ReminderService();
                                                              reminderService.sendBookReminder(
                                                                  bookswap
                                                                      .senderID,
                                                                  bookswap
                                                                      .receiverID,
                                                                  bookswap
                                                                      .desiredBookID);
                                                            },
                                                            child: const Text(
                                                              'Нагадати про книгу',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            )),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return Column();
                            });
                      }
                      return Column();
                    });
              });
        });
  }

  TextButton returnBookButton(String bookID, String bookSwapID, String userID) {
    BookSwapService bookSwap = BookSwapService();
    ReviewService review = ReviewService();
    String description = '';
    late double rating = 3;
    return TextButton(
        onPressed: () async {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Залиште відгук"),
                  content: SingleChildScrollView(
                    child: SizedBox(
                      width: 450,
                      height: 250,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                              height: 150,
                              child: TextFormField(
                                validator: (value) =>
                                    value!.isEmpty || value.length < 50
                                        ? 'Ви повинні написати відгук!'
                                        : null,
                                decoration: const InputDecoration(
                                    hintText: "Введіть відгук"),
                                maxLength: 250,
                                maxLines: 10,
                                onChanged: (value) {
                                  setState(() {
                                    description = value;
                                  });
                                },
                              )),
                          RatingBar.builder(
                            initialRating: 3,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (value) {
                              rating = value;
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Відмінити")),
                    TextButton(
                        onPressed: () {
                          bookSwap.returnBook(bookSwapID, bookID);
                          review.addBookReview(
                              bookID, userID, description, rating);
                          Navigator.pop(context);
                        },
                        child: const Text("ОК"))
                  ],
                );
              });
        },
        child: const Text(
          'Повернути книгу',
          style: TextStyle(color: Colors.white),
        ));
  }
}
