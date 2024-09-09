import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ThemeController extends GetxController {
  var isDarkTheme = false.obs;

  void toggleTheme() {
    isDarkTheme.value = !isDarkTheme.value;
  }

  IconData get themeIcon => isDarkTheme.value ? Icons.nights_stay : Icons.light_mode;

  Color get containerColor => isDarkTheme.value ? Colors.grey.shade100.withOpacity(0.1) : Colors.grey.shade300.withOpacity(0.3);

  ThemeData get theme => isDarkTheme.value ? ThemeData.dark() : ThemeData.light();
}
