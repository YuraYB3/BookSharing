// ignore_for_file: file_names

import 'dart:async';
import 'package:booksshare/Screens/Home/homePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../Models/userModel.dart';
import '../../Shared/appTheme.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
          const Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    final CollectionReference userReqRef =
        FirebaseFirestore.instance.collection('users');
    final DocumentReference userReqDocRef =
        userReqRef.doc(FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      try {
        userReqDocRef.update({'emailVerified': true});
        Fluttertoast.showToast(
          msg: 'Підтверджено!',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color.fromARGB(255, 47, 231, 93),
          textColor: Colors.white,
        );
      } catch (e) {
        print(e);
      }
      timer?.cancel();
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Лист вже надіслано! Спробуйте пізніше!',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 181, 25, 25),
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
                    'Підтвердіть електронну адресу',
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
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.secondBackgroundColor,
                          minimumSize: const Size.fromHeight(50)),
                      icon: const Icon(Icons.email_outlined),
                      label: const Text("Надіслати лист"),
                      onPressed: sendVerificationEmail,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                        },
                        child: const Text(
                          "Повернутись до входу",
                          style: TextStyle(
                              color: AppTheme.secondBackgroundColor,
                              fontSize: 18),
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      );
}
