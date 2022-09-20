import 'package:flutter/material.dart';

class Sizeconfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? blockHorizental;
  static double? blockVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenHeight = _mediaQueryData!.size.height;
    screenWidth = _mediaQueryData!.size.width;
    blockHorizental = screenHeight! / 100;
    blockVertical = screenWidth! / 100;
  }
}
