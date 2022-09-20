
import 'dart:io';
import 'package:flutter/material.dart';

class Connection {
  static bool _isSnackbarActive = false;
  static Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (e) {
      return false;
    }
    return true;
  }

  static snackBar(BuildContext context) {
    // Connection.snackBar(context).ScaffoldMessengerState.hideCurrentSnackBar();
    if (!_isSnackbarActive) {
      _isSnackbarActive = true;
      return ScaffoldMessenger.of(context)
          .showSnackBar(
            SnackBar(
              content: const Text(
                'No Internet Connection',
                // style: CustomTextStyle.openSans11010W600(context),
              ),
              backgroundColor: Colors.white,
              behavior: SnackBarBehavior.floating,
              elevation: 5,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              duration: const Duration(seconds: 2),
            ),
          )
          .closed
          .then((SnackBarClosedReason reason) {
        _isSnackbarActive = false;
      });
    }
  }
}
