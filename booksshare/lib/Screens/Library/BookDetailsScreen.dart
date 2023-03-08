// ignore_for_file: file_names

import 'package:booksshare/Services/Auth.dart';
import 'package:booksshare/Services/BookSwapRequest.dart';
import 'package:booksshare/Services/UserBooks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.start,
            textDirection: TextDirection.ltr,
          );
        }
        if (bookSnapshot.hasData && !bookSnapshot.data!.exists) {
          return Text(
            "${widget.bookID}",
            style: const TextStyle(color: Colors.white, fontSize: 20),
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
          );
        }
        if (bookSnapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> bookdata =
              bookSnapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              toolbarHeight: 80,
              backgroundColor: const Color(0xff008787),
              title: Text(
                "${bookdata['name']}",
                style: const TextStyle(color: Colors.white),
              ),
            ),
            body: FutureBuilder<DocumentSnapshot>(
                future: user.doc(widget.userID).get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> userdata =
                        userSnapshot.data!.data() as Map<String, dynamic>;
                    if (widget.userID == auth.getUserID()) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 10,
                          ),
                          SizedBox(
                            height: 300,
                            width: 200,
                            child: Image.network(
                              bookdata['cover'],
                              fit: BoxFit.fill,
                            ),
                          ),
                          Text(
                            '${userdata['name']}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            height: 10,
                          ),
                          Text(
                            '${userdata['surname']}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            height: 10,
                          ),
                          Text(
                            "${bookdata['name']}",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            height: 10,
                          ),
                          Text(
                            "${bookdata['title']}",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () async {},
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    const Color(0xff008787),
                                  ),
                                ),
                                child: const Text(
                                  "Update",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  bool confirmDelete = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Delete Book'),
                                        content: const Text(
                                            'Are you sure you want to delete this book?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  if (confirmDelete == true) {
                                    BookService bookService =
                                        BookService(auth.getUserID());
                                    bookService.deleteBook(bookdata['bookID']);
                                    Navigator.pop(context);
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    const Color(0xff008787),
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
                            ],
                          ),
                        ],
                      );
                    } else {
                      return Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: 300,
                                    width: 200,
                                    child: Image.network(bookdata['cover'],
                                        fit: BoxFit.fill)),
                                Text(
                                  '${userdata['name']} ${userdata['surname']}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "${bookdata['name']}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "${bookdata['title']}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 30),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 60,
                              width: 150,
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(7, 85, 85, 1),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  BookSwapRequest b = BookSwapRequest();
                                  b.addBookSwapRequest(
                                    auth.getUserID(),
                                    userdata['userID'],
                                    bookdata['bookID'],
                                  );
                                  Navigator.pop(context);
                                },
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                    const Color.fromARGB(255, 255, 255, 255),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    const Color(0xff008787),
                                  ),
                                ),
                                child: const Text(
                                  "Send an exchange request ",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
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
}
