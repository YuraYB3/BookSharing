// ignore_for_file: file_names

// ignore: use_key_in_widget_constructors
import 'package:flutter/material.dart';

import '../../Services/authService.dart';
import '../../Shared/appTheme.dart';
import '../../Shared/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  String email = '';
  String password = '';
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
        backgroundColor: AppTheme.secondBackgroundColor,
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
                            AppTheme.secondBackgroundColor),
                        // ignore: prefer_const_constructors
                        backgroundColor: const MaterialStatePropertyAll<Color>(
                            AppTheme.textColor)),
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
