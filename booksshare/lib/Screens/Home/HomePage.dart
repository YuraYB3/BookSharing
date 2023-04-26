// ignore_for_file: file_names

import 'package:booksshare/Screens/Start/verifyEmailPage.dart';
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
  void initState() {
    super.initState();
    AuthService auth = AuthService();
    var uId = auth.getUserID();
    DatabaseUserService().updateToken();
  }

  @override
  Widget build(BuildContext context) {
    AuthService auth = AuthService();
    var uId = auth.getUserID();
    var bookService = BookService(uId!);
    UserAppBar userBar = UserAppBar();
    UserBooksList booksList = UserBooksList();
    DatabaseUserService databaseUserService = DatabaseUserService();
    var userStream = databaseUserService.readUser(uId);
    return StreamBuilder(
      stream: userStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: AppTheme.secondBackgroundColor,
                toolbarHeight: 60,
              ),
              backgroundColor: AppTheme.backgroundColor,
              body: const Center(
                child: CircularProgressIndicator(
                  color: Colors.amber,
                  backgroundColor: Colors.white,
                ),
              ));
        }
        List<UserModel> users = snapshot.data!;
        if (users.isEmpty) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: AppTheme.secondBackgroundColor,
                toolbarHeight: 60,
              ),
              backgroundColor: AppTheme.secondBackgroundColor,
              body: const Center(
                child: CircularProgressIndicator(
                  color: Colors.amber,
                  backgroundColor: Colors.white,
                ),
              ));
        }
        var user = users.first;

        if (user.emailVerified != true) {
          return const VerifyEmailPage();
        }
        return StreamProvider<List<UserModel>?>.value(
            value: DatabaseUserService().users,
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
      },
    );
  }
}
