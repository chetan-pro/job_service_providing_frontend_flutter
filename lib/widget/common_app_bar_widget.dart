// ignore_for_file: must_be_immutable

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/candidate/pages/side_drawerpages/notification.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/label_string.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:vrouter/vrouter.dart';

import '../candidate/pages/job_seeker_page/home/homeappbar.dart';
import '../candidate/pages/landing_page/home_page.dart';
import '../company/home/widget/company_custom_app_bar.dart';
import '../config/responsive.dart';
import '../utility/function_utility.dart';

class CommomAppBar extends StatefulWidget {
  String? back;
  GlobalKey<ScaffoldState> drawerKey;

  CommomAppBar({Key? key, this.back, required this.drawerKey})
      : super(key: key);

  @override
  _CommomAppBarState createState() => _CommomAppBarState();
}

class _CommomAppBarState extends State<CommomAppBar> {
  int selectedTabIndex = 0;
  @override
  void initState() {
    super.initState();
    setIndex();
  }

  setIndex() {
    switch (userData!.userRoleType) {
      case RoleTypeConstant.jobSeeker:
        setState(() {
          selectedTabIndex = 0;
        });
        break;
      case RoleTypeConstant.homeServiceProvider:
        setState(() {
          selectedTabIndex = 1;
        });
        break;
      case RoleTypeConstant.homeServiceSeeker:
        setState(() {
          selectedTabIndex = 2;
        });
        break;
      case RoleTypeConstant.localHunar:
        setState(() {
          selectedTabIndex = 3;
        });
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      UserData? user = ref.watch(userDataProvider).user;
      return checkRoleType(userData!.userRoleType)
          ? CompanyAppBar(
              drawerKey: widget.drawerKey,
              isWeb: Responsive.isDesktop(context),
              back: 'HOME (COMPANY / PREMIUM PLANS',
            )
          : AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: Responsive.isDesktop(context) ? 60 : 120,
              iconTheme: IconThemeData(color: MyAppColor.blackdark),
              backgroundColor: MyAppColor.backgroundColor,
              elevation: 0,
              title: Padding(
                padding: EdgeInsets.only(
                    bottom: Responsive.isDesktop(context) ? 5.0 : 0,
                    top: Responsive.isDesktop(context) ? 0 : 12),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: Responsive.isDesktop(context) ? 20.0 : 0,
                        left: Responsive.isDesktop(context) ? 15.0 : 0,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          widget.drawerKey.currentState!.openDrawer();
                        },
                        child: Image.asset(
                          'assets/drawers.png',
                          height: 18,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        if (userData!.userRoleType ==
                            RoleTypeConstant.company) {
                          context.vRouter.to('/home-company');
                        } else {
                          if (RoleTypeConstant.jobSeeker ==
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
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: Responsive.isDesktop(context) ? 20.0 : 0,
                          bottom: Responsive.isDesktop(context) ? 0.0 : 0,
                        ),
                        child: SizedBox(
                          height: Responsive.isDesktop(context) ? 40 : 40,
                          child: Image.asset('assets/logosmall.png'),
                        ),
                      ),
                    ),
                    if (Responsive.isDesktop(context))
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _menu(context),
                          ],
                        ),
                      )
                  ],
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(
                      top: Responsive.isDesktop(context) ? 18 : 12),
                  child: Row(
                    children: [
                      if (userData!.userRoleType ==
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
                                  SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Showing Results for',
                                      style: black8,
                                    ),
                                    Text(
                                      '${userData!.city!.name}',
                                      style: blackDarkO40M10,
                                    )
                                  ],
                                ),
                                if (Responsive.isDesktop(context))
                                  SizedBox(width: 10),
                                Icon(Icons.arrow_drop_down)
                              ],
                            ),
                          ),
                        ),

                      
                      const SizedBox(
                        width: 50,
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
                              return Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(5.0),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '0',
                                      style: whiteMedium14,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),

                      const SizedBox(
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
                                    )),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
              
              ],
              bottom: PreferredSize(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!Responsive.isDesktop(context)) _menu(context),
                      backButtonRowContainer()
                    ],
                  ),
                ),
                preferredSize:
                    Size.fromHeight(!Responsive.isDesktop(context) ? 40 : 0),
              ),
            );
    });
  }

  backButtonRowContainer() {
    return Container(
      color: MyAppColor.greynormal,
      height: Responsive.isDesktop(context) ? 50 : 40,
      child: Row(
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            children: [
              SizedBox(
                width: Responsive.isDesktop(context) ? 40 : 10,
              ),
              GestureDetector(
                onTap: () {
                  if (kIsWeb) {
                    context.vRouter.to(context.vRouter.previousPath!);
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: SizedBox(
                  height: Responsive.isMobile(context) ? 25 : 20,
                  child: CircleAvatar(
                    radius: Responsive.isDesktop(context) ? 20.0 : 15,
                    backgroundColor: MyAppColor.backgray,
                    child: Icon(
                      Icons.arrow_back,
                      color: MyAppColor.greylight,
                      size: Responsive.isDesktop(context) ? 20 : 20,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: Responsive.isDesktop(context) ? 20 : 10,
              ),
              Text(
                LabelString.back,
                style: grey14,
              ),
              SizedBox(
                width: Responsive.isDesktop(context) ? 40 : 20,
              ),
              Text(widget.back ?? '', style: greyMedium10)
            ],
          )
        ],
      ),
    );
  }

  bool isSelected = false;
  Container _menu(context) {
    return Container(
      width: Responsive.isDesktop(context) ? Sizeconfig.screenWidth! / 2 : null,
      child: Padding(
        padding: Responsive.isDesktop(context)
            ? EdgeInsets.all(0.0)
            : EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Container(
                    height: 3,
                    color: selectedTabIndex == 0
                        ? MyAppColor.orangelight
                        : MyAppColor.greynormal,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Job-seeker \n Account",
                    textAlign: TextAlign.center,
                    style: Responsive.isDesktop(context)
                        ? selectedTabIndex != 0
                            ? blackRGalano12()
                            : orangeLightM12()
                        : selectedTabIndex != 0
                            ? blackDarkSb10()
                            : orangeLightM10(),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Container(
                    height: 3,
                    color: selectedTabIndex == 1
                        ? MyAppColor.orangelight
                        : MyAppColor.greynormal,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Home-Service \n Provider",
                      textAlign: TextAlign.center,
                      style: Responsive.isDesktop(context)
                          ? selectedTabIndex != 1
                              ? blackRGalano12()
                              : orangeLightM12()
                          : selectedTabIndex != 1
                              ? blackDarkSb10()
                              : orangeLightM10())
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Container(
                    height: 4,
                    color: selectedTabIndex == 2
                        ? MyAppColor.orangelight
                        : MyAppColor.greynormal,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Home-Service \n Seeker",
                    textAlign: TextAlign.center,
                    style: Responsive.isDesktop(context)
                        ? selectedTabIndex != 2
                            ? blackRGalano12()
                            : orangeLightM12()
                        : selectedTabIndex != 2
                            ? blackDarkSb10()
                            : orangeLightM10(),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Container(
                    height: 4,
                    color: selectedTabIndex == 3
                        ? MyAppColor.orangelight
                        : MyAppColor.greynormal,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Local Hunar \n Account",
                    textAlign: TextAlign.center,
                    style: Responsive.isDesktop(context)
                        ? selectedTabIndex != 3
                            ? blackRGalano12()
                            : orangeLightM12()
                        : selectedTabIndex != 3
                            ? blackDarkSb10()
                            : orangeLightM10(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
