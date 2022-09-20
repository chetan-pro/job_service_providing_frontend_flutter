import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/pages/login_page/login_page.dart';
import 'package:hindustan_job/candidate/pages/register_page/register_page.dart';
import 'package:hindustan_job/candidate/pages/side_drawerpages/privacypolicy.dart';
import 'package:hindustan_job/candidate/pages/side_drawerpages/termscondition.dart';
import 'package:hindustan_job/candidate/routes/routes.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/services/auth/auth_services.dart';

//added by oshin
//date - 28march2022
class DrawerLandingPage extends StatelessWidget {
  final tabIndex;
  DrawerLandingPage({Key? key, this.tabIndex}) : super(key: key);
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    final styles = Mytheme.lightTheme(context).textTheme.headline1!;
    return Container(
      color: MyAppColor.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        child: Center(
          child: ListView(
            ///  shrinkWrap: false,
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                  decoration: BoxDecoration(
                    color: MyAppColor.backgroundColor,
                  ),
                  child: const SizedBox()),
              Container(
                margin: EdgeInsets.only(top: 150),
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      tabIndex == 2
                          ? ListTile(
                              title: Row(
                                children: [
                                  const Icon(
                                    Icons.featured_play_list_sharp,
                                    size: 22,
                                  ),
                                  const SizedBox(
                                    width: 13,
                                  ),
                                  Text(
                                    'My Transactions',
                                    style: blackDarkM16(),
                                  ),
                                ],
                              ),
                              onTap: () {
                                !Responsive.isDesktop(context)
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Login()))
                                    : showDialog(
                                        context: context,
                                        builder: (_) => Container(
                                          constraints: BoxConstraints(
                                              maxWidth:
                                                  Sizeconfig.screenWidth! /
                                                      2.9),
                                          child: Dialog(
                                            elevation: 0,
                                            backgroundColor: Colors.transparent,
                                            insetPadding: EdgeInsets.symmetric(
                                                horizontal:
                                                    Sizeconfig.screenWidth! /
                                                        2.9,
                                                vertical: 30),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(00),
                                            ),
                                            child: Container(
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    color: Colors.transparent,
                                                    margin:
                                                        const EdgeInsets.only(
                                                      right: 25,
                                                    ),
                                                    child: Login(),
                                                  ),
                                                  Positioned(
                                                    right: 0.0,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Container(
                                                        height: 25,
                                                        width: 25,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        color: MyAppColor
                                                            .backgroundColor,
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: Image.asset(
                                                            'assets/back_buttons.png'),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                              },
                            )
                          : Container(),
                      ListTile(
                        title: Row(
                          children: [
                            SizedBox(
                                height: 24,
                                width: 22,
                                child: Image.asset('assets/logout.png')),
                            const SizedBox(
                              width: 13,
                            ),
                            Text(
                              'Log Out',
                              style: blackDarkM16(),
                            ),
                          ],
                        ),
                        onTap: () {
                          !Responsive.isDesktop(context)
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Signup(isUserSocialLogin: false)))
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
                                          margin:
                                              const EdgeInsets.only(right: 25),
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
                                              padding: const EdgeInsets.all(5),
                                              color: MyAppColor.backgroundColor,
                                              alignment: Alignment.topRight,
                                              child: Image.asset(
                                                  'assets/back_buttons.png'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                        },
                      ),
                    ],
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
