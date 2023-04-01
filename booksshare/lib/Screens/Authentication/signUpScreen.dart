// ignore_for_file: file_names

// ignore: use_key_in_widget_constructors
import 'package:booksshare/Shared/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/userModel.dart';
import '../../Services/authService.dart';
import '../../Services/databaseUserService.dart';
import '../../Shared/constants.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String email = '';
  String password = '';
  String repeatedPassword = '';
  String error = '';
  String name = '';
  String surname = '';
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return StreamProvider<List<UserModel>?>.value(
        value: DatabaseUserService(uid: '').users,
        initialData: null,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppTheme.secondBackgroundColor,
          // ignore: prefer_const_constructors

          body: Padding(
            padding: const EdgeInsets.all(50),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    validator: (value) =>
                        value!.isEmpty ? 'Enter your name' : null,
                    decoration: textInputDecoration.copyWith(hintText: "Name"),
                    style: const TextStyle(),
                    onChanged: (val) {
                      setState(() {
                        name = val;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    validator: (value) =>
                        value!.isEmpty ? 'Enter your surname' : null,
                    decoration:
                        textInputDecoration.copyWith(hintText: "Surname"),
                    onChanged: (val) {
                      setState(() {
                        surname = val;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    validator: (value) =>
                        value!.isEmpty ? 'Enter an email' : null,
                    decoration: textInputDecoration.copyWith(hintText: "Email"),
                    style: const TextStyle(),
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    validator: (value) => value!.length < 8
                        ? 'Enter a password 8+ charactercs'
                        : null,
                    decoration:
                        textInputDecoration.copyWith(hintText: "Password"),
                    obscureText: true,
                    style: const TextStyle(),
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    validator: (value) => value != password
                        ? 'Difference between password!'
                        : null,
                    decoration: textInputDecoration.copyWith(
                        hintText: "Repeat password"),
                    obscureText: true,
                    style: const TextStyle(),
                    onChanged: (val) {
                      setState(() {
                        repeatedPassword = val;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 180,
                    height: 40,
                    child: TextButton(
                      onPressed: () async {
                        try {
                          if (_formKey.currentState!.validate()) {
                            dynamic result = await _auth.register(
                                email, password, name, surname);
                            if (result == null) {
                              setState(() {
                                error = "ERROR";
                              });
                            } else {
                              Navigator.pop(context);
                            }
                          }
                          // ignore: empty_catches
                        } catch (e) {}
                      },
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              AppTheme.secondBackgroundColor),
                          // ignore: prefer_const_constructors
                          backgroundColor:
                              const MaterialStatePropertyAll<Color>(
                                  AppTheme.textColor)),
                      child: const Text(
                        'SIGN UP',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
