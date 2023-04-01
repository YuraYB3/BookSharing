// ignore_for_file: file_names

import 'package:booksshare/Shared/appTheme.dart';
import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key, required this.title});

  final String title;

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.secondBackgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 150,
                height: 40,
                margin: const EdgeInsets.all(20),
                child: TextButton(
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(
                          AppTheme.secondBackgroundColor),
                      // ignore: prefer_const_constructors
                      backgroundColor: const MaterialStatePropertyAll<Color>(
                          AppTheme.textColor)),
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text('Login'),
                ),
              ),
              Container(
                width: 150,
                height: 40,
                margin: const EdgeInsets.all(2),
                child: TextButton(
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(
                          AppTheme.secondBackgroundColor),
                      // ignore: prefer_const_constructors
                      backgroundColor: const MaterialStatePropertyAll<Color>(
                          AppTheme.textColor)),
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: const Text('Sign Up'),
                ),
              ),
            ],
          ),
        ));
  }
}
