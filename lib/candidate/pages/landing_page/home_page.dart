// ignore_for_file: unused_import

import 'dart:convert';
// import 'dart:html';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_list.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_string.dart';
import 'package:hindustan_job/candidate/icons/icon.dart';
import 'package:hindustan_job/candidate/image/image.dart';
import 'package:hindustan_job/candidate/model/job_model_two.dart';
import 'package:hindustan_job/candidate/model/services_model.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/candidate/pages/drawer_landing_page/landing_drawer.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/drawer/specific_company.dart';
import 'package:hindustan_job/candidate/pages/landing_page/company_list_page.dart';
import 'package:hindustan_job/candidate/pages/landing_page/search_job_here.dart';
import 'package:hindustan_job/candidate/pages/login_page/login_page.dart';
import 'package:hindustan_job/candidate/pages/register_page/register_page.dart';
import 'package:hindustan_job/candidate/theme_modeule/specing.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';

import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/mystring_text.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/provider/user_update_provider.dart';
import 'package:hindustan_job/services/api_services/home_page_services.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/landing_page_widget/about_card_home.dart';
import 'package:hindustan_job/widget/buttons/outline_buttons.dart';
import 'package:hindustan_job/widget/landing_page_widget/company_thats_trust_us.dart';
import 'package:hindustan_job/widget/landing_page_widget/custom_jobalert.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:hindustan_job/widget/landing_page_widget/latest_goverment_job.dart';
import 'package:hindustan_job/widget/landing_page_widget/popular_home_service.dart';
import 'package:hindustan_job/widget/landing_page_widget/private_sector_job_viewall.dart';
import 'package:hindustan_job/widget/landing_page_widget/resume_builder.dart';
import 'package:hindustan_job/widget/landing_page_widget/search_field.dart';
import 'package:hindustan_job/widget/landing_page_widget/slider/latestjob.dart';
import 'package:hindustan_job/widget/landing_page_widget/slider/testimonials_slider.dart';
import 'package:hindustan_job/widget/landing_page_widget/slider_home.dart';
import 'package:hindustan_job/widget/register_page_widget/text_field.dart';
import 'package:hindustan_job/widget/landing_page_widget/totaljobregister.dart';
import 'package:hindustan_job/widget/landing_page_widget/videoplayer.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:vrouter/vrouter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import '../../../localHunarAccount/model/local_hunar_video_model.dart';
import '../../../services/api_services/landing_page_services.dart';

final userDataProvider =
    riverpod.ChangeNotifierProvider<UserDataChangeNotifier>((ref) {
  return UserDataChangeNotifier();
});

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static const String route = '/home';
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  List<UserData> companies = [];
  List<JobsTwo> homeJobs = [];
  List<Services> popularHomeservice = [];
  List<Services> highestRatedServices = [];
  List<LocalHunarVideo> homeLocalHunarVideo = [];
  int totalJobSeekersRegistered = 0;
  int totalRecruitersRegistered = 0;
  int totalLocalHunarsRegistered = 0;
  int totalHomeServiceProvidersRegistered = 0;
  int totalHomeServiceSeekersRegistered = 0;
  int totalPrivateJobsPosted = 0;
  int totalGovtJobsPosted = 0;
  List<Widget> registered = [
    TotalJobRegister(label: "Total Job Seekers Registered", count: 0),
    TotalJobRegister(label: "Total Recruiters Registered", count: 0),
    TotalJobRegister(label: "Total Jobs Posted", count: 0),
    TotalJobRegister(
        label: "Total Home Service Providers Registered", count: 0),
    TotalJobRegister(label: "Total Home Service Seekers Registered", count: 0),
    TotalJobRegister(label: "Total Private Jobs Posted", count: 0),
    TotalJobRegister(label: "Total Govt. Jobs Posted", count: 0),
  ];

  @override
  void initState() {
    super.initState();
    print("hello homepage");
    initDynamicLinks(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAllCompany(true);
      fetchJobs();
      fetchLandingPageHomeServices();
      fetchLandingPageUserCounts();
      fetchLandingPageLocalHunar();
    });
  }

  fetchJobs() async {
    ApiResponse response = await getLandingPageJobs();
    if (response.status == 200) {
      homeJobs = JobModelTwo.fromJson(response.body!.data).jobsTwo!;
      setState(() {});
    }
  }

  fetchLandingPageHomeServices() async {
    ApiResponse response = await getLandingPageHomeServices();
    if (response.status == 200) {
      popularHomeservice =
          ServicesModel.fromJson(response.body!.data).services!;
      highestRatedServices =
          ServicesModel.fromJson(response.body!.data).services!;
      setState(() {});
    }
  }

  fetchLandingPageLocalHunar() async {
    ApiResponse response = await getLandingPageHomeServices();
    if (response.status == 200) {
      homeLocalHunarVideo =
          LocalHunarVideoModel.fromJson(response.body!.data).localHunarVideo!;
      setState(() {});
    }
  }

  fetchLandingPageUserCounts() async {
    ApiResponse response = await getLandingPageUserCounts();

    if (response.status == 200) {
      totalJobSeekersRegistered =
          response.body!.data['totalJobSeekersRegistered'];
      totalRecruitersRegistered =
          response.body!.data['totalRecruitersRegistered'];
      totalLocalHunarsRegistered =
          response.body!.data['totalLocalHunarRegistered'];
      totalHomeServiceProvidersRegistered =
          response.body!.data['totalHomeServiceProvidersRegistered'];
      totalHomeServiceSeekersRegistered =
          response.body!.data['totalHomeServiceSeekersRegistered'];
      totalPrivateJobsPosted = response.body!.data['totalPrivateJobsPosted'];
      totalGovtJobsPosted = response.body!.data['totalGovtJobsPosted'];
      registered = [
        TotalJobRegister(
            label: "Total Job Seekers Registred",
            count: totalJobSeekersRegistered),
        TotalJobRegister(
            label: "Total Recruiters Registred",
            count: totalRecruitersRegistered),
        TotalJobRegister(
            label: "Total Local Hunar", count: totalLocalHunarsRegistered),
        TotalJobRegister(
            label: "Total Home Service Providers Registred",
            count: totalHomeServiceProvidersRegistered),
        TotalJobRegister(
            label: "Total Home Service Seekers Registred",
            count: totalHomeServiceSeekersRegistered),
        TotalJobRegister(
            label: "Total Private Jobs posted", count: totalPrivateJobsPosted),
        TotalJobRegister(
            label: "Total Govt. Jobs posted", count: totalGovtJobsPosted),
      ];
      setState(() {});
    }
  }

  void initDynamicLinks(context) async {
    Future.delayed(const Duration(seconds: 3), () async {
      if (kIsWeb) {
        // var uri =
        //     Uri.dataFromString(window.location.href); //converts string to a uri
        // Map<String, String> params =
        //     uri.queryParameters; // query parameters automatically populated
        // print(params[
        //     'refer_code']); // return value of parameter "param1" from uri

        if (false) {
          // if (params['refer_code'] != null) {
          showDialog(
            context: context,
            routeSettings: const RouteSettings(name: Signup.route),
            builder: (_) => Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              insetPadding: EdgeInsets.symmetric(
                  horizontal: Sizeconfig.screenWidth! / 4, vertical: 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(00),
              ),
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 25),
                    color: Colors.amber,
                    child: Signup(
                        isUserSocialLogin: false,
                        // referralCode: params['refer_code']),
                        referralCode: ''),
                  ),
                  Positioned(
                    right: 0.0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 25,
                        width: 25,
                        padding: const EdgeInsets.all(5),
                        color: MyAppColor.backgroundColor,
                        alignment: Alignment.topRight,
                        child: Image.asset('assets/back_buttons.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      } else {
        if (!kIsWeb) {
          PendingDynamicLinkData? initialLink =
              await FirebaseDynamicLinks.instance.getInitialLink();
          FirebaseDynamicLinks.instance.onLink.listen((url) {
            print("""url""");
            print(url);
          });
          if (initialLink != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Signup(
                          referralCode:
                              initialLink.link.toString().split("=").last,
                          isUserSocialLogin: false,
                        )));
          }
        }
      }
    });
  }

  fetchAllCompany(flag) async {
    companies = await getHomepageVisibleCompany(flag: flag);
    setState(() {});
  }

  CarouselController buttonCarouselController = CarouselController();
  List<DropdownMenuItem<String>> _addDividersAfterItems(List<String> items) {
    List<DropdownMenuItem<String>> _menuItems = [];
    for (var item in items) {
      _menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(item, style: blackDarkOpacityM12()),
            ),
          ),
          //If it's last item, we will not add Divider after it.
          if (item != items.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: SizedBox(),
            ),
        ],
      );
    }
    return _menuItems;
  }

  List<int> _getDividersIndexes() {
    List<int> _dividersIndexes = [];
    for (var i = 0; i < (ListDropdown.salutations.length * 2) - 1; i++) {
      //Dividers indexes will be the odd indexes
      if (i.isOdd) {
        _dividersIndexes.add(i);
      }
    }
    return _dividersIndexes;
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  List<JobsTwo>? listOfJobs;

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  int currentPos = 0;
  int currentLate = 0;

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(statusBarColor: MyAppColor.backgroundColor),
      child: SafeArea(
          child: Scaffold(
        drawer: Drawer(
          child: DrawerLanding(),
        ),
        key: _drawerKey,
        drawerEnableOpenDragGesture: false,
        backgroundColor: MyAppColor.backgroundColor,
        appBar: PreferredSize(
            child: appbar(),
            preferredSize: Size.fromHeight(Sizeconfig.screenHeight!)),
        body: ListView(
          children: [
            Responsive.isMobile(context)
                ? homepagSlider()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      ImageFile.listPaths.length,
                      (index) => Container(
                        padding: index % 2 == 0
                            ? const EdgeInsets.only(top: 45)
                            : const EdgeInsets.only(top: 0),
                        child: MyImageView(
                          ImageFile.listPaths[index],
                          ImageFile.listCount[index],
                          ImageFile.listLabel[index],
                          ImageFile.listString[index],
                        ),
                      ),
                    )),
            SizedBox(
              height: Sizeconfig.screenHeight! / 25,
            ),
            Column(
              children: [
                Center(
                  child: Text(
                    Mystring.companyTrust,
                    style: blackDarkR16,
                  ),
                ),
                !Responsive.isDesktop(context)
                    ? SizedBox(
                        height: Sizeconfig.screenHeight! / 35,
                      )
                    : SizedBox(height: Sizeconfig.screenHeight! / 35),

                microsoftCard(context),
                !Responsive.isDesktop(context)
                    ? SizedBox(
                        height: Sizeconfig.screenHeight! / 20,
                      )
                    : SizedBox(height: Sizeconfig.screenHeight! / 10),

                Center(
                  child: Text(
                    Mystring.privateJobs,
                    style: blackDarkR16,
                  ),
                ),
                SizedBox(
                  height: !Responsive.isDesktop(context)
                      ? Sizeconfig.screenHeight! / 75
                      : Sizeconfig.screenHeight! / 30,
                ),
                homeJobs.isEmpty
                    ? loaderIndicator(context)
                    : Container(
                        child: Responsive.isDesktop(context)
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: Sizeconfig.screenWidth! / 20,
                                  ),
                                  Row(
                                    children: List.generate(
                                        homeJobs.length,
                                        (index) =>
                                            LatestJob(job: homeJobs[index])),
                                  ),
                                  SizedBox(
                                    width: Sizeconfig.screenWidth! / 18,
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  CarouselSlider.builder(
                                    itemCount: homeJobs.length,
                                    itemBuilder: (context, index, _) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: LatestJob(job: homeJobs[index]),
                                      );
                                    },
                                    options: CarouselOptions(
                                      viewportFraction: 1.0,
                                      enableInfiniteScroll: false,
                                      height: 225,
                                      aspectRatio: 3,
                                      autoPlay: true,
                                      onPageChanged: (index, _) {
                                        setState(
                                          () {
                                            currentLate = index;
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                        List.generate(homeJobs.length, (index) {
                                      return Container(
                                        width: 4.0,
                                        height: 4.0,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 15.0, horizontal: 10.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: currentLate == index
                                              ? MyAppColor.orangedark
                                              : Colors.grey,
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                      ),
                SizedBox(
                  height: !Responsive.isDesktop(context)
                      ? 00
                      : Sizeconfig.screenHeight! / 30,
                ),
                Center(
                    child: !Responsive.isDesktop(context)
                        ? OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 35),
                              child: Text(
                                Mystring.viewAll,
                                style: blackDarkR14(),
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.black)),
                          )
                        : const SizedBox()
                    // desktopviewAssll(),
                    ),

                !Responsive.isDesktop(context)
                    ? SizedBox(
                        height: Sizeconfig.screenHeight! / 12,
                      )
                    : SizedBox(
                        height: Sizeconfig.screenHeight! / 8,
                      ),

                !Responsive.isDesktop(context)
                    ? Column(
                        children: [
                          CustomJob(),
                          SizedBox(
                            height: Sizeconfig.screenHeight! / 90,
                          ),
                          //resume builder
                          const Resume_builder(),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: Sizeconfig.screenWidth! / 18,
                          ),
                          Expanded(
                            child: CustomJob(),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          const Expanded(
                            child: Resume_builder(),
                          ),
                          SizedBox(
                            width: Sizeconfig.screenWidth! / 16,
                          ),
                        ],
                      ),
                //custom job
                !Responsive.isDesktop(context)
                    ? SizedBox(
                        height: Sizeconfig.screenHeight! / 12,
                      )
                    : SizedBox(
                        height: Sizeconfig.screenHeight! / 8,
                      ),

                Column(
                  children: [
                    Center(
                      child: Text(
                        Mystring.popularHomeService,
                        style: blackDarkR16,
                      ),
                    ),
                    Responsive.isDesktop(context)
                        ? SizedBox(
                            height: Sizeconfig.screenHeight! / 35,
                          )
                        : const SizedBox(
                            height: 00,
                          ),
                    popularHomeservice.isEmpty
                        ? loaderIndicator(context)
                        : !Responsive.isDesktop(context)
                            ? Column(
                                children: [
                                  CarouselSlider.builder(
                                    itemCount: popularHomeservice.length,
                                    itemBuilder: (context, index, _) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: PopularHomeService(
                                            service: popularHomeservice[index]),
                                      );
                                    },
                                    options: CarouselOptions(
                                      viewportFraction: 1.0,
                                      height: 235,
                                      onPageChanged: (index, _) {
                                        setState(
                                          () {
                                            currentLate = index;
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                        popularHomeservice.length, (index) {
                                      return Container(
                                        width: 4.0,
                                        height: 4.0,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 20.0, horizontal: 10.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: currentLate == index
                                              ? MyAppColor.orangedark
                                              : Colors.grey,
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: Sizeconfig.screenWidth! / 20,
                                  ),
                                  Row(
                                      children: List.generate(
                                          popularHomeservice.length,
                                          (index) => PopularHomeService(
                                                service:
                                                    popularHomeservice[index],
                                              ))),
                                  SizedBox(
                                    width: Sizeconfig.screenWidth! / 18,
                                  ),
                                ],
                              ),
                    Responsive.isDesktop(context)
                        ? SizedBox(
                            height: Sizeconfig.screenHeight! / 35,
                          )
                        : const SizedBox(
                            height: 00,
                          ),
                    !Responsive.isDesktop(context)
                        ? buttonVewAll(context)
                        : desktopviewAll(),
                    const SizedBox(
                      height: 60,
                    ),
                    Column(
                      children: [
                        Center(
                          child: Text(
                            Mystring.homeService,
                            style: blackDarkR16,
                          ),
                        ),
                        SizedBox(
                          height: Responsive.isMobile(context) ? 19 : 00,
                        ),
                        Responsive.isDesktop(context)
                            ? SizedBox(
                                height: Sizeconfig.screenHeight! / 35,
                              )
                            : const SizedBox(
                                height: 00,
                              ),
                        popularHomeservice.isEmpty
                            ? loaderIndicator(context)
                            : Responsive.isMobile(context)
                                ? Column(
                                    children: [
                                      CarouselSlider.builder(
                                        itemCount: popularHomeservice.length,
                                        itemBuilder: (context, index, _) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: PopularHomeService(
                                                service:
                                                    popularHomeservice[index]),
                                          );
                                        },
                                        options: CarouselOptions(
                                          viewportFraction: 1.0,
                                          height: 235,
                                          onPageChanged: (index, _) {
                                            setState(
                                              () {
                                                currentLate = index;
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(
                                            popularHomeservice.length, (index) {
                                          return Container(
                                            width: 4.0,
                                            height: 4.0,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 20.0,
                                                horizontal: 10.0),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: currentLate == index
                                                  ? MyAppColor.orangedark
                                                  : Colors.grey,
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: Sizeconfig.screenWidth! / 20,
                                      ),
                                      Row(
                                          children: List.generate(
                                              popularHomeservice.length,
                                              (index) => PopularHomeService(
                                                    service: popularHomeservice[
                                                        index],
                                                  ))),
                                      SizedBox(
                                        width: Sizeconfig.screenWidth! / 18,
                                      ),
                                    ],
                                  ),
                        Responsive.isDesktop(context)
                            ? SizedBox(
                                height: Sizeconfig.screenHeight! / 35,
                              )
                            : const SizedBox(
                                height: 00,
                              ),
                        !Responsive.isDesktop(context)
                            ? buttonVewAll(context)
                            : desktopviewAll(),
                        Responsive.isDesktop(context)
                            ? SizedBox(
                                height: Sizeconfig.screenHeight! / 35,
                              )
                            : const SizedBox(
                                height: 00,
                              ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            !Responsive.isDesktop(context)
                ? SizedBox(
                    height: Sizeconfig.screenHeight! / 13,
                  )
                : SizedBox(
                    height: Sizeconfig.screenHeight! / 9,
                  ),
            // Responsive.isMobile(context)
            //     ? Column(
            //         children: [
            //           Text(
            //             'MOST VIEWED LOCAL HUNAR',
            //             style: blackDarkR16,
            //           ),
            //           SizedBox(
            //             height: Sizeconfig.screenHeight! / 75,
            //           ),
            //           CarouselSlider.builder(
            //             itemCount: homeLocalHunarVideo.length,
            //             itemBuilder: (context, index, _) {
            //               return Padding(
            //                 padding: const EdgeInsets.all(8.0),
            //                 child: Videos(
            //                     localHunarVideo: homeLocalHunarVideo[index]),
            //               );
            //             },
            //             options: CarouselOptions(
            //               viewportFraction: 1,
            //               enableInfiniteScroll: false,
            //               height: Sizeconfig.screenHeight! / 1.4,
            //               // aspectRatio: 3,
            //               onPageChanged: (index, _) {
            //                 setState(
            //                   () {
            //                     currentLate = index;
            //                   },
            //                 );
            //               },
            //             ),
            //           ),
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: List.generate(
            //               homeJobs.length,
            //               (index) {
            //                 return Container(
            //                   width: 4.0,
            //                   height: 4.0,
            //                   margin: const EdgeInsets.symmetric(
            //                       vertical: 8.0, horizontal: 10.0),
            //                   decoration: BoxDecoration(
            //                     shape: BoxShape.circle,
            //                     color: currentLate == index
            //                         ? MyAppColor.orangedark
            //                         : Colors.grey,
            //                   ),
            //                 );
            //               },
            //             ),
            //           ),
            //           SizedBox(
            //             height: 10,
            //           ),
            //           buttonVewAll(context),
            //         ],
            //       )
            //     : Column(
            //         children: [
            //           Text(
            //             'MOST VIEWED LOCAL HUNAR',
            //             style: blackDarkR16,
            //           ),
            //           SizedBox(
            //             height: Sizeconfig.screenHeight! / 25,
            //           ),
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               SizedBox(
            //                 width: Sizeconfig.screenWidth! / 18,
            //               ),
            //               Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: List.generate(
            //                     homeLocalHunarVideo.length,
            //                     (index) => Videos(
            //                         localHunarVideo:
            //                             homeLocalHunarVideo[index]),
            //                   )),
            //               SizedBox(
            //                 width: Sizeconfig.screenWidth! / 16,
            //               ),
            //             ],
            //           ),
            //           SizedBox(
            //             height: Sizeconfig.screenHeight! / 25,
            //           ),
            //           desktopviewAll(),
            //         ],
            //       ),
            // const SizedBox(
            //   height: 57,
            // ),
            const TestominialsSlider(),
            SizedBox(
              height: Responsive.isMobile(context) ? 19 : 00,
            ),
            Center(
              child: Text(
                "BECOME OUR BUSINESS PARTNER",
                style: blackDarkR16,
              ),
            ),
            SizedBox(
              height: Responsive.isMobile(context) ? 19 : 00,
            ),
            Responsive.isMobile(context)
                ? Column(
                    children: [
                      AboutCard(
                          image: 'assets/phone-man-slider.png',
                          role: 'Business Correspondence',
                          description:
                              'Enroll a user & earn 30% comission each time when a user subscribed & also  Earn 5% on adding Sub BC and many more…'),
                      AboutCard(
                        image: 'assets/female-about.png',
                        role: 'Cluster Manager',
                        description:
                            'Manage your Business Corespondence and earn comission & also get 30%  while enrolling a user under your profile & and many more..',
                      ),
                      AboutCard(
                          image: 'assets/man-discuss-bout.png',
                          role: 'Advisor',
                          description:
                              'Enroll a user & earn 30% comission each time when a user subscribed.'),
                      AboutCard(
                          image: 'assets/female-call-centre.png',
                          role: 'Field Sales Executive',
                          description:
                              'Enroll Job Seekers, Recruiters, Home Service Providers, Homes Service Seekers & Local Hunars and become salaried employee.')
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AboutCard(
                          image: 'assets/phone-man-slider.png',
                          role: 'Business Correspondence',
                          description:
                              'Enroll a User & earn Commission when the enrolled user Subscribes for the first time.'),
                      AboutCard(
                        image: 'assets/female-about.png',
                        role: 'Cluster Manager',
                        description:
                            'Manage Business Corr. & earn Commission when enrolled user Subscribes for the first time.',
                      ),
                      AboutCard(
                          image: 'assets/man-discuss-bout.png',
                          role: 'Advisor',
                          description:
                              'Enroll Candidates, Recruiters & Service Providers. Earn Commission on their first Subscription.'),
                      AboutCard(
                          image: 'assets/female-call-centre.png',
                          role: 'Field Sales Executive',
                          description:
                              'Enroll Job Seeker, Recruiters & Service Providers. Provide Customer Support.')
                    ],
                  ),
            SizedBox(
              height: Sizeconfig.screenHeight! / 10,
            ),
            Text(
              Mystring.whyUs,
              style: blackDarkR16,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: Sizeconfig.screenHeight! / 75,
            ),
            Responsive.isMobile(context)
                ? Column(
                    children: [
                      CarouselSlider.builder(
                        itemCount: registered.length,
                        itemBuilder: (context, index, _) {
                          return Padding(
                            padding: const EdgeInsets.all(7),
                            child: registered[index],
                          );
                        },
                        options: CarouselOptions(
                          enableInfiniteScroll: true,
                          height: 180,

                          // autoPlay: true,

                          onPageChanged: (index, _) {
                            setState(
                              () {
                                currentLate = index;
                              },
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(registered.length, (index) {
                          return Container(
                            width: 4.0,
                            height: 4.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 10.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: currentLate == index
                                  ? MyAppColor.orangedark
                                  : Colors.grey,
                            ),
                          );
                        }),
                      ),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TotalJobRegister(
                                label: "Total Job Seekers\nRegistered",
                                count: totalJobSeekersRegistered),
                            TotalJobRegister(
                                label: "Total Recruiters\nRegistered",
                                count: totalRecruitersRegistered),
                            TotalJobRegister(
                                label: "Total Local Hunar\nRegistered",
                                count: totalLocalHunarsRegistered),
                            TotalJobRegister(
                                label:
                                    "Total Home Service Providers\nRegistered",
                                count: totalHomeServiceProvidersRegistered),
                            TotalJobRegister(
                                label: "Total Home Service Seekers\nRegistered",
                                count: totalHomeServiceSeekersRegistered),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TotalJobRegister(
                                label: "Total Private Jobs\nposted",
                                count: totalPrivateJobsPosted),
                            TotalJobRegister(
                                label: "Total Govt. Jobs\nposted",
                                count: totalGovtJobsPosted),
                          ],
                        ),
                      ],
                    ),
                  ),
            const SizedBox(
              height: 40,
            ),
            Footer(
              loginPop: loginPop,
            ),
          ],
        ),
      )),
    );
  }

  Widget desktopviewAll() {
    return SizedBox(
      height: 36,
      width: Sizeconfig.screenWidth! / 9,
      child: OutlinedButton(
        onPressed: () {
          if (Responsive.isDesktop(context)) {
            loginPop();
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Login()));
          }
        },
        child: Text(
          Mystring.viewAll,
          style: TextStyle(color: MyAppColor.blackdark, fontSize: 13),
        ),
        style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.black)),
      ),
    );
  }

  Widget buttonVewAll(BuildContext context) {
    return Center(
      child: !Responsive.isDesktop(context)
          ? OutlinedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Text(
                  Mystring.viewAll,
                  style: blackDarkR14(),
                ),
              ),
              style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black)),
            )
          : SizedBox(
              height: 36,
              width: Sizeconfig.screenWidth! / 9,
              child: OutlinedButton(
                onPressed: () {
                  loginPop();
                },
                child: Text(Mystring.viewAll, style: blackDarkR20),
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black)),
              ),
            ),
    );
  }

  Widget microsoftCard(BuildContext context) {
    return Column(
      children: [
        Responsive.isDesktop(context)
            ? Container(
                alignment: Alignment.center,

                // margin: EdgeInsets.only(left: 50),
                width: Sizeconfig.screenWidth! / 1.2,
                child: Wrap(
                  runSpacing: 11,
                  spacing: 11,
                  children: [
                    for (var i = 0; i < companies.length; i++)
                      Cradwidget(company: companies[i]),
                  ],
                ),
              )
            : Wrap(
                runSpacing: 17,
                spacing: 17,
                children: List.generate(
                    companies.length > 8 ? 8 : companies.length,
                    (index) => Cradwidget(
                          company: companies[index],
                        )),
              ),
        const SizedBox(height: 20),
        OutlinedButton(
          onPressed: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CompanyListPage(
                          companyList: companies,
                        )));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Text(
              Mystring.viewAll,
              style: blackDarkR14(),
            ),
          ),
          style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black)),
        )
      ],
    );
  }

  Widget homepagSlider() {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: ImageFile.listPaths.length,
          options: CarouselOptions(
            enableInfiniteScroll: false,
            viewportFraction: 0.95,
            height: Sizeconfig.screenHeight! / 2.8,
            // aspectRatio: 16 / 9,
            // autoPlay: true,
            onPageChanged: (index, _) {
              setState(() {
                currentPos = index;
              });
            },
          ),
          itemBuilder: (BuildContext context, int index, _) {
            return MyImageView(
                ImageFile.listPaths[index],
                ImageFile.listCount[index],
                ImageFile.listLabel[index],
                ImageFile.listString[index]);
          },
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: ImageFile.listPaths.map((url) {
            int index = ImageFile.listPaths.indexOf(url);
            return Container(
              width: 4.0,
              height: 4.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentPos == index
                      ? MyAppColor.orangelight
                      : Colors.grey),
            );
          }).toList(),
        )
      ],
    );
  }

  Widget appbar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!Responsive.isDesktop(context))
          SizedBox(
            height: Sizeconfig.screenHeight! / 50,
          ),
        Padding(
          padding: Responsive.isDesktop(context)
              ? const EdgeInsets.symmetric(vertical: 22.0, horizontal: 30)
              : const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              drawerImage(context),
              if (Responsive.isDesktop(context))
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SerchJobHere(),
                    ],
                  ),
                ),
              loginButtons(context),
            ],
          ),
        ),
        if (!Responsive.isDesktop(context))
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Search(
              route: Login(),
            ),
          ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Widget loginButtons(BuildContext context) {
    return Padding(
      padding: !Responsive.isDesktop(context)
          ? const EdgeInsets.all(00)
          : const EdgeInsets.only(top: 7),
      child: Button(
        text: Mystring.login,
        func: () {
          !Responsive.isDesktop(context)
              ? Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login()))
              : loginPop();
        },
      ),
    );
  }

  Widget serchJobDesktop(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: Sizeconfig.screenWidth! / 6,
            height: Sizeconfig.screenHeight! / 20,
            child: TextfieldWidget(
              styles: desktopstyle,
              text: 'Search by job title',
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          customDropdown(
            selectingValue: DropdownString.selectIndustry,
            setdata: (newValue) {
              setState(
                () {
                  DropdownString.selectIndustry = newValue!;
                },
              );
            },
            context: context,
            label: "Select job role",
            listDropdown: ListDropdown.selectIndustries,
          ),
          const SizedBox(
            width: 5,
          ),
          customDropdown(
            selectingValue: DropdownString.sector,
            setdata: (newValue) {
              setState(
                () {
                  DropdownString.sector = newValue!;
                },
              );
            },
            context: context,
            label: "Select Sector",
            listDropdown: ListDropdown.sectors,
          ),
          const SizedBox(
            width: 5,
          ),
          customDropdown(
            selectingValue: DropdownString.location,
            setdata: (newValue) {
              setState(
                () {
                  DropdownString.location = newValue!;
                },
              );
            },
            context: context,
            label: "Select Location",
            listDropdown: ListDropdown.locations,
          ),
          const SizedBox(
            width: 5,
          ),
          customDropdown(
            selectingValue: DropdownString.experience,
            setdata: (newValue) {
              setState(
                () {
                  DropdownString.experience = newValue!;
                },
              );
            },
            context: context,
            label: "Select Expeience",
            listDropdown: ListDropdown.experiences,
          ),
          const SizedBox(
            width: 5,
          ),
          search(),
        ],
      ),
    );
  }

  Widget customDropdown({
    BuildContext? context,
    List<String>? listDropdown,
    String? label,
    String? selectingValue,
    Function? setdata,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 00.0, vertical: 9),
      child: Container(
        height: Sizeconfig.screenHeight! / 20,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: MyAppColor.white),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            focusColor: MyAppColor.white,
            buttonElevation: 00,
            icon: IconFile.arrow,
            iconSize: 17,
            isExpanded: true,
            hint: Text(
              label!,
              style: blackDarkOpacityR9(),
            ),
            items: _addDividersAfterItems(listDropdown!),
            customItemsIndexes: _getDividersIndexes(),
            customItemsHeight: 4,
            value: selectingValue,
            style: blackDarkOpacityR9(),
            onChanged: (value) => setdata!(value),
            buttonWidth: !Responsive.isDesktop(context!)
                ? Sizeconfig.screenWidth! / 1.2
                : Sizeconfig.screenWidth! / 9.1,
            buttonPadding: const EdgeInsets.symmetric(horizontal: 0),
            buttonHeight: 40,
            itemHeight: 40,
          ),
        ),
      ),
    );
  }

  Widget drawerImage(BuildContext context) {
    return Row(
      children: [
        InkWell(
          hoverColor: Colors.transparent,
          onTap: () {
            _drawerKey.currentState!.openDrawer();
          },
          child: Image.asset(
            'assets/drawers.png',
            height: 19,
          ),
        ),
        SizedBox(
          width: !Responsive.isDesktop(context)
              ? Sizeconfig.screenWidth! / 35
              : Sizeconfig.screenWidth! / 100,
        ),
        Image.asset(
          'assets/hind.png',
          height: 40,
        ),
        // if (Responsive.isDesktop(context))
        //   SizedBox(
        //     width: Sizeconfig.screenWidth! / 6,
        //   ),
      ],
    );
  }

  search() {
    return Container(
      padding: const EdgeInsets.all(6),
      height: Sizeconfig.screenHeight! / 20,
      width: Sizeconfig.screenWidth! / 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: MyAppColor.orangelight,
      ),
      child: Image.asset(
        'assets/search_image.png',
        height: 10,
      ),
    );
  }

  loginPop() {
    return showDialog(
      context: context,
      routeSettings: const RouteSettings(name: Login.route),
      builder: (_) => Container(
        constraints: BoxConstraints(maxWidth: Sizeconfig.screenWidth! / 2.9),
        child: Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(
              horizontal: Sizeconfig.screenWidth! / 2.9, vertical: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(00),
          ),
          child: Container(
            child: Stack(
              children: [
                Container(
                  color: Colors.transparent,
                  margin: const EdgeInsets.only(
                    right: 25,
                  ),
                  child: Login(),
                ),
                Positioned(
                  right: 0.0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 25,
                      width: 25,
                      padding: const EdgeInsets.all(5),
                      color: MyAppColor.backgroundColor,
                      alignment: Alignment.topRight,
                      child: Image.asset('assets/back_buttons.png'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
