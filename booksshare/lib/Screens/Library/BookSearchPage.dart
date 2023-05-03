// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Models/bookModel.dart';
import '../../Services/authService.dart';
import '../../Services/bookService.dart';
import '../../Shared/appTheme.dart';
import '../../Widgets/Panel/userPanel.dart';
import 'bookDetailsScreen.dart';

class BookSearchPage extends StatefulWidget {
  const BookSearchPage({super.key});

  @override
  State<BookSearchPage> createState() => _BookSearchPageState();
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
                hintText: 'Пошук .....',
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
          backgroundColor: AppTheme.secondBackgroundColor,
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
                        decorationStyle: TextDecorationStyle.solid,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.secondBackgroundColor),
                  ),
                ));
              }
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
                          final bookName = book.name.toString().toLowerCase();
                          final bookTitle =
                              book.author.toString().toLowerCase();
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
                                      bookAvalaible: book.available,
                                      bookCover: book.cover,
                                      bookDescription: book.description,
                                      bookName: book.name,
                                      bookAuthor: book.author,
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return Container();
                          }
                        } else {
                          return Container();
                        }
                      });
                },
              );
            }),
        drawer: UserPanel());
  }
}
