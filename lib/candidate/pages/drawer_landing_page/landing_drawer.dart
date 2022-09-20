// ignore_for_file: unused_import, prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/pages/login_page/login_page.dart';
import 'package:hindustan_job/candidate/pages/register_page/register_page.dart';
import 'package:hindustan_job/candidate/pages/side_drawerpages/aboutus.dart';
import 'package:hindustan_job/candidate/pages/side_drawerpages/contactus.dart';
import 'package:hindustan_job/candidate/pages/side_drawerpages/privacypolicy.dart';
import 'package:hindustan_job/candidate/pages/side_drawerpages/termscondition.dart';
import 'package:hindustan_job/candidate/routes/routes.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';

class DrawerLanding extends StatelessWidget {
  DrawerLanding({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    final styles = Mytheme.lightTheme(context).textTheme.headline1!;
    return Container(
      color: MyAppColor.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                  color: MyAppColor.backgroundColor,
                ),
                child: SizedBox()),
            ListTile(
                title: Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 22,
                      color: MyAppColor.blackdark.withOpacity(0.7),
                    ),
                    SizedBox(
                      width: 13,
                    ),
                    Text(
                      'Log In',
                      style: blackDarkM16(),
                    ),
                  ],
                ),
                onTap: () => loginRedirector(context)),
            ListTile(
              title: Row(
                children: [
                  Container(
                      height: 24,
                      width: 22,
                      child: Image.asset('assets/drawer-image.png')),
                  SizedBox(
                    width: 13,
                  ),
                  Text(
                    'Register',
                    style: blackDarkM16(),
                  ),
                ],
              ),
              onTap: () {
                !Responsive.isDesktop(context)
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Signup(
                                  isUserSocialLogin: false,
                                )))
                    : showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          insetPadding: EdgeInsets.symmetric(
                              horizontal: Sizeconfig.screenWidth! / 4,
                              vertical: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(00),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 25),
                                color: Colors.amber,
                                child: Signup(
                                  isUserSocialLogin: false,
                                ),
                              ),
                              Positioned(
                                right: 0.0,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    height: 25,
                                    width: 25,
                                    padding: EdgeInsets.all(5),
                                    color: MyAppColor.backgroundColor,
                                    alignment: Alignment.topRight,
                                    child:
                                        Image.asset('assets/back_buttons.png'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Container(
                      height: 24,
                      width: 22,
                      child: Image.asset('assets/subscription.png')),
                  SizedBox(
                    width: 13,
                  ),
                  Text(
                    'Subscription Plans',
                    style: blackDarkM16(),
                  ),
                ],
              ),
              onTap: () => loginRedirector(context),
            ),
            ListTile(
              title: Row(
                children: [
                  Container(
                      height: 24,
                      width: 22,
                      child: Image.asset('assets/custom.png')),
                  SizedBox(
                    width: 13,
                  ),
                  Text(
                    'Custom Job Alert',
                    style: blackDarkM16(),
                  ),
                ],
              ),
              onTap: () => loginRedirector(context),
            ),
            ListTile(
              title: Row(
                children: [
                  Container(
                      height: 24,
                      width: 22,
                      child: Image.asset('assets/about-us.png')),
                  SizedBox(
                    width: 13,
                  ),
                  Text(
                    'About Us',
                    style: blackDarkM16(),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AboutUs(
                              passkey: "about_us",
                            )));
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Container(
                      height: 24,
                      width: 22,
                      child: Image.asset('assets/contact-us.png')),
                  SizedBox(
                    width: 13,
                  ),
                  Text(
                    'Contact Us',
                    style: blackDarkM16(),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Contact()));
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Container(
                    height: 24,
                    width: 22,
                    child: Image.asset('assets/drawer-icons.png'),
                  ),
                  SizedBox(
                    width: 13,
                  ),
                  Text(
                    'Privacy Policy',
                    style: blackDarkM16(),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PrivacyPolicy()));
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Container(
                      height: 24,
                      width: 22,
                      child: Image.asset('assets/drawer-icon.png')),
                  SizedBox(
                    width: 13,
                  ),
                  Text(
                    'Terms & Conditions',
                    style: blackDarkM16(),
                  ),
                ],
              ),
              onTap: () {
                // _key.currentState!.openEndDrawer();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TermsCondition()));
              },
            ),
          ],
        ),
      ),
    );
  }

  loginRedirector(context) {
    return !Responsive.isDesktop(context)
        ? Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()))
        : showDialog(
            context: context,
            builder: (_) => Container(
              constraints:
                  BoxConstraints(maxWidth: Sizeconfig.screenWidth! / 2.9),
              child: Dialog(
                elevation: 0,
                backgroundColor: Colors.transparent,
                insetPadding: EdgeInsets.symmetric(
                    horizontal: Sizeconfig.screenWidth! / 2.9, vertical: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(00),
                ),
                child: Stack(
                  children: [
                    Container(
                      color: Colors.transparent,
                      margin: EdgeInsets.only(
                        right: 25,
                      ),
                      child: Login(),
                    ),
                    Positioned(
                      right: 0.0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 25,
                          width: 25,
                          padding: EdgeInsets.all(5),
                          color: MyAppColor.backgroundColor,
                          alignment: Alignment.topRight,
                          child: Image.asset('assets/back_buttons.png'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
