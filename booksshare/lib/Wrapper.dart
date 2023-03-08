// ignore_for_file: file_names
import 'package:booksshare/Models/userModel.dart';
import 'package:booksshare/Screens/Start/StartPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Screens/Home/homepage.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    if (user == null) {
      return const StartPage(
        title: '',
      );
    } else {
      return const HomePage();
    }
  }
}
