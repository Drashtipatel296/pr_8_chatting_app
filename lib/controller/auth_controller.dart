import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pr_8_chatting_app/helper/auth_services.dart';
import 'package:pr_8_chatting_app/helper/chat_services.dart';
import 'package:pr_8_chatting_app/helper/google_services.dart';
import 'package:pr_8_chatting_app/helper/media_services.dart';
import 'package:pr_8_chatting_app/view/home/home_screen.dart';

class AuthController extends GetxController {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();
  TextEditingController txtMsg = TextEditingController();
  TextEditingController txtEditMsg = TextEditingController();

  RxString email = "".obs;
  RxString name = "".obs;
  RxString url = "".obs;
  RxString receiverEmail = "".obs;
  RxString receiverName = "".obs;
  RxString currentLogin=''.obs;
  RxString callId =''.obs;
  RxString receiverImageUrl = "".obs;
  RxString receiverToken = "".obs;

  @override
  void onInit() {
    super.onInit();
    getUserDetailes();
  }

  void getReceiver(String email, String name, String url, String token){
    receiverEmail.value = email;
    receiverName.value = name;
    receiverImageUrl.value = url;
    receiverToken.value = token;
    update();
  }

  void getUserDetailes() {
    User? user = GoogleSignInServices.googleSignInServices.currentUser();
    if (user != null) {
      email.value = user.email ?? '';
      name.value = user.displayName ?? '';
      url.value = user.photoURL ?? '';
      update();
    } else {
      print('No user is currently logged in.');
    }
  }


  bool validateSignUpForm() {
    if (txtEmail.text.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Email cannot be empty.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } else if (!txtEmail.text.contains('@gmail.com')) {
      Get.snackbar(
        'Validation Error',
        'Please enter a valid Gmail address (e.g., user@gmail.com).',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } else if (txtPassword.text.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Password cannot be empty.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } else if (txtPassword.text != txtConfirmPassword.text) {
      Get.snackbar(
        'Password Mismatch',
        'Password and Confirm Password do not match.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    return true;
  }

  Future<void> signUpMethod(String email, String password) async {
    if (validateSignUpForm()) {
      getUserDetailes();
      try {
        bool emails = await AuthServices.authServices.checkEmail(email);
        if (emails) {
          Get.snackbar(
            'Sign Up Failed',
            'Email already in use. Please use a different email.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else {
          await AuthServices.authServices.createAccount(email, password);
          Get.snackbar(
            'Sign Up', 'Sign Up Successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          Get.to(HomeScreen());
        }
      } catch (e) {
        Get.snackbar(
          'Sign Up Failed',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  Future<void> signInMethod(String email, String password) async {
    try {
      User? user = await AuthServices.authServices.signInUser(email, password);
      if (user != null) {
        getUserDetailes();
        Get.to(HomeScreen());
      } else {
        Get.snackbar(
          'Login Failed', 'Incorrect email or password.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Login Failed', e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> emailSignOut() async {
    await AuthServices.authServices.signOutUser();
    GoogleSignInServices.googleSignInServices.emailLogout();
  }

  Future<void> sendMediaFile(File file) async {
    String? downloadUrl = await StorageServices.storageServices.uploadMediaFile(file);
    if (downloadUrl != null) {
      Map<String, dynamic> chat = {
        'sender': GoogleSignInServices.googleSignInServices.currentUser()!.email,
        'receiver': receiverEmail.value,
        'msg': 'Sent an image',
        'mediaUrl': downloadUrl,
        'timestamp': DateTime.now(),
      };
      ChatServices.chatServices.insertChat(
          chat,
          GoogleSignInServices.googleSignInServices.currentUser()!.email!,
          receiverEmail.value);
    }else{
      Get.snackbar(
        'Upload Failed',
        'Failed to upload the image. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
