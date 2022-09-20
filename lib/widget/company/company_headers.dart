import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';

GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
appBar(
  context, {
  String? text,
}) {
  Sizeconfig().init(context);
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (!Responsive.isDesktop(context))
        SizedBox(
          height: Sizeconfig.screenHeight! / 50,
        ),
      Padding(
        padding: Responsive.isDesktop(context)
            ? EdgeInsets.symmetric(vertical: 22.0, horizontal: 30)
            : EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                InkWell(
                  hoverColor: Colors.transparent,
                  onTap: () {
                    _drawerKey.currentState!.openDrawer();
                  },
                  child: Image.asset(
                    'assets/drawers.png',
                    height: 19,
                  ),
                ),
                SizedBox(
                  width: !Responsive.isDesktop(context)
                      ? Sizeconfig.screenWidth! / 35
                      : Sizeconfig.screenWidth! / 100,
                ),
                Image.asset(
                  'assets/hind.png',
                  height: 40,
                ),
              ],
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: Image.asset(
                    'assets/notificationiocn.png',
                    width: 20,
                    height: 20,
                  ),
                ),
                SizedBox(
                  width: 25,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Company Profile',
                      style: !Responsive.isDesktop(context)
                          ? grayLightM14()
                          : grayLightM12(),
                    ),
                  ],
                ),
                SizedBox(
                  width: 8,
                ),
                CircleAvatar(
                  backgroundColor: MyAppColor.white,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/profileIcon.png',
                      height: 36,
                      width: 36,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      SizedBox(
        height: 5,
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 3, vertical: 8),
        color: MyAppColor.greynormal,
        child: Row(
          children: [
            SizedBox(
              width: 2,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: !Responsive.isDesktop(context) ? 27 : 22,
                child: CircleAvatar(
                    backgroundColor: MyAppColor.backgray,
                    child: Icon(
                      Icons.arrow_back,
                      size: !Responsive.isDesktop(context) ? 21 : 18,
                      color: Colors.black,
                    )),
              ),
            ),
            SizedBox(
              width: !Responsive.isDesktop(context) ? 3 : 00,
            ),
            Text("Back", style: grayLightM12()),
            SizedBox(
              width: !Responsive.isDesktop(context) ? 20 : 50,
            ),
            Text(
              text!,
              style: !Responsive.isDesktop(context)
                  ? grayLightOpacityM10()
                  : grayLightOpacityM8(),
            ),
          ],
        ),
      ),
    ],
  );
}
