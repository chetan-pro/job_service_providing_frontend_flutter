// ignore_for_file: must_be_immutable, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hindustan_job/candidate/candidateWidget/icon_widget.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/drawer/mywallet_bank_details.dart';
import 'package:hindustan_job/candidate/pages/side_drawerpages/notification.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/utility/function_utility.dart';

class CustomAppBarService extends StatefulWidget
    implements PreferredSizeWidget {
  GlobalKey<ScaffoldState> drawerKey;
  TabBar? tab;
  String? back;
  BuildContext context;
  CustomAppBarService(
      {Key? key,
      required this.drawerKey,
      this.tab,
      this.back,
      required this.context})
      : preferredSize =
            Size.fromHeight(!Responsive.isDesktop(context) ? 180.0 : 150),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  _CustomAppBarServiceState createState() => _CustomAppBarServiceState();
}

class _CustomAppBarServiceState extends State<CustomAppBarService> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: !Responsive.isDesktop(context) ? 120 : 60,
      iconTheme: IconThemeData(color: MyAppColor.blackdark),
      backgroundColor: MyAppColor.backgroundColor,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 18, left: 5),
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
          padding: const EdgeInsets.only(top: 18, right: 25),
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
        preferredSize: Size.fromHeight(Responsive.isDesktop(context) ? 0 : 40),
      ),
    );
  }

  Container _menu(context) {
    return Container(
      width: Responsive.isDesktop(context) ? Sizeconfig.screenWidth! / 3 : null,
      child: Padding(
        padding: Responsive.isDesktop(context)
            ? const EdgeInsets.all(.0)
            : const EdgeInsets.only(bottom: 8.0),
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
                      "Job-seeker \n Account",
                      textAlign: TextAlign.center,
                      style: Responsive.isDesktop(context)
                          ? orangeLightM14()
                          : orangeDarkSb10(),
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
                    Text("Home-Service \n Provider",
                        textAlign: TextAlign.center,
                        style: Responsive.isDesktop(context)
                            ? blackRegularGalano14
                            : blackDarkSb10())
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
                      "Home-Service \n Seeker",
                      textAlign: TextAlign.center,
                      style: Responsive.isDesktop(context)
                          ? blackRegularGalano14
                          : blackDarkSb10(),
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
                      "Local Hunar \n Account",
                      textAlign: TextAlign.center,
                      style: Responsive.isDesktop(context)
                          ? blackRegularGalano14
                          : blackDarkSb10(),
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
        height: Sizeconfig.screenHeight! / 20,
        color: MyAppColor.greynormal,
        child: Row(
          children: [
            const SizedBox(
              width: 5,
            ),
            SizedBox(
              height: 30,
              child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: MyAppColor.backgray,
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 17,
                      color: Colors.black,
                    ),
                  )),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "Back",
              style: TextStyle(
                color: MyAppColor.blackdark,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(pageRouteText,
                style: GoogleFonts.darkerGrotesque(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
