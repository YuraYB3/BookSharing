// ignore_for_file: file_names

// ignore: use_key_in_widget_constructors
import 'dart:io';
import 'package:booksshare/Screens/Start/forgotPasswordPage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../Services/authService.dart';
import '../../Shared/appTheme.dart';
import '../../Shared/constants.dart';
import '../Home/homePage.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final AuthService _auth = AuthService();
  String email = '';
  String password = '';
  String repeatedPassword = '';
  String error = '';
  String name = '';
  String surname = '';
  int age = 18;
  bool isLoginScreen = true;
  final _formSignUpKey = GlobalKey<FormState>();
  final _formLoginInKey = GlobalKey<FormState>();

  var isImageLoaded = false;

  XFile? file;
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
        backgroundColor: AppTheme.secondBackgroundColor,
        // ignore: prefer_const_constructors
        body: Center(
          child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: SingleChildScrollView(
                  child: isLoginScreen ? loginWidget() : signUpWidget())),
        ));
  }

  Widget loginWidget() {
    return Container(
      height: 400,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(30)),
      child: Form(
        key: _formLoginInKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: textInputDecoration.copyWith(hintText: "E-Mail"),
                validator: (value) => value!.isEmpty ? 'Введіть email' : null,
                style: const TextStyle(),
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                },
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: textInputDecoration.copyWith(hintText: "Пароль"),
                obscureText: true,
                validator: (value) =>
                    value!.length < 8 ? 'Введіть пароль з 8+ символів' : null,
                style: const TextStyle(),
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: 180,
              height: 40,
              child: TextButton(
                onPressed: () async {
                  if (_formLoginInKey.currentState!.validate()) {
                    dynamic result =
                        await _auth.signInWithPassword(email, password);
                    if (result == null) {
                    } else {
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    }
                  }
                },
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(AppTheme.textColor),
                    // ignore: prefer_const_constructors
                    backgroundColor: const MaterialStatePropertyAll<Color>(
                        AppTheme.secondBackgroundColor)),
                child: const Text(
                  'Увійти',
                ),
              ),
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    isLoginScreen = !isLoginScreen;
                  });
                },
                child: const Text(
                  'Я не маю акаунту',
                  style: TextStyle(color: AppTheme.secondBackgroundColor),
                )),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ForgotPasswordPage()));
                },
                child: const Text(
                  'Забули пароль?',
                  style: TextStyle(color: AppTheme.secondBackgroundColor),
                ))
          ],
        ),
      ),
    );
  }

  Widget signUpWidget() {
    return Container(
      height: 600,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(30)),
      child: Form(
        key: _formSignUpKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 15),
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.grey.shade300),
                      child: isImageLoaded == true
                          ? GestureDetector(
                              onTap: () async {
                                ImagePicker imagePicker = ImagePicker();
                                XFile? f = await imagePicker.pickImage(
                                    source: ImageSource.gallery);
                                setState(() {
                                  file = f;
                                  isImageLoaded = true;
                                });
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: Image.file(File(file!.path),
                                    fit: BoxFit.cover),
                              ),
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
                                  icon: const Icon(
                                    Icons.add_a_photo,
                                    color: Colors.black87,
                                  )),
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15, top: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 150,
                          child: TextFormField(
                            maxLength: 15,
                            textCapitalization: TextCapitalization.words,
                            validator: (value) => value!.isEmpty ? '' : null,
                            decoration: textInputDecoration.copyWith(
                                hintText: "Нікнейм"),
                            style: const TextStyle(),
                            onChanged: (val) {
                              setState(() {
                                name = val;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          width: 150,
                          child: TextFormField(
                            maxLength: 2,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: false,
                              signed: false,
                            ),
                            validator: (value) => value!.isEmpty ? '' : null,
                            decoration:
                                textInputDecoration.copyWith(hintText: "Вік"),
                            style: const TextStyle(),
                            onChanged: (val) {
                              setState(() {
                                age = int.tryParse(val) ?? 18;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(right: 15, left: 15, top: 8, bottom: 8),
              child: SizedBox(
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextFormField(
                      validator: (value) =>
                          value!.isEmpty ? 'Введіть email' : null,
                      decoration:
                          textInputDecoration.copyWith(hintText: "Email"),
                      style: const TextStyle(),
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      validator: (value) => value!.length < 8
                          ? 'Введіть пароль з 8+ символами'
                          : null,
                      decoration:
                          textInputDecoration.copyWith(hintText: "Пароль"),
                      obscureText: true,
                      style: const TextStyle(),
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      validator: (value) =>
                          value != password ? 'Різниця між паролями!' : null,
                      decoration: textInputDecoration.copyWith(
                          hintText: "Повторіть пароль"),
                      obscureText: true,
                      style: const TextStyle(),
                      onChanged: (val) {
                        setState(() {
                          repeatedPassword = val;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: 180,
                      height: 40,
                      child: TextButton(
                        onPressed: () async {
                          try {
                            if (_formSignUpKey.currentState!.validate()) {
                              dynamic result = await _auth.register(
                                  name, age, password, email, file!);
                              if (result == null) {
                                setState(() {
                                  error = "ERROR";
                                });
                              } else {
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                              }
                            }
                            // ignore: empty_catches
                          } catch (e) {}
                        },
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(
                                AppTheme.textColor),
                            // ignore: prefer_const_constructors
                            backgroundColor:
                                const MaterialStatePropertyAll<Color>(
                                    AppTheme.secondBackgroundColor)),
                        child: const Text(
                          'Увійти',
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            isLoginScreen = !isLoginScreen;
                          });
                        },
                        child: const Text(
                          'У мене є акаунт',
                          style:
                              TextStyle(color: AppTheme.secondBackgroundColor),
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
