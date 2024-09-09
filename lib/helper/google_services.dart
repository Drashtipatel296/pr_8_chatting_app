import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInServices {
  static GoogleSignInServices googleSignInServices = GoogleSignInServices._();

  GoogleSignInServices._();

  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<String> signInWithGoogle(BuildContext context) async {
    try {
      await InternetAddress.lookup('google.com');
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );
      await firebaseAuth.signInWithCredential(authCredential);
      return "Success";
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Something went wrong (Check Internet!!)',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Color(0xff20A090),
          behavior: SnackBarBehavior.floating,
        ),
      );
      log(e.toString());
      return "Failed";
    }
  }

  void showProgressBar(BuildContext context){
    showDialog(context: context, builder: (context) => Center(child: CircularProgressIndicator(),),);
  }

  void emailLogout() {
    googleSignIn.signOut();
    firebaseAuth.signOut();
  }

  User? currentUser() {
    User? user = firebaseAuth.currentUser;
    if (user != null) {
      print(user.email);
      print(user.displayName);
      print(user.photoURL);
    }
    return user;
  }
}
