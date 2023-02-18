import 'package:chat_system/helper/helper_function.dart';
import 'package:chat_system/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final firebaseAuth = FirebaseAuth.instance;

  // Login User:
  Future loginWithEmailAndPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      return e.message;
    }
  }

  // Register User:
  Future registerWithEmailAndPassword(
      String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        // Call our database service to update the data:

        await DatabaseService(uid: user.uid)
            .saveUserDataInDatabase(fullName, email, password);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      return e.message;
    }
  }

  // SignOut User:
  Future signOut() async {
    try {
      await HelperFunction.saveUserLoggedInStatus(false);
      await HelperFunction.saveUserNameSF('');
      await HelperFunction.saveUSerEmailSF('');

      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
