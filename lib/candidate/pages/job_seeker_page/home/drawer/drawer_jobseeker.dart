// ignore_for_file: prefer_const_constructors, unused_import, avoid_unnecessary_containers
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/subscribed_listed.dart';
import 'package:hindustan_job/candidate/pages/resume_builder_form.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/drawer/subscriptions_plan.dart';
import 'package:hindustan_job/candidate/pages/landing_page/home_page.dart';
import 'package:hindustan_job/candidate/pages/resume_view.dart';
import 'package:hindustan_job/candidate/pages/side_drawerpages/customjob_alert.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:http/http.dart' as http;
// import 'dart:html' as html;
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrouter/vrouter.dart';
import '../../../../../company/home/pages/subscription_details_of_company.dart';
import '../../../../../company/home/search/searchcompany.dart';
import '../../../../../widget/landing_page_widget/chat_contacts_widget.dart';
import '../homeappbar.dart';
import 'my_referral_code.dart';
import 'my_transaction.dart';
import 'mywallet_bank_details.dart';
import 'package:go_router/go_router.dart';

class DrawerJobSeeker extends StatefulWidget {
  const DrawerJobSeeker({Key? key}) : super(key: key);

  @override
  State<DrawerJobSeeker> createState() => _DrawerJobSeekerState();
}

class _DrawerJobSeekerState extends State<DrawerJobSeeker> {
  String? generatedPdfFilePath;

  Future<void> generateExampleDocuments(html) async {
    Directory? appDocDir = await getDownloadsDirectory();
    final targetPath = appDocDir!.path;
    String targetFileName =
        "${DateTime.now().millisecondsSinceEpoch}_Hindustan-Job";
    final generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
        html, targetPath, targetFileName);
    generatedPdfFilePath = generatedPdfFile.path;
    OpenFile.open('$generatedPdfFilePath')
        .then((value) => print("ggggggggg$value"))
        .catchError((onError) {});
  }

  var htmlData;
  getHtmlData() async {
    EasyLoading.show();
    var data = await http.get(
      Uri.parse("https://admin.hindustaanjobs.com/api/resume-html"),
      headers: {"Authorization": "Bearer ${userData!.resetToken!}"},
    );
    EasyLoading.dismiss();

    htmlData = data.body;
    if (data.statusCode == 200) {
      generateExampleDocuments(htmlData);
    } else {
      showSnack(context: context, msg: "Something went wrong", type: 'error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme.headline1!;
    return Consumer(builder: (context, ref, child) {
      bool isCandidateSubscribed =
          ref.watch(editProfileData).isCandidateSubscribed;
      return Container(
        color: MyAppColor.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: MyAppColor.backgroundColor),
                child: SizedBox(),
              ),
              if (userData?.userRoleType == RoleTypeConstant.jobSeeker)
                Column(
                  children: [
                    ListTile(
                      title: Row(
                        children: [
                          SizedBox(
                            height: 24,
                            width: 22,
                            child: Image.asset('assets/my-resume.png'),
                          ),
                          SizedBox(
                            width: 13,
                          ),
                          Text(
                            'My Resume',
                            style: styles.copyWith(fontSize: 17),
                          ),
                        ],
                      ),
                      onTap: () async {
                        if (!isCandidateSubscribed) {
                          subscriptionaAlertBox(
                            context,
                            "You are not subscribed user please click on yes if want to subscribe",
                            title: 'Subscribe Now',
                          );
                        } else {
                          if (!kIsWeb) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResumeView()));
                          } else {
                            //   html.document.createElement('a')
                            //       as html.AnchorElement
                            //     ..href =
                            //         'https://admin.hindustaanjobs.com/api/resume-html-no-auth?id=${userData!.id}'
                            //     ..download = "chetan1.pdf"
                            //     ..dispatchEvent(
                            //         html.Event.eventType('MouseEvent', 'click'));
                          }
                        }
                        return;
                      },
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          SizedBox(
                            height: 24,
                            width: 22,
                            child: Image.asset('assets/resume-builder.png'),
                          ),
                          SizedBox(
                            width: 13,
                          ),
                          Text(
                            'Resume Builder',
                            style: styles.copyWith(fontSize: 17),
                          ),
                        ],
                      ),
                      onTap: () {
                        if (kIsWeb) {
                          context.vRouter.to('/hindustaan-jobs/resume-builder');
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResumeBuilder(
                                        isFromConnectedRoutes: false,
                                      )));
                        }
                        return;
                      },
                    ),
                    myWallet(styles, context),
                  ],
                ),
              if (userData?.userRoleType == RoleTypeConstant.company ||
                  userData?.userRoleType ==
                      RoleTypeConstant.homeServiceProvider ||
                  userData?.userRoleType == RoleTypeConstant.jobSeeker)
                ListTile(
                  title: Row(
                    children: [
                      SizedBox(
                        height: 24,
                        width: 22,
                        child: Image.asset('assets/my-transactions.png'),
                      ),
                      SizedBox(
                        width: 13,
                      ),
                      Text(
                        'My Transactions',
                        style: styles.copyWith(fontSize: 17),
                      ),
                    ],
                  ),
                  onTap: () {
                    if (kIsWeb) {
                      context.vRouter.to("/hindustaan-jobs/my-transactions");
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyTransaction()));
                    }
                    return;
                  },
                ),
              if (userData!.userRoleType != RoleTypeConstant.companyStaff &&
                  userData!.userRoleType !=
                      RoleTypeConstant.businessCorrespondence &&
                  userData!.userRoleType !=
                      RoleTypeConstant.homeServiceSeeker &&
                  userData!.userRoleType != RoleTypeConstant.localHunar)
                ListTile(
                  title: Row(
                    children: [
                      SizedBox(
                        height: 24,
                        width: 22,
                        child: Image.asset('assets/resume-builder.png'),
                      ),
                      SizedBox(
                        width: 13,
                      ),
                      Text(
                        'Subscription Plans',
                        style: styles.copyWith(fontSize: 17),
                      ),
                    ],
                  ),
                  onTap: () {
                    if (kIsWeb) {
                      context.vRouter.to("/hindustaan-jobs/subscription-plans");
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubscriptionPlans()));
                    }
                    return;
                  },
                ),
              if (userData!.userRoleType == RoleTypeConstant.company ||
                  userData!.userRoleType == RoleTypeConstant.jobSeeker ||
                  userData!.userRoleType ==
                      RoleTypeConstant.homeServiceProvider)
                ListTile(
                  title: Row(
                    children: [
                      SizedBox(
                        height: 24,
                        width: 22,
                        child: Image.asset('assets/my-transactions.png'),
                      ),
                      SizedBox(
                        width: 13,
                      ),
                      Text(
                        'Subscription Details',
                        style: styles.copyWith(fontSize: 17),
                      ),
                    ],
                  ),
                  onTap: () {
                    if (kIsWeb) {
                      context.vRouter
                          .to("/hindustaan-jobs/subscription-details");
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SubscriptionDetailsCompany()));
                    }
                  },
                ),
              if (userData!.userRoleType == RoleTypeConstant.company ||
                  userData!.userRoleType == RoleTypeConstant.companyStaff)
                ListTile(
                  title: Row(
                    children: [
                      SizedBox(
                        height: 24,
                        width: 22,
                        child: Image.asset('assets/my-transactions.png'),
                      ),
                      SizedBox(
                        width: 13,
                      ),
                      Text(
                        'Resume Access',
                        style: styles.copyWith(fontSize: 17),
                      ),
                    ],
                  ),
                  onTap: () {
                    if (kIsWeb) {
                      context.vRouter.to("/home-company/search-candidates");
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchCompany(
                                    isNotApplied: true,
                                    data: const {"candidate": "NOT_APPLIED"},
                                    // data: const {},
                                    isUserSubscribed: true,
                                  )));
                    }
                  },
                ),
              if (userData!.userRoleType ==
                  RoleTypeConstant.homeServiceProvider)
                myWallet(styles, context),
              if (userData!.userRoleType == RoleTypeConstant.jobSeeker)
                ListTile(
                  title: Row(
                    children: [
                      SizedBox(
                        height: 24,
                        width: 22,
                        child: Icon(Icons.message,
                            color: MyAppColor.blackdark.withOpacity(0.7)),
                      ),
                      SizedBox(
                        width: 13,
                      ),
                      Text(
                        'My Messages',
                        style: styles.copyWith(
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  onTap: () async {
                    await chatContactBox(context, chatingMessage);
                  },
                ),
              if (userData!.userRoleType == RoleTypeConstant.jobSeeker)
                Column(
                  children: [
                    ListTile(
                      title: Row(
                        children: [
                          SizedBox(
                            height: 24,
                            width: 22,
                            child: Image.asset('assets/custom.png'),
                          ),
                          SizedBox(
                            width: 13,
                          ),
                          Text(
                            'Custom Job Alert',
                            style: styles.copyWith(fontSize: 17),
                          )
                        ],
                      ),
                      onTap: () {
                        if (!isCandidateSubscribed) {
                          subscriptionaAlertBox(
                            context,
                            "You are not subscribed user please click on yes if want to subscribe",
                            title: 'Subscribe Now',
                          );
                        } else {
                          if (kIsWeb) {
                            context.vRouter.to("/job-seeker/custom-job-alert");
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CustomJobAlerts(
                                          isFromConnectedRoutes: false,
                                        )));
                          }
                        }
                        return;
                      },
                    ),
                  ],
                ),
              if (userData!.userRoleType !=
                      RoleTypeConstant.homeServiceSeeker &&
                  userData!.userRoleType != RoleTypeConstant.companyStaff &&
                  userData!.userRoleType != RoleTypeConstant.localHunar)
                refCode(styles, context, isCandidateSubscribed),
              ListTile(
                title: Row(
                  children: [
                    SizedBox(
                      height: 24,
                      width: 22,
                      child: Image.asset('assets/logout.png'),
                    ),
                    SizedBox(
                      width: 13,
                    ),
                    Text(
                      'Log Out',
                      style: styles.copyWith(fontSize: 17),
                    )
                  ],
                ),
                onTap: () async {
                  var val = await alertBox(
                    context,
                    'Are you sure you want to logout ?',
                    title: 'Log Out',
                  );
                  if (val == 'Done') {
                    await logout();
                    context.vRouter.to("/home");
                    return;
                    if (kIsWeb) {
                      context.vRouter.to("/home");
                    } else {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    }
                  }
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  ListTile myWallet(TextStyle styles, BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          SizedBox(
            height: 24,
            width: 22,
            child: Image.asset('assets/my-wallet.png'),
          ),
          SizedBox(
            width: 13,
          ),
          Text(
            'My Wallet & Bank Details',
            style: styles.copyWith(fontSize: 17),
          ),
        ],
      ),
      onTap: () {
        if (kIsWeb) {
          context.vRouter.to("/hindustaan-jobs/wallet");
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyWallet()));
        }
        return;
      },
    );
  }

  ListTile refCode(
      TextStyle styles, BuildContext context, isCandidateSubscribed) {
    return ListTile(
      title: Row(
        children: [
          SizedBox(
            height: 24,
            width: 22,
            child: Image.asset('assets/my-referral.png'),
          ),
          SizedBox(
            width: 13,
          ),
          Text(
            'My referral Code',
            style: styles.copyWith(fontSize: 17),
          ),
        ],
      ),
      onTap: () {
        if (RoleTypeConstant.fieldSalesExecutive != userData?.userRoleType &&
            RoleTypeConstant.advisor != userData?.userRoleType &&
            RoleTypeConstant.clusterManager != userData?.userRoleType &&
            RoleTypeConstant.businessCorrespondence != userData?.userRoleType &&
            !isCandidateSubscribed) {
          subscriptionaAlertBox(
            context,
            "You are not subscribed user please click on yes if want to subscribe",
            title: 'Subscribe Now',
          );
        } else {
          !Responsive.isDesktop(context)
              ? Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyReferralCode()))
              : showDialog(
                  context: context,
                  builder: (_) => Container(
                    constraints:
                        BoxConstraints(maxWidth: Sizeconfig.screenWidth! / 3.5),
                    child: Dialog(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      insetPadding:
                          EdgeInsets.symmetric(horizontal: 500, vertical: 110),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(00),
                      ),
                      child: Container(
                        child: Stack(
                          children: [
                            Container(
                              color: Colors.transparent,
                              margin: EdgeInsets.only(
                                right: 25,
                              ),
                              child: MyReferralCode(),
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
                                  padding: EdgeInsets.all(5),
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
      },
    );
  }
}
