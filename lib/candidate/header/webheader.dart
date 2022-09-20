// ignore_for_file: must_be_immutable, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/candidateWidget/icon_widget.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/drawer/mywallet_bank_details.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/pages/side_drawerpages/notification.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/utility/function_utility.dart';

class CustomAppBarWeb extends StatefulWidget implements PreferredSizeWidget {
  GlobalKey<ScaffoldState> drawerKey;
  TabBar? tab;
  String? back;
  CustomAppBarWeb({Key? key, required this.drawerKey, this.tab, this.back})
      : preferredSize = const Size.fromHeight(180.0),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  _CustomAppBarWebState createState() => _CustomAppBarWebState();
}

class _CustomAppBarWebState extends State<CustomAppBarWeb> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
                widget.drawerKey.currentState!.openDrawer();
              },
              child: Image.asset(
                'assets/drawers.png',
                height: 22,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              height: 42,
              width: 42,
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
                  _menu(context),
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
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyWallet()));
                },
                icon: IconWidget(
                  url: 'assets/walleticon.png',
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationScreen(),
                    ),
                  );
                },
                child: IconWidget(
                  url: 'assets/notificationiocn.png',
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Consumer(builder: (context, ref, child) {
                  // if(mounted){
                  // int profilePercent =
                  //     ref.watch(editProfileData).calculateProfilePercent();
                  // }
                  return CircleAvatar(
                    child: ClipOval(
                      child: currentUrl(userData!.image) != null
                          ? Image.network(
                              "${currentUrl(userData!.image)}",
                              height: 36,
                              width: 36,
                              fit: BoxFit.cover,
                            errorBuilder: (BuildContext context,
                                            Object exception,
                                            StackTrace? stackTrace) {
                                          return Image.asset(
                                            'assets/profileIcon.png',
                                            height: 36,
                                            width: 36,
                                            fit: BoxFit.cover,
                                          );
                                        },
                            )

                          : Image.asset(
                              'assets/profileIcon.png',
                              height: 36,
                              width: 36,
                              fit: BoxFit.cover,
                            ),
                    ),
                    backgroundColor: Colors.transparent,
                  );
                }),
              ),
            ],
          ),
        ),
      ],
      bottom: PreferredSize(
        child: Column(
          children: [
            if (!Responsive.isDesktop(context)) _menu(context),
            const SizedBox(
              height: 10,
            ),
            if (!Responsive.isDesktop(context))
              if (widget.tab != null)
                Container(
                  height: 50,
                  // width: MediaQuery.of(context).size.width,
                  color: MyAppColor.grayplane,
                  child: widget.tab,
                ),
            if (widget.back != null)
              Container(
                height: 50,
                color: MyAppColor.grayplane,
                child: _back(widget.back),
              ),
            if (Responsive.isDesktop(context))
              if (widget.tab != null)
                Stack(
                  children: [
                    Container(
                      height: 40,
                      color: MyAppColor.grayplane,
                      width: double.infinity,
                    ),
                    Positioned(
                      left: 25,
                      child: Container(
                        height: 40,
                        width: Sizeconfig.screenWidth! / 2.5,
                        color: MyAppColor.grayplane,
                        child: widget.tab,
                      ),
                    ),
                  ],
                ),
          ],
        ),
        preferredSize: const Size.fromHeight(40),
      ),
    );
  }

  Container _menu(context) {
    return Container(
      width: Responsive.isDesktop(context) ? Sizeconfig.screenWidth! / 3 : null,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 2, right: 2),
                child: Column(
                  children: [
                    Container(
                      height: 3,
                      color: MyAppColor.orangelight,
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      "Job-seeker Account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: MyAppColor.orangelight),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 2, right: 2),
                child: Column(
                  children: [
                    Container(
                      height: 3,
                      color: MyAppColor.greynormal,
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      "Home-service provider",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 11,
                          color: MyAppColor.normalblack,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 2, right: 2),
                child: Column(
                  children: [
                    Container(
                      height: 3,
                      color: MyAppColor.greynormal,
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      "Home-service seeker",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: MyAppColor.normalblack,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 2, right: 2),
                child: Column(
                  children: [
                    Container(
                      height: 3,
                      color: MyAppColor.greynormal,
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      "Local Hunar Account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: MyAppColor.normalblack,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _back(pageRouteText) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
        color: MyAppColor.greynormal,
        child: Row(
          children: [
            const SizedBox(
              width: 2,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeAppBar(Container(),1),
                  ),
                );
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
              pageRouteText,
              style: blackDarkOpacityM10(),
            ),
          ],
        ),
      ),
    );
  }
}
