// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../Services/authService.dart';
import '../../Services/bookService.dart';
import '../../Services/swapRequestService.dart';
import '../../Shared/appTheme.dart';
import '../../Widgets/Review/bookReviews.dart';

class BookDetailsScreen extends StatefulWidget {
  final String? bookID;
  final String? userID;

  const BookDetailsScreen(
      {super.key, required this.bookID, required this.userID});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    CollectionReference book = FirebaseFirestore.instance.collection("books");
    CollectionReference user = FirebaseFirestore.instance.collection("users");
    AuthService auth = AuthService();

    return FutureBuilder<DocumentSnapshot>(
      future: book.doc(widget.bookID).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> bookSnapshot) {
        if (bookSnapshot.hasError) {
          return const Text(
            "Something went wrong!",
            style: TextStyle(color: AppTheme.textColor),
            textAlign: TextAlign.start,
            textDirection: TextDirection.ltr,
          );
        }
        if (bookSnapshot.hasData && !bookSnapshot.data!.exists) {
          return Text(
            "${widget.bookID}",
            style: const TextStyle(color: AppTheme.textColor, fontSize: 20),
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
          );
        }
        if (bookSnapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> bookdata =
              bookSnapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            backgroundColor: AppTheme.backgroundColor,
            appBar: AppBar(
              automaticallyImplyLeading: true,
              toolbarHeight: 80,
              backgroundColor: AppTheme.secondBackgroundColor,
              title: Text(
                "${bookdata['name']}",
                style: const TextStyle(color: AppTheme.textColor),
              ),
            ),
            body: FutureBuilder<DocumentSnapshot>(
                future: user.doc(widget.userID).get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> userdata =
                        userSnapshot.data!.data() as Map<String, dynamic>;

                    return FlipCard(
                        fill: Fill.fillBack,
                        direction: FlipDirection.HORIZONTAL,
                        side: CardSide.FRONT,
                        front: frontSide(auth, bookdata, userdata),
                        back: backSide(auth, bookdata));
                  } else {
                    return const Text('');
                  }
                }),
          );
        }
        return const Text("");
      },
    );
  }

  Widget frontSide(AuthService auth, Map<String, dynamic> bookdata,
      Map<String, dynamic> userdata) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 350,
          width: 400,
          child: Card(
            elevation: 20,
            borderOnForeground: true,
            semanticContainer: true,
            color: AppTheme.secondBackgroundColor,
            shadowColor: AppTheme.secondBackgroundColor,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 280,
                    width: 190,
                    child: Image.network(
                      bookdata['cover'],
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 280,
                  width: 2,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Row(
                        children: [
                          Text(
                            bookdata['name'],
                            style: const TextStyle(
                                color: AppTheme.textColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(bookdata['title'],
                              style: const TextStyle(
                                  color: AppTheme.textColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Доступна:',
                              style: TextStyle(
                                  color: AppTheme.textColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          Container(
                            width: 30,
                          ),
                          bookdata['available'] == 'yes'
                              ? const Text('Yes',
                                  style: TextStyle(
                                      color: AppTheme.textColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))
                              : const Text("No",
                                  style: TextStyle(
                                      color: AppTheme.textColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),
                    Container(
                      height: 110,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        widget.userID != auth.getUserID()
                            ? SizedBox(
                                height: 40,
                                width: 170,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    SwapRequestService bookSwapRequest =
                                        SwapRequestService();
                                    bookSwapRequest.addBookSwapRequest(
                                      auth.getUserID(),
                                      userdata['uid'],
                                      bookdata['bookID'],
                                    );
                                    Navigator.pop(context);
                                  },
                                  style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                      AppTheme.textColor,
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      AppTheme.secondBackgroundColor,
                                    ),
                                  ),
                                  child: const Text(
                                    "Send request ",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: 40,
                                width: 170,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    bool confirmDelete = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor:
                                              AppTheme.secondBackgroundColor,
                                          title: const Text(
                                            'Delete Book',
                                            style: TextStyle(
                                                color: AppTheme.textColor),
                                          ),
                                          content: const Text(
                                            'Are you sure you want to delete this book?',
                                            style: TextStyle(
                                                color: AppTheme.textColor),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    color: AppTheme.iconColor),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, true),
                                              child: const Text('Delete',
                                                  style: TextStyle(
                                                      color:
                                                          AppTheme.iconColor)),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    if (confirmDelete == true) {
                                      BookService bookService =
                                          BookService(auth.getUserID());
                                      bookService
                                          .deleteBook(bookdata['bookID']);
                                      // ignore: use_build_context_synchronously
                                      Navigator.pop(context);
                                    }
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      AppTheme.secondBackgroundColor,
                                    ),
                                  ),
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 40,
                          width: 170,
                          child: ElevatedButton(
                            onPressed: () async {
                              showMaterialModalBottomSheet(
                                  bounce: true,
                                  context: context,
                                  enableDrag: true,
                                  builder: (BuildContext context) {
                                    return ReviewWidget(
                                        bookID: bookdata['bookID']);
                                  });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                AppTheme.secondBackgroundColor,
                              ),
                            ),
                            child: const Text(
                              "Відгуки",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget backSide(AuthService auth, Map<String, dynamic> bookdata) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 350,
          width: 400,
          child: Card(
              elevation: 20,
              borderOnForeground: true,
              semanticContainer: true,
              color: AppTheme.secondBackgroundColor,
              shadowColor: AppTheme.backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text('DESCRIPTION:',
                        style: TextStyle(
                            color: AppTheme.textColor,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                            fontSize: 32)),
                    Container(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        bookdata['description'],
                        style: const TextStyle(
                            color: AppTheme.textColor,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    )
                  ],
                ),
              )),
        ),
      ],
    );
  }
}
