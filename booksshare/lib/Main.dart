// ignore_for_file: file_names

import 'package:booksshare/Screens/Friends/friendsScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Models/userModel.dart';
import 'Screens/Exchange/exchangeScreen.dart';
import 'Screens/Home/homePage.dart';
import 'Screens/Library/bookSearchPage.dart';
import 'Screens/Notification/notifacationScreen.dart';
import 'Screens/Profile/userProfile.dart';
import 'Screens/Settings/userSettings.dart';
import 'Services/authService.dart';
import 'Wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
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
            '/profile': (context) =>
                UserProfile(userID: authService.getUserID()!),
            '/home': (context) => const HomePage(),
            '/settings': (context) => const UserSettings(),
            '/search': (context) => const BookSearchPage(),
            '/notification': (context) => const NotificationScreen(),
            '/exchange': (context) => const ExchangeScreen(),
            '/friends': (context) => const FriendsScreen(),
          },
          home: const Wrapper(),
        ));
  }
}
