import 'package:interestchat/model/user.dart';
//import 'package:chatapp/views/chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:interestchat/helper/constants.dart';
import 'package:interestchat/helper/helperfunctions.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  DUser _userfromFirebaseuser(User user) {
    return user != null ? DUser(uid: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User firebaseUser = result.user;
      return _userfromFirebaseuser(firebaseUser);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User firebaseUser = result.user;
      return _userfromFirebaseuser(firebaseUser);
    } catch (e) {
      print(e.toString());
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      HelperFunctions.saveUserLoggedInSharedPreference(false);
      return await _auth.signOut;
    } catch (e) {
      print(e.toString());
    }
  }
}
