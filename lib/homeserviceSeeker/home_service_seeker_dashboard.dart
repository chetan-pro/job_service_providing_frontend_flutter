// ignore_for_file: must_be_immutable, unused_field

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/homeserviceSeeker/home_tab.dart';
import 'package:hindustan_job/homeserviceSeeker/my_service_request.dart';
import 'my_profile_tab.dart';

class HomeServiceSeekerDashboard extends ConsumerStatefulWidget {
  int? index;
  HomeServiceSeekerDashboard({Key? key, this.index}) : super(key: key);
  @override
  ConsumerState<HomeServiceSeekerDashboard> createState() =>
      _HomeServiceSeekerDashboardState();
}

class _HomeServiceSeekerDashboardState
    extends ConsumerState<HomeServiceSeekerDashboard>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  int progress = 0;
  var indexFile = 0;
  TabController? tabController;
  List<int> arrayIndex = [0];

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
    if (widget.index != null) {
      tabController =
          TabController(initialIndex: widget.index!, length: 3, vsync: this);
    } else {
      tabController = TabController(length: 3, vsync: this);
    }
    tabListner();
    ref.read(serviceSeeker).getLatestServices(context);
    ref.read(serviceSeeker).getAllServiceProviders(context);
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
    bool isUserSubscribed = ref.watch(editProfileData).isCandidateSubscribed;
    Sizeconfig().init(context);
    return Consumer(builder: (context, ref, child) {
      return SafeArea(
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor: MyAppColor.backgroundColor,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: Container(
                  color: MyAppColor.greynormal,
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child: _tab()),
            ),
            body: SizedBox(
              height: Sizeconfig.screenHeight!,
              child: TabBarView(
                controller: tabController,
                children: [
                  SeekerHomeTab(
                    isUserSubscribed: isUserSubscribed,
                  ),
                  const MyServiceRequest(),
                  MyProfileTab(),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  _tab() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Responsive.isDesktop(context) ? 10 : 0.0,
          vertical: Responsive.isDesktop(context) ? 0 : 0.0),
      child: TabBar(
        isScrollable: Responsive.isDesktop(context) ? true : false,
        labelColor: Colors.black,
        indicatorWeight: 2,
        controller: tabController,
        onTap: (index) {
          // if (kIsWeb) {
          //   context.vRouter
          //       .to("/hindustaan-jobs/HSS/${returnIndexHSSString(index)}");
          // }
        },
        indicatorColor: MyAppColor.orangelight,
        // padding: EdgeInsets.symmetric(vertical:5),
        labelPadding: EdgeInsets.symmetric(
            vertical: Responsive.isDesktop(context) ? 0 : 5.0),
        tabs: [
          tabTextWithIcon(iconUrl: "assets/home_company.png", text: 'Home'),
          tabTextWithIcon(
              iconUrl: "assets/my_servicerequest_icon.png",
              text: Responsive.isDesktop(context)
                  ? 'My Service Requests '
                  : 'My Service\nRequests'),
          tabTextWithIcon(iconUrl: "assets/cut_staff.png", text: 'My profile')
        ],
      ),
    );
  }

  tabTextWithIcon({iconUrl, text}) {
    return Padding(
      padding: Responsive.isDesktop(context)
          ? const EdgeInsets.all(8)
          : const EdgeInsets.symmetric(vertical: 0),
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
