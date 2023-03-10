// ignore_for_file: file_names

import 'package:booksshare/Models/userModel.dart';
import 'package:booksshare/Screens/Authentication/LoginPage.dart';
import 'package:booksshare/Screens/Authentication/SignUp.dart';
import 'package:booksshare/Screens/Home/homepage.dart';
import 'package:booksshare/Screens/Profile/userProfile.dart';
import 'package:booksshare/Screens/Settings/userSettings.dart';
import 'package:booksshare/Services/auth.dart';
import 'package:booksshare/Wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Screens/Library/AllBooksOfAllUsers.dart';
import 'Screens/Library/BookSearchPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
        value: AuthService().user,
        initialData: null,
        child: MaterialApp(
          theme: ThemeData(
            primaryColor: Colors.black,
          ),
          initialRoute: '/',
          routes: {
            // ignore: prefer_const_constructors
            '/login': (context) => LoginPage(),
            '/signup': (context) => SignUp(),
            '/profile': (context) => UserProfile(),
            '/home': (context) => const HomePage(),
            '/settings': (context) => UserSettings(),
            '/library': (context) => const UsersBooks(),
            '/search': (context) => BookSearchPage()
          },
          home: const Wrapper(),
        ));
  }
}
