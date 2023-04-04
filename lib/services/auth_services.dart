import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:secureshare/screens/auth/login_screen.dart';

import '../helper/common.dart';
import '../services/database_service.dart';

class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final storage = const FlutterSecureStorage();

  //login
  Future signInwithEmailandPassword(String email, String password) async {
    try {
      auth.User user = (await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        return true;
      }
    } on auth.FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //register
  Future registerUserWithEmailandPassword(
      String name, String email, String password, String phone) async {
    try {
      auth.User user = (await _firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        //call our database service to save the user data.
        await DatabaseService(uid: user.uid).savingUserData(name, email, phone);
        return true;
      }
    } on auth.FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //signout

  Future singOut(context) async {
    try {
      // await storage.delete(key: 'email');
      // await storage.delete(key: 'password');
      // await storage.delete(key: 'usingbiometric');
      await _firebaseAuth.signOut();
      Navigator.pushNamedAndRemoveUntil(
          context, LoginScreen.routeName, (route) => false);
    } on auth.FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //reset password
  Future resetPassword(String email, context) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email).then((value) {
        showSnakBar(context, Colors.black,
            "We have sent you email to recover password, please check your email");
      });
    } on auth.FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
