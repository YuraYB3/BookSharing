// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Models/bookModel.dart';
import '../../Screens/Library/bookDetailsScreen.dart';
import '../../Services/bookService.dart';

class AllUsersBookList {
  // ignore: non_constant_identifier_names
  StreamBuilder ListOfBooks(BookService bookList, String userID) {
    CollectionReference user = FirebaseFirestore.instance.collection("users");
    return StreamBuilder<List<BookModel>>(
        stream: bookList.readAllUsersBooks(),
        builder:
            (BuildContext context, AsyncSnapshot<List<BookModel>> snapshot) {
          if (snapshot.hasError) {
            return Text("{$snapshot.error}");
          }
          if (snapshot.hasData) {
            final books = snapshot.data!;
            return ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return FutureBuilder<DocumentSnapshot>(
                      future: user.doc(book.userId).get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.done) {
                          Map<String, dynamic> userdata =
                              userSnapshot.data!.data() as Map<String, dynamic>;
                          if (book.available == 'yes') {
                            return GestureDetector(
                              onTap: () {
                                // Navigate to the BookDetailsScreen and pass in the book id
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BookDetailsScreen(
                                        bookID: book.bookId,
                                        userID: book.userId,
                                      ),
                                    ));
                              },
                              child: ListTile(
                                title: Text("Назва книги:${book.name}"),
                                leading: SizedBox(
                                    height: 300,
                                    width: 50,
                                    child: Image.network(book.cover,
                                        width: 200,
                                        height: 300,
                                        fit: BoxFit.cover)),
                                subtitle:
                                    Text('Власник книги: ${userdata['name']}'),
                              ),
                            );
                          } else {}
                        }
                        return const Text('');
                      });
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
