import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pr_8_chatting_app/controller/auth_controller.dart';
import 'package:pr_8_chatting_app/helper/firebase_notification_services.dart';
import 'package:pr_8_chatting_app/helper/user_services.dart';
import 'package:pr_8_chatting_app/model/user_model.dart';
import 'package:pr_8_chatting_app/view/widgets/textfield_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

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
                    'Sign up with Email',
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
                    'Get chatting with friends and family today by signing up for our chat app!',
                    style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13),
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                TextFieldSection(
                  controller: controller.txtName,
                  labelText: 'Your name',
                  textInputType: TextInputType.text,
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
                  textInputType: TextInputType.text,
                ),
                const SizedBox(
                  height: 40,
                ),
                TextFieldSection(
                  controller: controller.txtConfirmPassword,
                  labelText: 'Confirm Password',
                  textInputType: TextInputType.text,
                ),
                const SizedBox(
                  height: 120,
                ),
                GestureDetector(
                  onTap: () async {

                    String? deviceToken = await FirebaseNotificationServices.firebaseNotificationServices.generateDeviceToken();

                    Map m1 = {
                      'name' : controller.txtName.text,
                      'email' : controller.txtEmail.text,
                      'photoUrl' : 'https://www.robertlowdon.com/wp-content/uploads/2022/06/toronto-headshot.webp',
                      'token' : deviceToken,
                    };
                    UserModel userModel = UserModel.fromMap(m1);
                    UserServices.userServices.addUser(userModel);
                    controller.signUpMethod(controller.txtEmail.text, controller.txtPassword.text);

                    controller.txtEmail.clear();
                    controller.txtPassword.clear();
                    controller.txtName.clear();
                    controller.txtConfirmPassword.clear();
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
                      'Create an account',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
