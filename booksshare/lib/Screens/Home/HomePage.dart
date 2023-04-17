// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/userModel.dart';
import '../../Services/authService.dart';
import '../../Services/bookService.dart';
import '../../Services/databaseUserService.dart';
import '../../Shared/appTheme.dart';
import '../../Widgets/AddBook/addBookWidget.dart';
import '../../Widgets/AppBar/userAppBar.dart';
import '../../Widgets/Panel/userPanel.dart';
import '../../Widgets/userBooksList.dart';

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
    UserBooksList booksList = UserBooksList();

    return StreamProvider<List<UserModel>?>.value(
        value: DatabaseUserService(uid: '').users,
        initialData: null,
        child: Scaffold(
            appBar: userBar.headerBar(context),
            backgroundColor: AppTheme.backgroundColor,
            body: booksList.listOfBooks(bookService),
            floatingActionButton: const AddBookWidget(),
            bottomNavigationBar: BottomAppBar(
              color: AppTheme.backgroundColor,
              child: Container(height: 50),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            drawer: UserPanel()));
  }
}
