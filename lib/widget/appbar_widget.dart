import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/pages/side_drawerpages/notification.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/utility/function_utility.dart';

AppBar appbar(context, _drawerKey, _menu) => AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: !Responsive.isDesktop(context) ? 120 : 58,
      iconTheme: IconThemeData(color: MyAppColor.blackdark),
      backgroundColor: MyAppColor.backgroundColor,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 18),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                _drawerKey.currentState!.openDrawer();
              },
              child: Image.asset(
                'assets/drawers.png',
                height: 18,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              height: 40,
              width: 40,
              child: Image.asset(
                'assets/logosmall.png',
                fit: BoxFit.cover,
              ),
            ),
            if (Responsive.isDesktop(context))
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _menu(),
                ],
              )),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 18),
          child: Row(
            children: [
              Image.asset(
                'assets/walleticon.png',
                width: 20,
                height: 20,
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationScreen()));
                },
                child: Image.asset(
                  'assets/notificationiocn.png',
                  width: 20,
                  height: 20,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: CircleAvatar(
                  child: ClipOval(
                    child: currentUrl(userData!.image) != null
                        ? Image.network(
                            "${currentUrl(userData!.image)}",
                            height: 36,
                            width: 36,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/profileIcon.png',
                            height: 36,
                            width: 36,
                            fit: BoxFit.cover,
                          ),
                  ),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ],
      bottom: PreferredSize(
        child: Column(
          children: [
            if (!Responsive.isDesktop(context)) _menu(),
            SizedBox(
              height: 10,
            ),
            if (!Responsive.isDesktop(context))
              Container(
                height: 40,
                color: MyAppColor.grayplane,
                // child: _tab(),
              ),
            if (Responsive.isDesktop(context))
              Stack(
                children: [
                  Container(
                    height: 35,
                    color: MyAppColor.grayplane,
                    width: double.infinity,
                  ),
                  Positioned(
                    left: 25,
                    child: Container(
                      height: 35,
                      width: Sizeconfig.screenWidth! / 3,
                      color: MyAppColor.grayplane,
                      // child: _t/ab(),
                    ),
                  ),
                ],
              ),
          ],
        ),
        preferredSize: Size.fromHeight(60),
      ),
    );
