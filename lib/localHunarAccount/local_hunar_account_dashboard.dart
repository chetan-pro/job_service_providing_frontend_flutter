// ignore_for_file: must_be_immutable

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/localHunarAccount/my_profile_lunar.dart';
import 'package:hindustan_job/localHunarAccount/my_videos_tab.dart';

import 'lunar_home_tab.dart';

class LocalHunarAccountDashboard extends ConsumerStatefulWidget {
  int? index;
  LocalHunarAccountDashboard({this.index});
  @override
  ConsumerState<LocalHunarAccountDashboard> createState() =>
      _LocalHunarAccountDashboardState();
}

class _LocalHunarAccountDashboardState
    extends ConsumerState<LocalHunarAccountDashboard>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  TabController? tabController;

  int progress = 0;
  var indexFile = 0;
  List<int> arrayIndex = [0];

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
    if (widget.index != null) {
      tabController =
          TabController(initialIndex: widget.index!, vsync: this, length: 3);
    } else {
      tabController = TabController(vsync: this, length: 3);
    }
    tabListner();
  }

  tabListner() {
    tabController?.addListener(() {
      if (arrayIndex.isEmpty) {
        arrayIndex.add(tabController?.index ?? 0);
      } else if (arrayIndex.last != tabController?.index) {
        arrayIndex.add(tabController?.index ?? 0);
      }
      if (tabController?.index == 0) {}
    });
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (tabController?.index != 0) {
      arrayIndex.removeLast();
      int index = arrayIndex.last;
      arrayIndex.removeLast();
      tabController?.animateTo(index);
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor: MyAppColor.backgroundColor,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: Container(color: MyAppColor.greynormal, child: _tab()),
            ),
            body: SizedBox(
              height: Sizeconfig.screenHeight!,
              child: TabBarView(
                controller: tabController,
                children: [
                  LunarHomeTab(),
                  LunarMyVideosTab(),
                  MyProfileLunarTab(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _tab() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Responsive.isDesktop(context) ? 10 : 0.0),
      child: TabBar(
        isScrollable: true,
        labelColor: Colors.black,
        indicatorWeight: 2,
        onTap: (index) {
          // if (kIsWeb) {

          //   context.vRouter
          //       .to("/hindustaan-jobs/LH/${returnIndexLHString(index)}");
          // }
        },
        indicatorColor: MyAppColor.orangelight,
        controller: tabController,
        tabs: [
          tabTextWithIcon(iconUrl: "assets/home_company.png", text: 'Home'),
          tabTextWithIcon(
              iconUrl: "assets/small_video_icon.png",
              text: Responsive.isDesktop(context) ? 'My Videos' : 'My Videos'),
          tabTextWithIcon(iconUrl: "assets/cut_staff.png", text: 'My profile')
        ],
      ),
    );
  }

  tabTextWithIcon({iconUrl, text}) {
    return Padding(
      padding: Responsive.isDesktop(context)
          ? EdgeInsets.all(8)
          : EdgeInsets.symmetric(vertical: 8),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: Responsive.isMobile(context) ? 25 : 25,
              child: CircleAvatar(
                  backgroundColor: MyAppColor.blackdark,
                  child: ImageIcon(AssetImage(iconUrl),
                      size: Responsive.isDesktop(context) ? 12 : 12,
                      color: Colors.white)),
            ),
            SizedBox(
              width: Responsive.isDesktop(context) ? 10 : 0,
            ),
            Text("$text",
                textAlign: TextAlign.center,
                style: Responsive.isDesktop(context)
                    ? blackDark12
                    : blackDarkSb10()),
          ]),
    );
  }
}
