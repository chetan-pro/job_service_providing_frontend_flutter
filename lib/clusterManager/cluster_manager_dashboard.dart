// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/foundation.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/header/app_bar.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/clusterManager/cluster_manager_profile.dart';
import 'package:hindustan_job/clusterManager/my_business_correspondence.dart';
import 'package:hindustan_job/clusterManager/my_commission_screen.dart';
import 'package:hindustan_job/clusterManager/my_registrees_screen.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/auth/auth_services.dart';
import 'package:vrouter/vrouter.dart';
import '../candidate/pages/job_seeker_page/home/drawer/drawer_jobseeker.dart';
import '../candidate/pages/landing_page/home_page.dart';
import '../provider/business_correspondance_provider.dart';
import '../services/services_constant/response_model.dart';
import 'edit_cluster_manager.dart';
import 'home_tab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;

class ClusterManagerDashboard extends ConsumerStatefulWidget {
  static const String route = '/cluster-manager-dashboard';

  @override
  ConsumerState<ClusterManagerDashboard> createState() =>
      _ClusterManagerDashboardState();
}

final businessCorrespondance =
    riverpod.ChangeNotifierProvider<BusinessCorrespondance>((ref) {
  return BusinessCorrespondance();
});

class _ClusterManagerDashboardState
    extends ConsumerState<ClusterManagerDashboard>
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
    tabController = TabController(
        length: RoleTypeConstant.advisor == userData!.userRoleType
            ? 4
            : RoleTypeConstant.fieldSalesExecutive == userData!.userRoleType
                ? 3
                : 5,
        vsync: this,
        initialIndex: 0);
    tabListner();
    getDashBoardDetails();
  }

  tabListner() {
    tabController?.addListener(() {
      if (arrayIndex.isEmpty) {
        arrayIndex.add(tabController?.index ?? 0);
      } else if (arrayIndex.last != tabController?.index) {
        arrayIndex.add(tabController?.index ?? 0);
      }
      if (tabController?.index == 0) {
        getDashBoardDetails();
      }
    });
  }

  getDashBoardDetails() {
    getUserData();
    ref.read(businessCorrespondance).getDashBoardCountData();
    ref.read(businessCorrespondance).getCommisionData();
    ref.read(businessCorrespondance).getRegistreeData();
  }

  getUserData() async {
    ApiResponse response = await getProfile(userData!.resetToken);
    if (response.status == 200) {
      UserData user = UserData.fromJson(response.body!.data);
      await setUserData(user);
      ref.read(userDataProvider).updateUserData(user);
    }
  }

  int registerIndex = 0;
  String status = '';

  onChangeTab(value, {registerRole, registerStatus}) {
    if (registerRole != null) {
      registerIndex = registerRole == 'JS'
          ? 0
          : registerRole == 'COMPANY'
              ? 1
              : registerRole == 'HSP'
                  ? 2
                  : registerRole == 'HSS'
                      ? 3
                      : 4;
      status = registerStatus;
    }
    setState(() {});

    Future.delayed(Duration(seconds: 1), () => tabController!.animateTo(value));
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
      child: DefaultTabController(
        length: RoleTypeConstant.advisor == userData!.userRoleType
            ? 4
            : RoleTypeConstant.fieldSalesExecutive == userData!.userRoleType
                ? 3
                : 5,
        child: Scaffold(
          key: _drawerKey,
          drawer: const Drawer(
            child: const DrawerJobSeeker(),
          ),
          backgroundColor: MyAppColor.backgroundColor,
          appBar: CustomAppBar(
              drawerKey: _drawerKey,
              context: context,
              tab: _tab(),
              profileIconClick: () async {
                if (!kIsWeb) {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditClusterManager()));
                } else {
                  context.vRouter.to("/BC/edit-profile");
                }
              }),
          body: SizedBox(
            height: Sizeconfig.screenHeight!,
            child: TabBarView(
              controller: tabController,
              children: RoleTypeConstant.advisor == userData!.userRoleType
                  ? [
                      HomeTabClusterManager(onChangeTab: onChangeTab),
                      MyRegistreesScreen(
                        tabIndex: registerIndex,
                        status: status,
                      ),
                      MyCommisssionScreen(),
                      const ProfileClusterManager()
                    ]
                  : RoleTypeConstant.fieldSalesExecutive ==
                          userData!.userRoleType
                      ? [
                          HomeTabClusterManager(onChangeTab: onChangeTab),
                          MyRegistreesScreen(
                              tabIndex: registerIndex, status: status),
                          const ProfileClusterManager()
                        ]
                      : [
                          HomeTabClusterManager(onChangeTab: onChangeTab),
                          MyRegistreesScreen(
                              tabIndex: registerIndex, status: status),
                          const MyBusinessCorespondenceScreen(),
                          MyCommisssionScreen(),
                          const ProfileClusterManager()
                        ],
            ),
          ),
        ),
      ),
    );
  }

  _tab() {
    return TabBar(
      isScrollable: true,
      labelColor: Colors.black,
      indicatorWeight: 2,
      indicatorColor: MyAppColor.orangelight,
      controller: tabController,
      tabs: RoleTypeConstant.advisor == userData!.userRoleType
          ? [
              tabTextWithIcon(iconUrl: "assets/home_company.png", text: 'Home'),
              tabTextWithIcon(
                  iconUrl: "assets/commissions.png",
                  text: Responsive.isDesktop(context)
                      ? 'My Registrees'
                      : 'My Registrees'),
              tabTextWithIcon(
                  iconUrl: "assets/commissions.png", text: 'My Commissions'),
              tabTextWithIcon(
                  iconUrl: "assets/profile2.png",
                  text: Responsive.isDesktop(context)
                      ? 'My Profile'
                      : 'My Profile'),
            ]
          : RoleTypeConstant.fieldSalesExecutive == userData!.userRoleType
              ? [
                  tabTextWithIcon(
                      iconUrl: "assets/home_company.png", text: 'Home'),
                  tabTextWithIcon(
                      iconUrl: "assets/commissions.png",
                      text: Responsive.isDesktop(context)
                          ? 'My Registrees'
                          : 'My Registrees'),
                  tabTextWithIcon(
                      iconUrl: "assets/profile2.png",
                      text: Responsive.isDesktop(context)
                          ? 'My Profile'
                          : 'My Profile'),
                ]
              : [
                  tabTextWithIcon(
                      iconUrl: "assets/home_company.png", text: 'Home'),
                  tabTextWithIcon(
                      iconUrl: "assets/commissions.png",
                      text: Responsive.isDesktop(context)
                          ? 'My Registrees'
                          : 'My Registrees'),
                  tabTextWithIcon(
                      iconUrl: "assets/correspondence.png",
                      text: 'My Sub Business Correspondence'),
                  tabTextWithIcon(
                      iconUrl: "assets/commissions.png",
                      text: 'My Commissions'),
                  tabTextWithIcon(
                      iconUrl: "assets/profile2.png",
                      text: Responsive.isDesktop(context)
                          ? 'My Profile'
                          : 'My Profile'),
                ],
    );
  }

  tabTextWithIcon({iconUrl, text}) {
    return Padding(
      padding: Responsive.isDesktop(context)
          ? const EdgeInsets.all(8)
          : const EdgeInsets.symmetric(vertical: 8),
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
