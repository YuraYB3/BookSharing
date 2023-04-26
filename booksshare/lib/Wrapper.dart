// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Models/userModel.dart';
import 'Screens/Home/homePage.dart';
import 'Screens/Start/startPage.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    if (user == null) {
      return const StartPage();
    } else {
      return const HomePage();
    }
  }
}
