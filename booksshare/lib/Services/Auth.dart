// ignore_for_file: file_names

import 'package:booksshare/Models/userModel.dart';
import 'package:booksshare/Services/DatabaseUser.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? _userFromFirebase(User? user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

  Future register(
      String email, String password, String name, String surname) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      await DatabaseUserService(uid: user?.uid)
          .updateUserData(name, surname, email);
      return _userFromFirebase(user);
    } catch (e) {
      return null;
    }
  }

  Future signInWithPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebase(user);
    } catch (e) {
      return null;
    }
  }

  String? getUserID() {
    return _auth.currentUser?.uid;
  }
}
