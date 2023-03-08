import 'package:booksshare/Screens/AppBar/userAppBar.dart';
import 'package:booksshare/Screens/Home/UserBooksList.dart';
import 'package:booksshare/Screens/Panel/userPanel.dart';
import 'package:booksshare/Services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Models/userModel.dart';
import '../../Services/DatabaseUser.dart';
import '../../Services/UserBooks.dart';
import 'AddBook/AddBookWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference booksCollection =
      FirebaseFirestore.instance.collection('books');

  @override
  Widget build(BuildContext context) {
    AuthService auth = AuthService();
    var uId = auth.getUserID();
    var bookService = BookService(uId!);
    UserAppBar userBar = UserAppBar();
    BooksList booksList = BooksList();

    return StreamProvider<List<UserModel>?>.value(
        value: DatabaseUserService(uid: '').users,
        initialData: null,
        child: Scaffold(
            appBar: userBar.headerBar(context),
            backgroundColor: Colors.white,
            body: booksList.ListOfBooks(bookService),
            floatingActionButton: const AddBookWidget(),
            bottomNavigationBar: BottomAppBar(
              color: Colors.white,
              child: Container(height: 50),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            drawer: UserPanel()));
  }
}
