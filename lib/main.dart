// ignore_for_file: prefer_const_constructors, unused_import, unused_element

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/model/registree_model.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/edit_profile.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/filter_job_page.dart';
import 'package:hindustan_job/clusterManager/edit_cluster_manager.dart';
import 'package:hindustan_job/company/company_edit_profile.dart';
import 'package:hindustan_job/company/home/create_job_post.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/homeserviceSeeker/home_service_view_screen.dart';
import 'package:hindustan_job/homeserviceSeeker/home_tab.dart';
import 'package:hindustan_job/homeserviceSeeker/service_seeker_edit_profile.dart';
import 'package:hindustan_job/localHunarAccount/model/local_hunar_video_model.dart';
import 'package:hindustan_job/serviceprovider/screens/HomeServiceProviderTabs/ServicesRequests/view_service_request_details_screen.dart';
import 'package:hindustan_job/serviceprovider/screens/HomeServiceProviderTabs/add_a_service_screen.dart';
import 'package:hindustan_job/serviceprovider/screens/HomeServiceProviderTabs/complete_your_profile_screen.dart';
import 'package:hindustan_job/serviceprovider/screens/HomeServiceProviderTabs/service_details_screen.dart';
import 'package:hindustan_job/serviceprovider/screens/home_tab.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/constants/mystring_text.dart';
import 'package:hindustan_job/services/auth/auth_services.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/body/tab_bar_body_widget.dart';
import 'package:vrouter/vrouter.dart';
import 'candidate/model/serviceProviderModal/alldata_get_modal.dart';
import 'candidate/pages/job_seeker_page/home/drawer/my_transaction.dart';
import 'candidate/pages/job_seeker_page/home/drawer/mywallet_bank_details.dart';
import 'candidate/pages/job_seeker_page/home/drawer/specific_company.dart';
import 'candidate/pages/job_seeker_page/home/drawer/subscriptions_plan.dart';
import 'candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'candidate/pages/job_seeker_page/home/job_view_page.dart';
import 'candidate/pages/landing_page/home_page.dart';
import 'candidate/pages/login_page/login_page.dart';
import 'candidate/pages/register_page/register_page.dart';
import 'candidate/pages/resume_builder_form.dart';
import 'candidate/pages/resume_view.dart';
import 'candidate/pages/side_drawerpages/aboutus.dart';
import 'candidate/pages/side_drawerpages/customjob_alert.dart';
import 'candidate/theme_modeule/theme.dart';
import 'clusterManager/cluster_manager_dashboard.dart';
import 'clusterManager/registree_details_screen.dart';
import 'company/home/add_staff_member.dart';
import 'company/home/company_posted_job_view.dart';
import 'company/home/homepage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_strategy/url_strategy.dart';
import 'company/home/pages/subscription_details_of_company.dart';
import 'company/home/search/searchcompany.dart';
import 'firebase_options.dart';
import 'homeserviceSeeker/home_service_seeker_dashboard.dart';
import 'homeserviceSeeker/search_home_service_list_screen.dart';
import 'homeserviceSeeker/service_provider_details_screen.dart';
import 'localHunarAccount/add_video_screen.dart';
import 'localHunarAccount/local_hunar_account_dashboard.dart';
import 'localHunarAccount/lunar_home_tab.dart';
import 'localHunarAccount/my_video_details_screen.dart';
import 'localHunarAccount/my_videos_tab.dart';
import 'localHunarAccount/search_videos.dart';
import 'services/services_constant/response_model.dart';
// import 'package:flutter_web_plugins/flutter_web_plugins.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
      name: "hindustaan job new",
      options: DefaultFirebaseOptions.currentPlatform);
}

late AndroidNotificationChannel channel;

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
const debug = true;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await FacebookAuth.i.webInitialize(
      appId: "603730757378494",
      cookie: true,
      xfbml: true,
      version: "v14.0",
    );
  }
  if (!kIsWeb) {
    await FlutterDownloader.initialize(debug: debug);
    ByteData data =
        await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
    await Firebase.initializeApp(
        name: "hindustaan job new",
        options: DefaultFirebaseOptions.currentPlatform);
    SecurityContext.defaultContext
        .setTrustedCertificatesBytes(data.buffer.asUint8List());
  }
  // setUrlStrategy(PathUrlStrategy());
  if (!kIsWeb) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.high,
      playSound: true,
      showBadge: true,
      enableLights: true,
      sound: RawResourceAndroidNotificationSound('notify'),
    );

    print("yaah tk chl gya2");
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  await getUserDataFromShared();

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("My app");
    return VRouter(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.space): ActivateIntent(),
      },
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      mode: VRouterMode.history,
      theme: Mytheme.lightTheme(context),
      // initialUrl: '/',
      routes: [
        VWidget(
          path: '/about_us',
          widget: AboutUs(passkey: 'about_us'),
        ),
        VWidget(
          path: '/privacy_policy',
          widget: AboutUs(passkey: 'privacy_policy'),
        ),
        VWidget(
          path: '/terms_and_condition',
          widget: AboutUs(passkey: 'terms_and_condition'),
        ),
        VWidget(
          path: '/security_and_fraud',
          widget: AboutUs(passkey: 'security_and_fraud'),
        ),
        VWidget(
          path: '/be_safe',
          widget: AboutUs(passkey: 'be_safe'),
        ),
        VWidget(
          path: '/beaware_of_fraudsters',
          widget: AboutUs(passkey: 'beaware_of_fraudsters'),
        ),
        VGuard(
            beforeEnter: (vRedirector) =>
                authenticationLoginCheck(context, vRedirector: vRedirector),
            stackedRoutes: [
              VWidget(
                path: '/',
                widget: SplashScreen(),
              ),
              VWidget(
                path: '/home',
                widget: Home(),
              ),
              VWidget(
                path: '/register',
                widget: Signup(
                  isUserSocialLogin: false,
                ),
              ),
              VWidget(
                path: '/login',
                widget: Login(),
              ),
            ]),
        VGuard(
            beforeEnter: (vRedirector) =>
                authenticationCheck(context, vRedirector: vRedirector),
            stackedRoutes: [
              ConnectedRoutes(),
              VWidget(
                path: '/home-company',
                widget: Builder(builder: (context) => HomePageAdmin()),
              ),
              VWidget(
                path: '/home-company/edit-profile',
                widget: Builder(builder: (context) => CompanyEditProfile()),
              ),
              VWidget(
                path: '/home-company/create-job-post',
                widget: CreateJobPost(),
              ),
              VWidget(
                path: '/home-company/company-posted-job-view/:id',
                widget: Builder(builder: (context) {
                  return CompanyPostedJobView(
                    id: context.vRouter.pathParameters['id']!,
                  );
                }),
              ),
              VWidget(
                path: '/home-company/search-candidates',
                widget: Builder(builder: (context) {
                  return SearchCompany(
                    isUserSubscribed: false,
                    data: context.vRouter.queryParameters,
                    isNotApplied:
                        context.vRouter.queryParameters['isNotApplied'] ==
                                'true'
                            ? true
                            : false,
                  );
                }),
              ),
              VNester(
                path: '/hindustaan-jobs',
                widgetBuilder: (child) => MyMaterialApp(
                    child), // Child is the widget from nestedRoutes
                nestedRoutes: [
                  ConnectedRoutes(),
                  VWidget(
                      path: 'job-view-page/:id/:flag',
                      aliases: const ['job-view-page/:id'],
                      widget: Builder(builder: (context) {
                        return JobViewPage(
                          id: context.vRouter.pathParameters['id'],
                          flag: context.vRouter.pathParameters['flag'],
                          offerletter:
                              context.vRouter.queryParameters['offerLetter'],
                          candidateStatus: context
                              .vRouter.queryParameters['candidateStatus'],
                          companyStatus:
                              context.vRouter.queryParameters['companyStatus'],
                          reason: context.vRouter.queryParameters['reason'],
                        );
                      })),
                  VWidget(
                      path: 'specific-company/:companyId',
                      widget: Builder(builder: (context) {
                        return SpecificCompany(
                          companyId:
                              context.vRouter.pathParameters['companyId'],
                        );
                      })),
                  VWidget(
                      path: 'subscription-plans',
                      widget: Builder(builder: (context) {
                        return SubscriptionPlans(
                          isValidityPlan: context.vRouter
                                      .queryParameters['isValidityPlan'] ==
                                  'true'
                              ? true
                              : false,
                        );
                      })),
                  VWidget(
                      path:
                          '/${returnNameStringOfRoleType(userData != null ? userData!.userRoleType : '')}/edit-profile',
                      widget: Builder(builder: (context) {
                        return EditProfile();
                      })),
                  VWidget(
                      path: 'wallet',
                      widget: Builder(builder: (context) {
                        return MyWallet();
                      })),
                  VWidget(
                      path: 'resume-builder',
                      widget: Builder(builder: (context) {
                        return ResumeBuilder(
                          isFromConnectedRoutes: false,
                        );
                      })),
                  VWidget(
                      path: 'candidate/resume-view',
                      widget: Builder(builder: (context) {
                        return ResumeView();
                      })),
                  VWidget(
                      path: 'my-transactions',
                      widget: Builder(builder: (context) {
                        return MyTransaction();
                      })),
                  VWidget(
                      path: 'add-local-hunar-video',
                      widget: Builder(builder: (context) {
                        return AddVideoScreen();
                      })),
                  VWidget(
                      path: 'filter-job-search',
                      widget: Builder(builder: (context) {
                        return FilterJobPage(
                          flag: context.vRouter.queryParameters['flag'],
                          data: context.vRouter.queryParameters,
                          isFromConnectedRoutes: false,
                        );
                      })),
                  VWidget(
                      path: 'search-video-screen',
                      widget: Builder(builder: (context) {
                        return SearchVideosScreen();
                      })),
                  VWidget(
                      path: 'service-details-screen/:id',
                      widget: Builder(builder: (context) {
                        return ServiceDetailsScreen(
                          allservice: AllServiceFetch(),
                          serviceId: context.vRouter.pathParameters['id'],
                        );
                      })),
                ],
              ),
              VWidget(
                  path:
                      '/home-service-seeker/service-provider-details-screen/:id',
                  widget: Builder(builder: (context) {
                    return ServiceProviderDetailsScreen(
                      id: context.vRouter.pathParameters['id']!,
                    );
                  })),
              VWidget(
                path: '/hindustaan-jobs/subscription-details',
                widget: SubscriptionDetailsCompany(),
              ),
              VWidget(
                path: '/home-company/add-a-staff',
                widget: AddStaffMember(),
              ),
              VWidget(
                path: '/home-company/edit-a-staff',
                widget: AddStaffMember(),
              ),
              VWidget(
                path: '/job-seeker/custom-job-alert',
                widget: CustomJobAlerts(
                  isFromConnectedRoutes: false,
                ),
              ),
              VWidget(
                path: '/home-service-seeker/edit-profile',
                widget: ServiceSeekerEditProfile(),
              ),
              VWidget(
                path: '/local-hunar/edit-profile',
                widget: ServiceSeekerEditProfile(),
              ),
              VWidget(
                  path:
                      '/home-service-seeker/request-service/:id/:flag/:serviceRequestId',
                  widget: Builder(builder: (context) {
                    return HomeServiceViewScreen(
                      serviceId: context.vRouter.pathParameters['id']!,
                      flag: context.vRouter.pathParameters['flag']!,
                      serviceRequestId:
                          context.vRouter.pathParameters['serviceRequestId']!,
                    );
                  })),
              VWidget(
                  path:
                      '/home-service-seeker/view-service-request-details-screen/:flag/:serviceRequestId',
                  widget: Builder(builder: (context) {
                    return ViewServiceRequestDetailsScreen(
                      flag: context.vRouter.pathParameters['flag']!,
                      serviceRequestId: int.parse(
                          context.vRouter.pathParameters['serviceRequestId']!),
                    );
                  })),
              VWidget(
                  path: '/home-service-seeker/search-service/:flag',
                  widget: Builder(builder: (context) {
                    return SearchHomeServicesListScreen(
                        isProvider:
                            context.vRouter.pathParameters['flag'] != 'false',
                        filterData: context.vRouter.queryParameters);
                  })),
              VWidget(
                  path: '/home-service-provider/edit-profile',
                  widget: Builder(builder: (context) {
                    return CompleteYourProfileScreen();
                  })),
              VWidget(
                  path: '/home-service-provider/add-service',
                  widget: Builder(builder: (context) {
                    return AddAServiceScreen();
                  })),
              VWidget(
                  path: '/business-partner/home',
                  widget: Builder(builder: (context) {
                    return ClusterManagerDashboard();
                  })),
              VWidget(
                  path: '/BC/edit-profile',
                  widget: Builder(builder: (context) {
                    return EditClusterManager();
                  })),
              VWidget(
                  path: '/BC/registree-user-profile/:flag/:id',
                  widget: Builder(builder: (context) {
                    return DetailsScreen(
                      flag: context.vRouter.pathParameters['flag'],
                      registree: Registree(),
                      registredUserId: int.parse(
                          context.vRouter.pathParameters['id'] ?? '0'),
                    );
                  })),
            ]),
      ],
    );
  }

  Future<void> authenticationCheck(BuildContext context,
      {required VRedirector vRedirector}) async {
    if (!isUserData()) {
      vRedirector.to('/home');
    } else if (userData!.userRoleType == null) {
      vRedirector.to('/home');
    }
  }

  Future<void> authenticationLoginCheck(BuildContext context,
      {required VRedirector vRedirector}) async {
    if (isUserData()) {
      print("i am done");
      if (userData!.userRoleType == null) {
        vRedirector.to('/home');
      }
      if (userData!.userRoleType == RoleTypeConstant.company ||
          userData!.userRoleType == RoleTypeConstant.companyStaff) {
        vRedirector.to('/home-company');
      } else if (userData!.userRoleType ==
              RoleTypeConstant.businessCorrespondence ||
          userData!.userRoleType == RoleTypeConstant.clusterManager ||
          userData!.userRoleType == RoleTypeConstant.fieldSalesExecutive ||
          userData!.userRoleType == RoleTypeConstant.advisor) {
        vRedirector.to('/business-partner/home');
      } else {
        String path = RoleTypeConstant.jobSeeker == userData!.userRoleType
            ? ConnectedRoutes.jobSeeker
            : RoleTypeConstant.homeServiceProvider == userData!.userRoleType
                ? ConnectedRoutes.homeServiceProvider
                : RoleTypeConstant.homeServiceSeeker == userData!.userRoleType
                    ? ConnectedRoutes.homeServiceSeeker
                    : ConnectedRoutes.localHunar;
        vRedirector.to('/$path');
      }
    } else {
      print("errror");
    }
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String route = '/splash-screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  @override
  void initState() {
    print("heelo splash");
    super.initState();
    navigateFunction();
  }

  navigateFunction() async {
    Timer(
      Duration(seconds: 2),
      () => checkFromFirebasePushNotification(),
    );
  }

  checkFromFirebasePushNotification() async {
    print("yaha tk work done");
    if (isUserData()) {
      ApiResponse response = await getProfile(userData!.resetToken);
      if (response.body!.data != null) {
        UserData user = UserData.fromJson(response.body!.data);
        await setUserData(user);
      }
    } else {
      if (kIsWeb) {
        context.vRouter.to("/home");
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
      }
    }

    if (!kIsWeb) {
      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage? message) {
        if (!isUserData()) {
          context.vRouter.to("/home");
          return;
        }
        if (isUserData()) {
          if (kIsWeb) {
            if (checkRoleType(userData!.userRoleType)) {
              context.vRouter.to('/home-company');
            } else {
              if (RoleTypeConstant.jobSeeker == userData!.userRoleType) {
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
          } else {
            context.vRouter.to("/home");
          }
        } else {
          if (RoleTypeConstant.jobSeeker == userData!.userRoleType) {
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
          return;
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => isUserData()
          //             ? userData!.userRoleType ==
          //                     RoleTypeConstant.businessCorrespondence
          //                 ? ClusterManagerDashboard()
          //                 : checkRoleType(userData!.userRoleType)
          //                     ? HomePageAdmin()
          //                     : HomeAppBar(JobSeekerTab(), 0)
          //             : Home()));
        }
      });
    }
    if (!kIsWeb) {
      try {
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          RemoteNotification? notification = message.notification;
          AndroidNotification? android = message.notification?.android;
          if (notification != null && android != null && !kIsWeb) {
            flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  icon: 'launch_background',
                ),
              ),
            );
          }
        });
      } catch (error) {}
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      try {
        var data = json.decode(message.data.entries.first.value);
        if (data['userAppliedData'] != null ||
            data['userAppliedDetails'] != null) {
          var appliedData =
              data['userAppliedData'] ?? data['userAppliedDetails'];
          if (userData!.userRoleType == RoleTypeConstant.jobSeeker) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JobViewPage(
                  id: appliedData['job_post_id'],
                  candidateStatus: appliedData['candidate_status'],
                  companyStatus: appliedData['company_status'],
                  offerletter: appliedData['offer_letter'],
                  reason: appliedData['reason'],
                ),
              ),
            );
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CompanyPostedJobView(
                          id: appliedData['job_post_id'].toString(),
                        )));
          }
        }
      } catch (e) {
        print(":::::::e::::::::::");
        print(e);
      }
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        child: Image(
          image: AssetImage("assets/splash.png"),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}

class MyMaterialApp extends StatefulWidget {
  final Widget child;
  MyMaterialApp(this.child);

  @override
  State<MyMaterialApp> createState() => _MyMaterialAppState();
}

class _MyMaterialAppState extends State<MyMaterialApp> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
