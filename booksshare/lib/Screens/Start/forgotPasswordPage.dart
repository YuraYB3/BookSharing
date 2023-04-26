// ignore_for_file: file_names

import 'package:booksshare/Shared/appTheme.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Shared/constants.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailControler = TextEditingController();

  @override
  void dispose() {
    emailControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.secondBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            height: 400,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(30)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Введіть email \n Для відновлення паролю',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 24,
                      color: AppTheme.secondBackgroundColor,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: emailControler,
                    decoration:
                        textInputDecoration.copyWith(hintText: "E-Mail"),
                    textInputAction: TextInputAction.done,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) =>
                        email != null && !EmailValidator.validate(email)
                            ? "Введіть правильний email"
                            : null,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.secondBackgroundColor,
                        minimumSize: const Size.fromHeight(50)),
                    icon: const Icon(Icons.email_outlined),
                    label: const Text("Відновити пароль"),
                    onPressed: resetPassword,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future resetPassword() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailControler.text.trim());
      Fluttertoast.showToast(
        msg: 'Лист відправлено!',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 29, 200, 38),
        textColor: Colors.white,
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: e.message.toString(),
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 181, 25, 25),
        textColor: Colors.white,
      );
    }
  }
}
