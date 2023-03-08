// ignore_for_file: file_names

import 'package:booksshare/Services/UserBooks.dart';
import 'package:flutter/material.dart';

import '../Library/BookDetailsScreen.dart';
import '../../Models/BooksModel.dart';

class BooksList {
  // ignore: non_constant_identifier_names
  StreamBuilder ListOfBooks(BookService bookList) {
    return StreamBuilder<List<Books>>(
        stream: bookList.readUserBooks(),
        builder: (BuildContext context, AsyncSnapshot<List<Books>> snapshot) {
          if (snapshot.hasError) {
            return const Text("ERROR!!!");
          }
          if (snapshot.hasData) {
            final books = snapshot.data!;
            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
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
                    title: Text(book.name),
                    leading: SizedBox(
                        height: 300,
                        width: 50,
                        child: Image.network(book.cover,
                            width: 200, height: 300, fit: BoxFit.cover)),
                    subtitle: Text(book.title),
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
