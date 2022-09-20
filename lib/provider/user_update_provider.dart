import 'package:flutter/cupertino.dart';

import '../candidate/model/user_model.dart';

class UserDataChangeNotifier extends ChangeNotifier {
  UserDataChangeNotifier();

  UserData? user;
  updateUserData(userData) {
    user = userData;
    notifyListeners();
  }
}
