// ignore_for_file: file_names

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
        backgroundColor: const Color.fromARGB(252, 7, 85, 85),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("COPY"),
              Container(
                width: 150,
                height: 40,
                margin: const EdgeInsets.all(20),
                child: TextButton(
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromRGBO(7, 85, 85, 1)),
                      // ignore: prefer_const_constructors
                      backgroundColor:
                          const MaterialStatePropertyAll<Color>(Colors.white)),
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
                          const Color.fromRGBO(7, 85, 85, 1)),
                      // ignore: prefer_const_constructors
                      backgroundColor:
                          const MaterialStatePropertyAll<Color>(Colors.white)),
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
