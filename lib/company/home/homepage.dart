// ignore_for_file: prefer_const_constructors, unused_local_variable, unused_import

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_widget/job_posts.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_widget/personal_details.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/company/home/widget/company_custom_app_bar.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/provider/company_provider.dart';
import 'package:hindustan_job/provider/data_provider.dart';
import 'package:hindustan_job/provider/job_provider.dart';
import 'package:hindustan_job/provider/notification_provider.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/auth/auth_services.dart';
import 'package:hindustan_job/services/chat_services/socket_services.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/widget/landing_page_widget/chat_contacts_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hindustan_job/candidate/dropdown/dropdown_list.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_string.dart';
import 'package:hindustan_job/candidate/icons/icon.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/drawer/drawer_jobseeker.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/company/home/pages/company_home_pages.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:vrouter/vrouter.dart';

import '../company_profile.dart';
import '../our_staff.dart';
import 'create_job_post.dart';

final listData = riverpod.ChangeNotifierProvider<ListDataChangeNotifier>((ref) {
  return ListDataChangeNotifier();
});
final notificationProvider =
    riverpod.ChangeNotifierProvider<NotificationChangeNotifier>((ref) {
  return NotificationChangeNotifier();
});
final chatingMessage =
    riverpod.ChangeNotifierProvider<ChatingMessageChangeNotifier>((ref) {
  return ChatingMessageChangeNotifier();
});

final jobData = riverpod.ChangeNotifierProvider<JobDataChangeNotifier>((ref) {
  return JobDataChangeNotifier();
});

final companyProfile =
    riverpod.ChangeNotifierProvider<CompanyProfileChangeNotifier>((ref) {
  return CompanyProfileChangeNotifier(isUserSubscribed: false);
});

class HomePageAdmin extends ConsumerStatefulWidget {
  HomePageAdmin({Key? key}) : super(key: key);
  static const String route = '/home-company';

  @override
  ConsumerState<HomePageAdmin> createState() => _HomePageAdminState();
}

class _HomePageAdminState extends ConsumerState<HomePageAdmin>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  TabController? _control;
  List<int> arrayIndex = [0];

  @override
  void initState() {
    _control = TabController(
        vsync: this,
        length:
            userData!.userRoleType == RoleTypeConstant.companyStaff ? 2 : 4);
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
    tabListner();

    takePermission();
    ref.read(listData).fetchData(context);
    if (userData!.userRoleType != RoleTypeConstant.companyStaff) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(companyProfile).updateUserData(userData);
        ref.read(companyProfile).checkSubscription();
        ref.read(companyProfile).getNotificationCount();
      });
    }
    ref.read(chatingMessage).getMesssageCount(context);
    ref.read(chatingMessage).connectSocket();
    ref.read(chatingMessage).newMessageListner(context);
    ref.read(chatingMessage).getAllContacts(context);
    if (!kIsWeb) {
      addFcmToken();
    }
  }

  changeController() {
    _control!.animateTo(1);
    setState(() {});
  }

  addFcmToken() async {
    await FirebaseMessaging.instance.getToken().then((value) async {
      String? token = value;
      var fcmData = {"fcm_token": token};
      await fcmTokenAdded(fcmData);
    });
  }

  tabListner() {
    _control?.addListener(() {
      if (arrayIndex.isEmpty) {
        arrayIndex.add(_control?.index ?? 0);
      } else if (arrayIndex.last != _control?.index) {
        arrayIndex.add(_control?.index ?? 0);
      }
      if (_control?.index == 0) {}
    });
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (_control?.index != 0) {
      arrayIndex.removeLast();
      int index = arrayIndex.last;
      arrayIndex.removeLast();
      _control?.animateTo(index);
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    final styles1 = Mytheme.lightTheme(context).textTheme;
    return Consumer(builder: (context, watch, child) {
      bool isUserSubscribed = ref.watch(companyProfile).isUserSubscribed;
      bool isLoading = ref.watch(companyProfile).isLoading;

      return WillPopScope(
        onWillPop: () async => true,
        child: AnnotatedRegion(
          value: SystemUiOverlayStyle(
            statusBarColor: MyAppColor.backgroundColor,
          ),
          child: DefaultTabController(
            length:
                userData!.userRoleType == RoleTypeConstant.companyStaff ? 2 : 4,
            child: SafeArea(
              child: Scaffold(
                floatingActionButton: Stack(
                  children: [
                    FloatingActionButton(
                      backgroundColor: MyAppColor.floatButtonColor,
                      onPressed: () async {
                        if (Responsive.isDesktop(context)) {
                          webChatContactBox(context, chatingMessage);
                        } else {
                          await chatContactBox(context, chatingMessage);
                        }
                        ref.read(chatingMessage).getMesssageCount(context);
                      },
                      child: ImageIcon(AssetImage("assets/messageicon.png")),
                    ),
                    Consumer(builder: (context, ref, child) {
                      int unseenMessages =
                          ref.watch(chatingMessage).unseenMessagesCount;
                      return unseenMessages > 0
                          ? Positioned(
                              top: 0,
                              right: 5,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: Center(
                                  child: Text(
                                    '$unseenMessages',
                                    style: whiteMedium14,
                                  ),
                                ),
                              ),
                            )
                          : SizedBox();
                    }),
                  ],
                ),
                key: _drawerKey,
                drawer: Drawer(
                  child: DrawerJobSeeker(),
                ),
                backgroundColor: MyAppColor.backgroundColor,
                appBar: CompanyAppBar(
                  drawerKey: _drawerKey,
                  tab: _tab(),
                  profileIconClick: () => _control!.animateTo(
                      userData!.userRoleType == RoleTypeConstant.companyStaff
                          ? 1
                          : 3),
                  isWeb: Responsive.isDesktop(context),
                ),
                body: TabBarView(
                  physics: BouncingScrollPhysics(),
                  controller: _control,
                  children: userData!.userRoleType ==
                          RoleTypeConstant.companyStaff
                      ? [
                          JobPosts(isUserSubscribed: isUserSubscribed),
                          PersonalDetails(),
                        ]
                      : [
                          CompanyHomePage(onControllerChange: changeController),
                          JobPosts(isUserSubscribed: isUserSubscribed),
                          OurStaff(),
                          CompanyProfile(),
                        ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  _tab() {
    return TabBar(
      isScrollable: true,
      labelColor: Colors.black,
      controller: _control,
      onTap: (index) {
        // if (kIsWeb) {
        //   context.vRouter
        //       .to("/home-company/${returnIndexCOMPANYString(index)}");
        // }
      },
      indicatorColor: MyAppColor.orangelight,
      tabs: userData!.userRoleType == RoleTypeConstant.companyStaff
          ? [
              tabTextWithIcon(
                iconUrl: "assets/home_company.png",
                text: "Job Posts",
              ),
              tabTextWithIcon(
                iconUrl: 'assets/proofile_company.png',
                text: "Profile",
              ),
            ]
          : [
              tabTextWithIcon(iconUrl: "assets/home_company.png", text: "Home"),
              tabTextWithIcon(
                iconUrl: "assets/home_company.png",
                text: "Job Posts",
              ),
              tabTextWithIcon(
                iconUrl: 'assets/cut_staff.png',
                text: "Our Staff",
              ),
              tabTextWithIcon(
                iconUrl: 'assets/proofile_company.png',
                text: "Profile",
              ),
            ],
    );
  }

  tabTextWithIcon({iconUrl, text}) {
    return Row(children: [
      SizedBox(
        height: Responsive.isMobile(context) ? 25 : 20,
        width: Responsive.isMobile(context) ? 25 : 20,
        child: CircleAvatar(
            backgroundColor: MyAppColor.blackdark,
            child:
                ImageIcon(AssetImage(iconUrl), size: 12, color: Colors.white)),
      ),
      SizedBox(
        width: Responsive.isDesktop(context) ? 5 : 3,
      ),
      Text("$text", style: blackDark12),
    ]);
  }

  void stringValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apiToken = prefs.getString('USER_Token');
  }
}
