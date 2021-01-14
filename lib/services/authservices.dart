import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onshop/screens/home/home.dart';
import 'package:onshop/services/UserController.dart';

class AuthServices {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  UserController controller = Get.find();

  Future<UserCredential> login(String email, String password) async {
    try {
      UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return user;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<UserCredential> signUp(String email, String password) async {
    int rng = Random().nextInt(100);
    try {
      UserCredential user = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => controller.setProfile());

      return user;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> signOut(BuildContext context) async {
    await _firebaseAuth.signOut().then((value) => Navigator.of(context).pop());
  }
}
