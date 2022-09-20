// ignore_for_file: must_be_immutable

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hindustan_job/candidate/candidateWidget/icon_widget.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/drawer/mywallet_bank_details.dart';
import 'package:hindustan_job/candidate/pages/side_drawerpages/notification.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/company/home/widget/company_custom_app_bar.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:vrouter/vrouter.dart';

import '../pages/job_seeker_page/home/homeappbar.dart';
import '../pages/landing_page/home_page.dart';
import '../theme_modeule/new_text_style.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  GlobalKey<ScaffoldState> drawerKey;
  TabBar? tab;
  Stack? menutab;
  String? back;
  bool? isDisable;
  Function? profileIconClick;
  BuildContext context;
  CustomAppBar(
      {Key? key,
      required this.drawerKey,
      this.tab,
      this.menutab,
      this.profileIconClick,
      this.back,
      this.isDisable,
      required this.context})
      : preferredSize =
            Size.fromHeight(!Responsive.isDesktop(context) ? 130.0 : 120),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      UserData? user = ref.watch(userDataProvider).user;
      return checkRoleType(userData == null ? '' : userData!.userRoleType)
          ? CompanyAppBar(
              drawerKey: widget.drawerKey,
              isWeb: Responsive.isDesktop(context),
              back: 'HOME (COMPANY / PREMIUM PLANS',
            )
          : AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: !Responsive.isDesktop(context) ? 120 : 55,
              iconTheme: IconThemeData(color: MyAppColor.blackdark),
              backgroundColor: MyAppColor.backgroundColor,
              elevation: 0,
              title: Padding(
                padding: const EdgeInsets.only(top: 0, left: 5),
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
                    InkWell(
                      onTap: () {
                        if (RoleTypeConstant.businessCorrespondence ==
                                userData!.userRoleType ||
                            RoleTypeConstant.clusterManager ==
                                userData!.userRoleType ||
                            RoleTypeConstant.fieldSalesExecutive ==
                                userData!.userRoleType) {
                          context.vRouter.to('/business-partner/home');
                        } else if (RoleTypeConstant.jobSeeker ==
                            userData!.userRoleType) {
                          ConnectedRoutes.toJobSeeker(context);
                        } else if (RoleTypeConstant.homeServiceProvider ==
                            userData!.userRoleType) {
                          ConnectedRoutes.toHomeServiceProvider(context);
                        } else if (RoleTypeConstant.homeServiceSeeker ==
                            userData!.userRoleType) {
                          ConnectedRoutes.toHomeServiceSeeker(context);
                        } else {
                          ConnectedRoutes.toLocalHunar(context);
                        }
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
                    if (Responsive.isDesktop(context) && widget.menutab != null)
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [widget.menutab!],
                      )),
                  ],
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(
                      top: Responsive.isDesktop(context) ? 18 : 12),
                  child: Row(
                    children: [
                      if (userData != null &&
                          userData!.userRoleType ==
                              RoleTypeConstant.homeServiceSeeker)
                        Container(
                          color: MyAppColor.greynormal,
                          height: 40,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 5),
                            child: Row(
                              children: [
                                Align(
                                    alignment: Alignment.topCenter,
                                    child: Image.asset(
                                        'assets/location_icon.png')),
                                if (Responsive.isDesktop(context))
                                  const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Showing Results for',
                                      style: black8,
                                    ),
                                    if (userData != null)
                                      Text(
                                        '${userData!.city!.name}',
                                        style: blackDarkO40M10,
                                      )
                                  ],
                                ),
                                if (Responsive.isDesktop(context))
                                  const SizedBox(width: 10),
                                Icon(Icons.arrow_drop_down,
                                    color:
                                        MyAppColor.blackdark.withOpacity(0.7))
                              ],
                            ),
                          ),
                        ),
                      if (userData != null &&
                          (userData!.userRoleType ==
                                  RoleTypeConstant.jobSeeker ||
                              userData!.userRoleType ==
                                  RoleTypeConstant.homeServiceProvider))
                        IconButton(
                          onPressed: () {
                            if (widget.isDisable ?? false) {
                              return;
                            }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyWallet()));
                          },
                          color: MyAppColor.blackdark.withOpacity(0.7),
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
                                  builder: (context) => const NotificationScreen()));
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
                                  ref.watch(editProfileData).notificationCount;
                              return notificationCount > 0
                                  ? Positioned(
                                      top: -5,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(5.0),
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
                                  : const SizedBox();
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      if (userData != null)
                        InkWell(
                          onTap: () => widget.profileIconClick!(),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Consumer(builder: (context, ref, child) {
                              return CircleAvatar(
                                child: ClipOval(
                                  child: currentUrl(userData!.image) != null
                                      ? Image.network(
                                          "${currentUrl(user != null ? user.image : userData!.image)}",
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
                        ),
                    ],
                  ),
                ),
              ],
              bottom: PreferredSize(
                child: Column(
                  children: [
                    if (!Responsive.isDesktop(context) &&
                        widget.menutab != null)
                      widget.menutab ?? const SizedBox(),
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
                                width: Sizeconfig.screenWidth,
                                color: MyAppColor.grayplane,
                                child: widget.tab,
                              ),
                            ),
                          ],
                        ),
                  ],
                ),
                preferredSize:
                    Size.fromHeight(Responsive.isDesktop(context) ? 0 : 40),
              ),
            );
    });
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
                      if (kIsWeb) {
                        context.vRouter.to(context.vRouter.previousUrl!);
                      } else {
                        Navigator.pop(context);
                      }
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
