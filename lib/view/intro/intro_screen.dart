import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pr_8_chatting_app/controller/auth_controller.dart';
import 'package:pr_8_chatting_app/helper/firebase_notification_services.dart';
import 'package:pr_8_chatting_app/helper/google_services.dart';
import 'package:pr_8_chatting_app/helper/user_services.dart';
import 'package:pr_8_chatting_app/model/user_model.dart';
import 'package:pr_8_chatting_app/view/home/home_screen.dart';
import 'package:pr_8_chatting_app/view/login/login_screen.dart';
import 'package:pr_8_chatting_app/view/signup/signup_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    var controller = Get.put(AuthController());
    final currentUser = GoogleSignInServices.googleSignInServices.currentUser();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 70, left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 28,
                  width: 38,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/img/c1.png'),
                    ),
                  ),
                ),
                Text(
                  'Chatbox',
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Connect\nfriends',
              style: GoogleFonts.poppins(
                fontSize: 60,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'easily &\nquickly',
              style: GoogleFonts.poppins(
                fontSize: 60,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Our chat app is the perfect way to stay\nconnected with friends and family.',
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: const Color(0xffA8B0AF), width: 1),
                  ),
                  child: Image.asset('assets/img/facbook.png'),
                ),
                const SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    // Show the progress bar
                    GoogleSignInServices.googleSignInServices.showProgressBar(context);

                    // Perform Google sign-in
                    String status = await GoogleSignInServices.googleSignInServices.signInWithGoogle(context);

                    // Close the progress bar dialog
                    Navigator.of(context).pop();

                    String? deviceToken = await FirebaseNotificationServices.firebaseNotificationServices.generateDeviceToken();

                    User? user = GoogleSignInServices.googleSignInServices.currentUser();
                    Map m1 = {
                      'name': user!.displayName,
                      'email': user.email,
                      'photoUrl': user.photoURL,
                      'token' : deviceToken,
                    };
                    UserModel userModel = UserModel.fromMap(m1);
                    await UserServices.userServices.addUser(userModel);

                    // Show toast message
                    Fluttertoast.showToast(msg: status);
                    if (status == 'Success') {
                      Get.to(HomeScreen()
                      );
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xffA8B0AF), width: 1),
                    ),
                    child: Image.asset('assets/img/google.png'),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: const Color(0xffA8B0AF), width: 1),
                  ),
                  child: Image.asset('assets/img/applelogo.png'),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.grey.shade300,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'OR',
                  style: GoogleFonts.poppins(),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Divider(
                    color: Colors.grey.shade300,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                Get.to(const SignupScreen());
              },
              child: Container(
                height: 55,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Sign up with Email',
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Existing account?',
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.w400),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),);
                  },
                  child: Text(
                    'Login',
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
