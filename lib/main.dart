import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pr_8_chatting_app/controller/theme_controller.dart';
import 'package:pr_8_chatting_app/helper/google_services.dart';
import 'package:pr_8_chatting_app/model/user_model.dart';
import 'package:pr_8_chatting_app/view/home/home_screen.dart';
import 'package:pr_8_chatting_app/view/intro/intro_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    return Obx(
      () => GetMaterialApp(
        title: 'Messaging - Chatbox',
        theme: themeController.theme,
        debugShowCheckedModeBanner: false,
        home: GoogleSignInServices.googleSignInServices.currentUser() == null ? const IntroScreen() : HomeScreen(),
      ),
    );
  }
}

