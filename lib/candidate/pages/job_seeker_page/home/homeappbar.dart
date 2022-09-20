// import 'dart:isolate';
// ignore_for_file: unused_local_variable, unnecessary_const

import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/header/app_bar.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/edit_profile.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_widget/job_seeker.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/homeserviceSeeker/home_service_seeker_dashboard.dart';
import 'package:hindustan_job/homeserviceSeeker/service_seeker_edit_profile.dart';
import 'package:hindustan_job/localHunarAccount/local_hunar_account_dashboard.dart';
import 'package:hindustan_job/provider/candidate_edit_profile.dart';
import 'package:hindustan_job/provider/data_provider.dart';
import 'package:hindustan_job/provider/job_provider.dart';
import 'package:hindustan_job/provider/notification_provider.dart';
import 'package:hindustan_job/provider/service_seeker_provider.dart';
import 'package:hindustan_job/serviceprovider/screens/home_tab.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/auth/auth_services.dart';
import 'package:hindustan_job/services/chat_services/socket_services.dart';
import 'package:hindustan_job/widget/landing_page_widget/chat_contacts_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:vrouter/vrouter.dart';
import '../../../../provider/local_hunar_provider.dart';
import '../../../../provider/serviceProvider/service_provider.dart';
import '../../../../provider/user_update_provider.dart';
import '../../../../serviceprovider/screens/HomeServiceProviderTabs/complete_your_profile_screen.dart';
import '../../../../utility/function_utility.dart';
import '../../landing_page/home_page.dart';
import 'drawer/drawer_jobseeker.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';

final serviceProviderData =
    riverpod.ChangeNotifierProvider<ServiceProviderChangeNotifier>(
  (ref) {
    return ServiceProviderChangeNotifier();
  },
);
final listData = riverpod.ChangeNotifierProvider<ListDataChangeNotifier>((ref) {
  return ListDataChangeNotifier();
});

final localHunarProvider =
    riverpod.ChangeNotifierProvider<LocalHunarChangeNotifier>((ref) {
  return LocalHunarChangeNotifier();
});
final notificationProvider =
    riverpod.ChangeNotifierProvider<NotificationChangeNotifier>((ref) {
  return NotificationChangeNotifier();
});
final serviceSeeker =
    riverpod.ChangeNotifierProvider<ServiceSeekerChangeNotifier>((ref) {
  return ServiceSeekerChangeNotifier();
});
final chatingMessage =
    riverpod.ChangeNotifierProvider<ChatingMessageChangeNotifier>((ref) {
  return ChatingMessageChangeNotifier();
});

final jobData = riverpod.ChangeNotifierProvider<JobDataChangeNotifier>((ref) {
  return JobDataChangeNotifier();
});

final editProfileData =
    riverpod.ChangeNotifierProvider<CandidateEditProfileChangeNotifier>((ref) {
  return CandidateEditProfileChangeNotifier(false);
});

class HomeAppBar extends ConsumerStatefulWidget {
  Widget? child;
  int? index;
  HomeAppBar(this.child, this.index);
  static const String route = '/home-candidate';

  @override
  ConsumerState<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends ConsumerState<HomeAppBar>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  int progress = 0;
  var indexFile = 0;
  TabController? _control;
  TabController? _menuController;

  @override
  void initState() {
    super.initState();
    takePermission();
    _menuController = TabController(vsync: this, length: 4);
    _menuController!.addListener(() {});
    tabSwitcher(userData!.userRoleType);
    if (userData!.userRoleType == "JS" && widget.index != null) {
      _control = TabController(
          vsync: this, initialIndex: int.parse("${widget.index}"), length: 3);
    } else {
      _control = TabController(vsync: this, length: 3);
    }
    ref.read(chatingMessage).getMesssageCount(context);
    ref.read(chatingMessage).connectSocket();
    ref.read(chatingMessage).newMessageListner(context);
    if (userData != null) {
      ref.read(listData).fetchData(context);
      ref.read(chatingMessage).getAllContacts(context);
      ref.read(editProfileData).checkSubscription();
      ref.read(editProfileData).getNotificationCount();
    }
    addFcmToken();
  }

  tabSwitcher(type) {
    switch (type) {
      case RoleTypeConstant.jobSeeker:
        _menuController =
            TabController(initialIndex: 0, vsync: this, length: 4);
        break;
      case RoleTypeConstant.homeServiceProvider:
        _menuController =
            TabController(initialIndex: 1, vsync: this, length: 4);
        break;
      case RoleTypeConstant.homeServiceSeeker:
        _menuController =
            TabController(initialIndex: 2, vsync: this, length: 4);
        break;
      case RoleTypeConstant.localHunar:
        _menuController =
            TabController(initialIndex: 3, vsync: this, length: 4);
        break;
      default:
    }
  }

  addFcmToken() async {
    await FirebaseMessaging.instance.getToken().then((value) async {
      String? token = value;
      var fcmData = {"fcm_token": token};
      await fcmTokenAdded(fcmData);
    });
  }

  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme;
    Sizeconfig().init(context);
    return GestureDetector(
      child: SafeArea(
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            floatingActionButton: userData?.userRoleType ==
                    RoleTypeConstant.jobSeeker
                ? Stack(
                    children: [
                      FloatingActionButton(
                        backgroundColor: MyAppColor.floatButtonColor,
                        onPressed: () async {
                          if (Responsive.isDesktop(context)) {
                            await webChatContactBox(context, chatingMessage);
                          } else {
                            await chatContactBox(context, chatingMessage);
                          }
                          ref.read(chatingMessage).getMesssageCount(context);
                        },
                        child: const ImageIcon(
                            const AssetImage("assets/messageicon.png")),
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
                                  decoration: const BoxDecoration(
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
                            : const SizedBox();
                      }),
                    ],
                  )
                : const SizedBox(),
            key: _drawerKey,
            drawer: const Drawer(
              child: DrawerJobSeeker(),
            ),
            backgroundColor: MyAppColor.backgroundColor,
            appBar: CustomAppBar(
              context: context,
              menutab: _menutab(),
              drawerKey: _drawerKey,
              profileIconClick: () async {
                if (kIsWeb) {
                  if (RoleTypeConstant.jobSeeker == userData!.userRoleType) {
                    context.vRouter.to('/job-seeker/edit-profile');
                  } else if (RoleTypeConstant.homeServiceProvider ==
                      userData!.userRoleType) {
                    context.vRouter.to('/home-service-provider/edit-profile');
                  } else if (RoleTypeConstant.homeServiceSeeker ==
                      userData!.userRoleType) {
                    context.vRouter.to('/home-service-seeker/edit-profile');
                  } else {
                    context.vRouter.to('/local-hunar/edit-profile');
                  }
                } else {
                  if (RoleTypeConstant.jobSeeker == userData!.userRoleType) {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditProfile(isAppBarShow: true)));
                  } else if (RoleTypeConstant.homeServiceProvider ==
                      userData!.userRoleType) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CompleteYourProfileScreen(isShowAppBar: true)));
                  } else if (RoleTypeConstant.homeServiceSeeker ==
                      userData!.userRoleType) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ServiceSeekerEditProfile(
                                  isShowAppBar: true,
                                )));
                  } else {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ServiceSeekerEditProfile(
                                  isShowAppBar: true,
                                )));
                  }
                }
              },
            ),
            body: widget.child,
          ),
        ),
      ),
    );
  }

  _menutab() {
    return Stack(
      fit: StackFit.passthrough,
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          width: Responsive.isDesktop(context) ? 440 : null,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: MyAppColor.greynormal, width: 3.0),
            ),
          ),
        ),
        TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          padding: EdgeInsets.zero,
          isScrollable: true,
          indicatorWeight: 2,
          indicator: BoxDecoration(
            border: Border(
              top: BorderSide(color: MyAppColor.orangelight, width: 3.0),
            ),
          ),
          controller: _menuController,
          unselectedLabelColor: MyAppColor.blackdark,
          unselectedLabelStyle: Responsive.isDesktop(context)
              ? orangeLightM12()
              : blackDarkSb10(),
          labelColor: MyAppColor.orangelight,
          onTap: (i) async {
            String roleType = i == 0
                ? RoleTypeConstant.jobSeeker
                : i == 1
                    ? RoleTypeConstant.homeServiceProvider
                    : i == 2
                        ? RoleTypeConstant.homeServiceSeeker
                        : RoleTypeConstant.localHunar;
            await changeRoleType(roleType);
            ApiResponse response = await getProfile(userData!.resetToken);
            if (response.status == 200) {
              UserData user = UserData.fromJson(response.body!.data);
              await setUserData(user);
              ref.read(userDataProvider).updateUserData(user);
            }
            if (i == 0) {
              ConnectedRoutes.toJobSeeker(context);
            } else if (i == 1) {
              ConnectedRoutes.toHomeServiceProvider(context);
            } else if (i == 2) {
              ConnectedRoutes.toHomeServiceSeeker(context);
            } else {
              ConnectedRoutes.toLocalHunar(context);
            }
          },
          labelStyle: Responsive.isDesktop(context)
              ? orangeLightM12()
              : blackDarkSb10(),
          tabs: [
            Tab(
              text: "Job-seeker \n Account",
            ),
            Tab(text: "Home-Service \n Provider"),
            Tab(text: "Home-Service \n Seeker"),
            Tab(text: "Local Hunar \n Account"),
          ],
        ),
      ],
    );
  }

  menuTabs({text}) {
    return Column(
      children: [
        Container(
          height: 4,
          color: MyAppColor.blackdark,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          "$text",
          textAlign: TextAlign.center,
          style: orangeLightM10(),
        )
      ],
    );
  }

  void stringValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? api_token = prefs.getString('USER_Token');
  }
}

class ConnectedRoutes extends VRouteElementBuilder {
  static final String jobSeeker = 'job-seeker';

  static void toJobSeeker(BuildContext context) =>
      context.vRouter.to('/$jobSeeker');

  static final String homeServiceProvider = 'home-service-provider';

  static void toHomeServiceProvider(BuildContext context) =>
      context.vRouter.to('/$homeServiceProvider');

  static final String homeServiceSeeker = 'home-service-seeker';

  static void toHomeServiceSeeker(BuildContext context) =>
      context.vRouter.to('/$homeServiceSeeker');
  static final String localHunar = 'local-hunar';

  static void toLocalHunar(BuildContext context) =>
      context.vRouter.to('/$localHunar');

  @override
  List<VRouteElement> buildRoutes() {
    return [
      VNester.builder(
        path: '/',
        widgetBuilder: (_, state, child) => HomeAppBar(
          child,
          state.names.contains(jobSeeker)
              ? 0
              : state.names.contains(homeServiceProvider)
                  ? 1
                  : state.names.contains(homeServiceSeeker)
                      ? 2
                      : 3,
        ),
        nestedRoutes: [
          VWidget(
            path: jobSeeker,
            name: jobSeeker,
            widget: JobSeekerTab(),
          ),
          VWidget(
            path: homeServiceProvider,
            name: homeServiceProvider,
            widget: HomeServiceProviderTab(),
          ),
          VWidget(
            path: homeServiceSeeker,
            name: homeServiceSeeker,
            widget: HomeServiceSeekerDashboard(),
          ),
          VWidget(
            path: localHunar,
            name: localHunar,
            widget: LocalHunarAccountDashboard(),
          ),
        ],
      ),
    ];
  }
}
