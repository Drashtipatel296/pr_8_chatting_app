import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pr_8_chatting_app/controller/auth_controller.dart';
import 'package:pr_8_chatting_app/helper/firebase_notification_services.dart';
import 'package:pr_8_chatting_app/helper/google_services.dart';
import 'package:pr_8_chatting_app/helper/user_services.dart';
import 'package:pr_8_chatting_app/model/user_model.dart';
import 'package:pr_8_chatting_app/view/home/home_screen.dart';
import 'package:pr_8_chatting_app/view/signup/signup_screen.dart';
import 'package:pr_8_chatting_app/view/widgets/textfield_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 70),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Log in to Chatbox',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    'Welcome back! Sign in using your social account or email to continue us',
                    style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13),
                  ),
                ),
                const SizedBox(
                  height: 40,
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
                        String? deviceToken = await FirebaseNotificationServices.firebaseNotificationServices.generateDeviceToken();
                        String status = await GoogleSignInServices.googleSignInServices.signInWithGoogle(context);
                        User? user = GoogleSignInServices.googleSignInServices.currentUser();
                        Map m1 = {
                          'name': user!.displayName,
                          'email': user.email,
                          'photoUrl': user.photoURL,
                          'token' : deviceToken,
                        };
                        UserModel userModel = UserModel.fromMap(m1);
                        await UserServices.userServices.addUser(userModel);

                        Fluttertoast.showToast(msg: status);
                        if (status == 'Success') {
                          Get.to(HomeScreen());
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: const Color(0xffA8B0AF), width: 1),
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
                  height: 40,
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
                  height: 40,
                ),
                TextFieldSection(
                  controller: controller.txtEmail,
                  labelText: 'Your email',
                  textInputType: TextInputType.text,
                ),
                const SizedBox(
                  height: 40,
                ),
                TextFieldSection(
                  controller: controller.txtPassword,
                  labelText: 'Password',
                  textInputType: TextInputType.number,
                ),
                const SizedBox(
                  height: 150,
                ),
                GestureDetector(
                  onTap: () {
                    controller.signInMethod(controller.txtEmail.text, controller.txtPassword.text);
                    controller.txtEmail.clear();
                    controller.txtPassword.clear();
                  },
                  child: Container(
                    height: 55,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xff24786D),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Log in',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Forgot password?',
                      style: GoogleFonts.poppins(
                          color: const Color(0xff24786D),
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    TextButton(onPressed: () {
                      Get.to(const SignupScreen());
                    }, child: Text('Sign Up',style: GoogleFonts.poppins(fontWeight: FontWeight.w500),),),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
