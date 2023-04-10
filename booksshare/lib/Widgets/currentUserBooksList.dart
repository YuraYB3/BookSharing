// ignore_for_file: file_names
import 'package:booksshare/Shared/appTheme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../Models/bookModel.dart';
import '../Screens/Library/bookDetailsScreen.dart';
import '../Services/bookService.dart';

class CurrentUserBooksList {
  // ignore: non_constant_identifier_names
  StreamBuilder ListOfBooks(BookService bookList) {
    return StreamBuilder<List<BookModel>>(
        stream: bookList.readUserBooks(),
        builder:
            (BuildContext context, AsyncSnapshot<List<BookModel>> snapshot) {
          if (snapshot.hasError) {
            return const Text("ERROR!!!");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("У вас тут пусто :(",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                  Text(
                    'Натисни щоб додати книгу',
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
            );
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: Card(
                          elevation: 10,
                          shadowColor: AppTheme.secondBackgroundColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: 100,
                                  width: 90,
                                  child: Image(
                                      image: CachedNetworkImageProvider(
                                        book.cover,
                                      ),
                                      fit: BoxFit.cover)),
                              Padding(
                                padding: const EdgeInsets.only(left: 50),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Назва книги:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          width: 1,
                                        ),
                                        Text(
                                          book.name,
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Автор книги:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          width: 1,
                                        ),
                                        Text(book.title,
                                            style: const TextStyle(
                                                color: Colors.grey)),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ));
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
