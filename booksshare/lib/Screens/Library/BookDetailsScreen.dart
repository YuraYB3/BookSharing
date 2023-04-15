// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../Services/authService.dart';
import '../../Services/bookService.dart';
import '../../Services/swapRequestService.dart';
import '../../Shared/appTheme.dart';
import '../../Widgets/Review/bookReviews.dart';

class BookDetailsScreen extends StatefulWidget {
  final String bookID;
  final String userID;
  final String bookName;
  final String bookTitle;
  final String bookCover;
  final String bookAvalaible;
  final String bookDescription;

  const BookDetailsScreen(
      {super.key,
      required this.bookID,
      required this.userID,
      required this.bookName,
      required this.bookCover,
      required this.bookAvalaible,
      required this.bookDescription,
      required this.bookTitle});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    AuthService auth = AuthService();
    return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          toolbarHeight: 80,
          backgroundColor: AppTheme.secondBackgroundColor,
          title: Text(
            widget.bookName,
            style: const TextStyle(color: AppTheme.textColor),
          ),
        ),
        body: FlipCard(
            fill: Fill.fillBack,
            direction: FlipDirection.HORIZONTAL,
            side: CardSide.FRONT,
            front: frontSide(
                auth,
                widget.bookCover,
                widget.bookName,
                widget.bookTitle,
                widget.bookAvalaible,
                widget.bookID,
                widget.userID),
            back: backSide(auth, widget.bookDescription)));
  }

  Widget frontSide(AuthService auth, String bookCover, String bookName,
      String bookTitle, String bookAvalaible, String bookID, String userID) {
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
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const CircularProgressIndicator(
                          color: Colors.amber,
                          backgroundColor: Colors.white,
                        ), // Show the progress indicator
                        Image.network(
                          bookCover,
                          fit: BoxFit.fill,
                        ),
                      ],
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
                            bookName,
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
                          Text(bookTitle,
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
                          bookAvalaible == 'yes'
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
                                      userID,
                                      bookID,
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
                                      bookService.deleteBook(bookID);
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
                                    return ReviewWidget(bookID: bookID);
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

  Widget backSide(AuthService auth, String bookDescription) {
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
                        bookDescription,
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
