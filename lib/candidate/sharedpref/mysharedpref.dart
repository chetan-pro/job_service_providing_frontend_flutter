import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreference {
  static const EMAIL = 'user_email';

  static addStringToSF(String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(EMAIL, data);
  }

  static getStringValuesSF(String key) async {
    SharedPreferences prefs1 = await SharedPreferences.getInstance();
    String? stringValue1 = prefs1.getString(key);
    return stringValue1;
  }

  static removeValues(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
