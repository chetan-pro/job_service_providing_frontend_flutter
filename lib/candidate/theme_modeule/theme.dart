import 'package:flutter/material.dart';
import 'package:hindustan_job/constants/colors.dart';

class Mytheme {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
        indicatorColor: MyAppColor.greynormal,
        primarySwatch: Colors.deepPurple,
        cardColor: Colors.white,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        textTheme: TextTheme(
          headline1: TextStyle(
              color: MyAppColor.blackdark,
              fontSize: 16,
              fontFamily: 'Darker Grotesque',
              fontWeight: FontWeight.w600),
          headline2: TextStyle(
              color: MyAppColor.blackdark,
              fontSize: 12,
              fontFamily: 'Darker Grotesque',
              fontWeight: FontWeight.w500),
          headline3: TextStyle(
              color: MyAppColor.blackdark,
              fontSize: 10,
              fontFamily: 'Darker Grotesque',
              fontWeight: FontWeight.w600),
          headline4: TextStyle(
              color: MyAppColor.white,
              fontSize: 10,
              fontFamily: 'Darker Grotesque',
              fontWeight: FontWeight.w400),
          headline5: TextStyle(
              color: MyAppColor.blackdark,
              fontSize: 16,
              fontFamily: 'Darker Grotesque',
              fontWeight: FontWeight.w500),
          headline6: const TextStyle(fontSize: 28, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(
            fontSize: 14,
          ),
        ),
      );
}
