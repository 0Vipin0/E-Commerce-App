import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  ThemeData currentTheme;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Future<void> onInit() async {
    final String currentThemePrefs = await _prefs.then(
        (SharedPreferences prefs) =>
            prefs.getString('current_theme') ?? 'dark');
    currentTheme =
        currentThemePrefs == 'dark' ? ThemeData.dark() : ThemeData.light();
    update();
    super.onInit();
  }

  Future<void> switchTheme() async {
    final SharedPreferences prefs = await _prefs;
    if (Get.isDarkMode) {
      Get.changeTheme(ThemeData.light());
      await prefs.setString('current_theme', 'light');
    } else {
      Get.changeTheme(ThemeData.dark());
      await prefs.setString('current_theme', 'dark');
    }
  }
}
