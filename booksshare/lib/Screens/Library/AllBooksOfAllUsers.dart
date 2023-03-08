// ignore_for_file: file_names

import 'package:booksshare/Services/UserBooks.dart';
import 'package:booksshare/Screens/Library/AllUsersBooks.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/userModel.dart';
import '../../Services/auth.dart';
import '../../Services/DatabaseUser.dart';
import '../AppBar/UserAppBar.dart';

class UsersBooks extends StatefulWidget {
  const UsersBooks({super.key});

  @override
  State<UsersBooks> createState() => _UsersBooksState();
}

class _UsersBooksState extends State<UsersBooks> {
  @override
  Widget build(BuildContext context) {
    AuthService auth = AuthService();
    var uId = auth.getUserID();
    var bookList = BookService(uId!);
    BooksList booksList = BooksList();
    UserAppBar userBar = UserAppBar();
    return StreamProvider<List<UserModel>?>.value(
        value: DatabaseUserService(uid: '').users,
        initialData: null,
        child: Scaffold(
          appBar: userBar.headerBar(context),
          backgroundColor: Colors.white,
          body: booksList.ListOfBooks(bookList, uId),
        ));
  }
}
