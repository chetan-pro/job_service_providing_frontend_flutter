import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget? mobile;
  final Widget? desktop;
  final Widget? tablet;
  final Widget? smallMobile;

  Responsive({this.mobile, this.desktop, this.tablet, this.smallMobile});

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 768;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1200 &&
      MediaQuery.of(context).size.width >= 768;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200 &&
      MediaQuery.of(context).size.width <= 3000;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    // If our width is more than 1200 then we consider it a desktop
    if (_size.width >= 1200 && _size.width <= 3000) {
      return desktop!;
    }
    // If width it less then 1200 and more then 768 we consider it as tablet
    else if (_size.width >= 768 && tablet != null) {
      return tablet!;
    }
    // Or less then that we called it mobile device
    else if (_size.width >= 376 && _size.width <= 768 && mobile != null) {
      return mobile!;
    } else {
      return smallMobile!;
    }
  }
}
