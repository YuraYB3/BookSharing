import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Models/bookModel.dart';
import '../../Services/authService.dart';
import '../../Services/bookService.dart';
import '../../Shared/appTheme.dart';
import '../../Widgets/Panel/userPanel.dart';
import 'bookDetailsScreen.dart';

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
        backgroundColor: AppTheme.backgroundColor,
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
        body: StreamBuilder<List<BookModel>>(
            stream: bookList.readAllUsersBooks(),
            builder: (BuildContext context,
                AsyncSnapshot<List<BookModel>> snapshot) {
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
                          final userdata =
                              userSnapshot.data!.data() as Map<String, dynamic>;
                          final bookName = book.name.toString().toLowerCase();
                          final bookTitle = book.title.toString().toLowerCase();
                          final query = searchQuery.toLowerCase();
                          final startsWithQuery = bookName.startsWith(query) ||
                              bookTitle.startsWith(query);
                          if (searchQuery.length >= 3 &&
                              book.available == 'yes' &&
                              startsWithQuery) {
                            return ListTile(
                              title: const Text("Назва книги:"),
                              subtitle: Text(book.name),
                              leading: SizedBox(
                                height: 300,
                                width: 50,
                                child: Image.network(book.cover,
                                    width: 200, height: 300, fit: BoxFit.cover),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookDetailsScreen(
                                      bookID: book.bookId,
                                      userID: book.userId,
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return Container();
                          }
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    );
                  },
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
        drawer: UserPanel());
  }
}
