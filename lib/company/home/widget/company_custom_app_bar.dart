// ignore_for_file: must_be_immutable

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hindustan_job/candidate/candidateWidget/icon_widget.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/candidate/pages/side_drawerpages/notification.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/company/home/homepage.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:vrouter/vrouter.dart';

import '../../../candidate/header/app_bar.dart';

class CompanyAppBar extends StatefulWidget implements PreferredSizeWidget {
  GlobalKey<ScaffoldState> drawerKey;
  TabBar? tab;
  String? back;
  Function? profileIconClick;
  bool isWeb;
  CompanyAppBar(
      {Key? key,
      required this.drawerKey,
      this.tab,
      this.profileIconClick,
      this.back,
      required this.isWeb})
      : preferredSize = Size.fromHeight(isWeb ? 140.0 : 140.0),
        super(key: key);
  @override
  final Size preferredSize;
  @override
  State<CompanyAppBar> createState() => _CompanyAppBarState();
}

class _CompanyAppBarState extends State<CompanyAppBar> {
  @override
  Widget build(BuildContext context) {
    return !(userData!.userRoleType == RoleTypeConstant.company ||
            userData!.userRoleType == RoleTypeConstant.companyStaff)
        ? CustomAppBar(
            context: context,
            drawerKey: widget.drawerKey,
            isDisable: true,
            back: "Subscription Details",
          )
        : AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: !Responsive.isDesktop(context) ? 120 : 80,
            iconTheme: IconThemeData(color: MyAppColor.blackdark),
            backgroundColor: MyAppColor.backgroundColor,
            elevation: 0,
            title: Padding(
              padding: !Responsive.isDesktop(context)
                  ? const EdgeInsets.only(top: 18)
                  : EdgeInsets.only(left: 30, top: 20),
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
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            context.vRouter.to('/home-company');
                          },
                          child: SizedBox(
                            height: 42,
                            width: 42,
                            child: Image.asset(
                              'assets/logosmall.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Company Profile',
                              style: Mytheme.lightTheme(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(fontSize: 12),
                            ),
                            if (userData!.userRoleType ==
                                RoleTypeConstant.companyStaff)
                              Text(
                                'Staff',
                                style: Mytheme.lightTheme(context)
                                    .textTheme
                                    .headline1!
                                    .copyWith(fontSize: 10),
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Padding(
                padding: !Responsive.isDesktop(context)
                    ? const EdgeInsets.only(top: 18)
                    : EdgeInsets.only(right: 30, top: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                      child: Stack(
                        children: [
                          Image.asset(
                            'assets/notificationiocn.png',
                            width: 25,
                            height: 25,
                          ),
                          Consumer(builder: (context, ref, child) {
                            int notificationCount =
                                ref.watch(companyProfile).notificationCount;
                            return notificationCount > 0
                                ? Positioned(
                                    top: -5,
                                    right: 0,
                                    child: Container(
                                      padding: EdgeInsets.all(5.0),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '$notificationCount',
                                          style: whiteMedium14,
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox();
                          }),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: !Responsive.isDesktop(context) ? 10 : 40,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (Responsive.isDesktop(context))
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Company Profile',
                                style: Mytheme.lightTheme(context)
                                    .textTheme
                                    .headline1!
                                    .copyWith(fontSize: 12),
                              ),
                              // Text(
                              //   'Admin',
                              //   style: Mytheme.lightTheme(context)
                              //       .textTheme
                              //       .headline1!
                              //       .copyWith(fontSize: 10),
                              // ),
                            ],
                          ),
                        InkWell(
                          onTap: () => widget.profileIconClick!(),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: CircleAvatar(
                              child: Consumer(builder: (context, ref, child) {
                                UserData user = ref.watch(companyProfile).user;
                                return ClipOval(
                                  child: userData != null &&
                                          currentUrl(user.image) != null
                                      ? Image.network(
                                          "${currentUrl(user.image)}",
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
                                );
                              }),
                              backgroundColor: MyAppColor.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            bottom: PreferredSize(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  if (widget.back != null)
                    Container(
                      height: 50,
                      color: MyAppColor.greynormal,
                      child: _back(widget.back),
                    ),
                  if (!Responsive.isDesktop(context))
                    if (widget.tab != null)
                      Container(
                        height: 50,
                        width: double.infinity,
                        color: MyAppColor.grayplane,
                        child: widget.tab,
                      ),
                  if (Responsive.isDesktop(context) && widget.tab != null)
                    Stack(
                      children: [
                        Container(
                          height: 40,
                          color: MyAppColor.greynormal,
                        ),
                        Positioned(
                          left: 40,
                          child: Container(
                            height: 40,
                            width: Sizeconfig.screenWidth! / 3,
                            child: widget.tab,
                          ),
                        ),
                      ],
                    )
                ],
              ),
              preferredSize: Size.fromHeight(20),
            ),
          );
  }

  _back(pageRouteText) {
    return Padding(
      padding: widget.isWeb
          ? EdgeInsets.only(left: 35, right: 0)
          : EdgeInsets.only(left: 05, right: 0),
      child: Container(
        height: Sizeconfig.screenHeight! / 20,
        color: MyAppColor.greynormal,
        child: Row(
          children: [
            SizedBox(
              width: 5,
            ),
            Container(
              height: 30,
              child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: MyAppColor.backgray,
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (kIsWeb) {
                        context.vRouter.to(context.vRouter.previousPath!);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 17,
                      color: MyAppColor.blackdark.withOpacity(0.7),
                    ),
                  )),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Back",
              style: TextStyle(
                color: MyAppColor.blackdark,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Text("$pageRouteText",
                style: GoogleFonts.darkerGrotesque(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
