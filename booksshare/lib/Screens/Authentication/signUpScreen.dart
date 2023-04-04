// ignore_for_file: file_names

// ignore: use_key_in_widget_constructors
import 'dart:io';

import 'package:booksshare/Shared/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  int age = 18;
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  var isImageLoaded = false;

  XFile? file;
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: Colors.white),
                          child: isImageLoaded == true
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: Image.file(File(file!.path),
                                      fit: BoxFit.cover),
                                )
                              : Center(
                                  child: IconButton(
                                      onPressed: () async {
                                        ImagePicker imagePicker = ImagePicker();
                                        XFile? f = await imagePicker.pickImage(
                                            source: ImageSource.gallery);
                                        setState(() {
                                          file = f;
                                          isImageLoaded = true;
                                        });
                                      },
                                      icon: const Icon(Icons.add_a_photo)),
                                ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 150,
                              child: TextFormField(
                                validator: (value) =>
                                    value!.isEmpty ? '' : null,
                                decoration: textInputDecoration.copyWith(
                                    hintText: "Name"),
                                style: const TextStyle(),
                                onChanged: (val) {
                                  setState(() {
                                    name = val;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              child: TextFormField(
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: false, signed: false),
                                validator: (value) =>
                                    value!.isEmpty ? '' : null,
                                decoration: textInputDecoration.copyWith(
                                    hintText: "Age"),
                                style: const TextStyle(),
                                onChanged: (val) {
                                  setState(() {
                                    age = int.tryParse(val) ?? 18;
                                  });
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 25,
                  ),
                  SizedBox(
                    height: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextFormField(
                          validator: (value) =>
                              value!.isEmpty ? 'Enter an email' : null,
                          decoration:
                              textInputDecoration.copyWith(hintText: "Email"),
                          style: const TextStyle(),
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                        ),
                        TextFormField(
                          validator: (value) => value!.length < 8
                              ? 'Enter a password 8+ charactercs'
                              : null,
                          decoration: textInputDecoration.copyWith(
                              hintText: "Password"),
                          obscureText: true,
                          style: const TextStyle(),
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                        ),
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
                        SizedBox(
                          width: 180,
                          height: 40,
                          child: TextButton(
                            onPressed: () async {
                              try {
                                if (_formKey.currentState!.validate()) {
                                  dynamic result = await _auth.register(
                                      name, age, password, email, file!);
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
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        AppTheme.secondBackgroundColor),
                                // ignore: prefer_const_constructors
                                backgroundColor:
                                    const MaterialStatePropertyAll<Color>(
                                        AppTheme.textColor)),
                            child: const Text(
                              'SIGN UP',
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

/*
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

                  ),*/