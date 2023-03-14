import 'package:booksshare/Services/Auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Models/BooksModel.dart';
import '../../Services/UserBooks.dart';
import '../Panel/UserPanel.dart';
import 'BookDetailsScreen.dart';

class BookSearchPage extends StatefulWidget {
  @override
  _BookSearchPageState createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    AuthService auth = AuthService();
    var uId = auth.getUserID();
    var bookList = BookService(uId!);
    CollectionReference user = FirebaseFirestore.instance.collection("users");
    return Scaffold(
        appBar: AppBar(
          title: Card(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search .....',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          automaticallyImplyLeading: true,
          toolbarHeight: 80,
          backgroundColor: const Color(0xff008787),
        ),
        body: StreamBuilder<List<Books>>(
            stream: bookList.readAllUsersBooks(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Books>> snapshot) {
              if (snapshot.hasError) {
                return Text("{$snapshot.error}");
              }
              if (searchQuery.isEmpty) {
                return const Center(
                    child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Введіть назву книги або автора :)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 24.0,
                        decorationStyle: TextDecorationStyle.solid),
                  ),
                ));
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
                              Map<String, dynamic> userdata = userSnapshot.data!
                                  .data() as Map<String, dynamic>;

                              if (book.available == 'yes' &&
                                      searchQuery.length >= 3 &&
                                      book.name
                                          .toString()
                                          .toLowerCase()
                                          .startsWith(
                                              searchQuery.toLowerCase()) ||
                                  searchQuery.length >= 3 &&
                                      book.title
                                          .toString()
                                          .toLowerCase()
                                          .startsWith(
                                              searchQuery.toLowerCase())) {
                                return GestureDetector(
                                  onTap: () {
                                    // Navigate to the BookDetailsScreen and pass in the book id
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BookDetailsScreen(
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
                                    subtitle: Text(
                                        'Власник книги: ${userdata['name']} ${userdata['surname']}'),
                                  ),
                                );
                              } else {}
                            }
                            return const Text('');
                          });
                    });
              } else {
                return Container();
              }
            }),
        drawer: UserPanel());
  }
}
