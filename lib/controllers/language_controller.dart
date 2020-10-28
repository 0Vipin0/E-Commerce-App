import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  Locale currentLocale;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Future<void> onInit() async {
    final String currentLanguagePrefs = await _prefs.then(
        (SharedPreferences prefs) =>
            prefs.getString('current_locale') ?? 'en_US');
    currentLocale = currentLanguagePrefs == 'en_US'
        ? const Locale('en', 'US')
        : const Locale('hi', 'IN');
    print(currentLocale);
    update();
    super.onInit();
  }

  Future<void> switchLanguage() async {
    final SharedPreferences prefs = await _prefs;
    if (Get.locale == const Locale('en', 'US')) {
      Get.updateLocale(const Locale('hi', 'IN'));
      await prefs.setString("current_locale", 'hi_IN');
    } else {
      Get.updateLocale(const Locale('en', 'US'));
      await prefs.setString("current_locale", 'en_US');
    }
  }
}
