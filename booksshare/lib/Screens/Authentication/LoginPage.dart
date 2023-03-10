// ignore_for_file: file_names

import 'package:booksshare/Services/auth.dart';
import 'package:booksshare/Shared/Constants.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();
  String email = '';
  String password = '';
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
        backgroundColor: const Color.fromARGB(252, 7, 85, 85),
        // ignore: prefer_const_constructors
        body: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: "E-Mail"),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter an email' : null,
                  style: const TextStyle(),
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  decoration:
                      textInputDecoration.copyWith(hintText: "Password"),
                  obscureText: true,
                  validator: (value) => value!.length < 8
                      ? 'Enter a password 8+ charactercs'
                      : null,
                  style: const TextStyle(),
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: 180,
                  height: 40,
                  child: TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        dynamic result =
                            await _auth.signInWithPassword(email, password);
                        if (result == null) {
                        } else {
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        }
                      }
                    },
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromRGBO(7, 85, 85, 1)),
                        // ignore: prefer_const_constructors
                        backgroundColor: const MaterialStatePropertyAll<Color>(
                            Colors.white)),
                    child: const Text(
                      'SIGN IN',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
