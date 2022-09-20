import 'dart:convert';

import 'package:hindustan_job/candidate/model/addbank/getbank.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/services/auth/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services_constant/response_model.dart';

Data? bankadd;

UserData? userData;
String key = 'user';
String isTheme = 'isDark';
var isDarkTheme = true;

getShared() async {
  return await SharedPreferences.getInstance();
}

setUserData(UserData data) async {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;
  prefs.setString(key, json.encode(data));
  await getUserDataFromShared();
}

getUserDataFromShared() async {
  final prefs = await getShared();
  var a = prefs.getString(key);
  if (a != null) {
    userData = UserData.fromJson(json.decode(a));
  } else {
    userData = null;
  }
  return a;
}

logout() async {
  var fcmData = {"fcm_token": null};
  await fcmTokenAdded(fcmData);
  final prefs = await getShared();
  await prefs.remove(key);
  userData = null;
}

isUserData() {
  if (userData != null) {
    return true;
  } else {
    return false;
  }
}
