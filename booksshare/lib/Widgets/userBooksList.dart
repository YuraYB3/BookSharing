// ignore_for_file: file_names
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../Models/bookModel.dart';
import '../Screens/Library/bookDetailsScreen.dart';
import '../Services/bookService.dart';
import '../Shared/appTheme.dart';

class UserBooksList {
  StreamBuilder listOfBooks(BookService bookList) {
    return StreamBuilder<List<BookModel>>(
        stream: bookList.readUserBooks(),
        builder:
            (BuildContext context, AsyncSnapshot<List<BookModel>> snapshot) {
          if (snapshot.hasError) {
            return const Text(
              "ПОМИЛКА!",
              style: TextStyle(color: Colors.red),
            );
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
                      overflow: TextOverflow.clip,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                  Text(
                    overflow: TextOverflow.clip,
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
                              bookAvalaible: book.available,
                              bookCover: book.cover,
                              bookDescription: book.description,
                              bookName: book.name,
                              bookTitle: book.title,
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
                                  height: 150,
                                  width: 112.5,
                                  child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        const CircularProgressIndicator(
                                          color: Colors.amber,
                                          backgroundColor: Colors.white,
                                        ),
                                        Image(
                                            image: CachedNetworkImageProvider(
                                              book.cover,
                                            ),
                                            fit: BoxFit.cover),
                                      ])),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
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
                                        book.name.length > 12
                                            ? Text(
                                                "${book.name.substring(0, 12)}...",
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.grey),
                                                maxLines: 2,
                                                softWrap: true,
                                                //або будь-яке інше значення менше за ширину контейнера
                                              )
                                            : Text(
                                                book.name,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.grey),
                                                maxLines: 2,
                                                softWrap: true,
                                                //або будь-яке інше значення менше за ширину контейнера
                                              )
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
                                        book.title.length > 12
                                            ? Text(
                                                '${book.title.substring(0, 12)}...',
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.grey),
                                              )
                                            : Text(
                                                book.title,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.grey),
                                              )
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
