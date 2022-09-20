// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hindustan_job/candidate/header/app_bar.dart';
import 'package:hindustan_job/candidate/header/back_text_widget.dart';
import 'package:hindustan_job/candidate/model/company_page_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/drawer/drawer_jobseeker.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/drawer/work_culture.dart';
import 'package:hindustan_job/candidate/pages/landing_page/search_job_here.dart';
import 'package:hindustan_job/candidate/pages/side_drawerpages/notification.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/services/auth/company_services.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/widget/landing_page_widget/search_field.dart';

import 'comapny_overview.dart';
import 'offerring_by_company.dart';

class SpecificCompany extends StatefulWidget {
  String? companyId;
  SpecificCompany({Key? key, this.companyId}) : super(key: key);

  @override
  State<SpecificCompany> createState() => _SpecificCompanyState();
}

class _SpecificCompanyState extends State<SpecificCompany>
    with SingleTickerProviderStateMixin {
  TabController? _control;
  @override
  void initState() {
    super.initState();
    fetchCompanyPageDetails(widget.companyId);
    setState(() {
      _control = TabController(initialIndex: 0, length: 3, vsync: this);
    });
  }

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  CompanyPageModel? companyPageModel;

  fetchCompanyPageDetails(id) async {
    ApiResponse response = await getCompanyPage(id);
    companyPageModel = CompanyPageModel.fromJson(response.body!.data);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    final styles = Mytheme.lightTheme(context).textTheme.headline1!;
    return Scaffold(
      backgroundColor: MyAppColor.backgroundColor,
      key: _drawerKey,
      drawer: const Drawer(
        child: DrawerJobSeeker(),
      ),
      appBar: !kIsWeb
          ? PreferredSize(
              child: BackWithText(text: "HOME (JOB-SEEKER) /EDIT PROFILE"),
              preferredSize: Size.fromHeight(50))
          : CustomAppBar(
              context: context,
              drawerKey: _drawerKey,
              back: "HOME (JOB-SEEKER) / JOBS / JOB #123456",
            ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              children: [
                SizedBox(
                  height: 14,
                ),
                if (Responsive.isDesktop(context)) SerchJobHere(),
                if (!Responsive.isDesktop(context)) Search(),
                SizedBox(
                  height: 30,
                ),
                if (companyPageModel != null)
                  Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                Responsive.isDesktop(context) ? 40 : 00),
                        child: Container(
                          margin: EdgeInsets.only(
                              left: !Responsive.isDesktop(context) ? 5 : 50,
                              right: !Responsive.isDesktop(context) ? 5 : 36),
                          // height: Sizeconfig.screenHeight! / 5,
                          width: !Responsive.isDesktop(context)
                              ? Sizeconfig.screenWidth
                              : Sizeconfig.screenWidth! / 1.1,
                          color: MyAppColor.greylight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: Sizeconfig.screenHeight! / 50,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                child: Text(
                                    '${companyPageModel!.companyDetail != null ? companyPageModel!.companyDetail!.name : ''}',
                                    style: styles.copyWith(
                                        color: MyAppColor.backgroundColor)),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  'Company',
                                  style: styles.copyWith(
                                      color: MyAppColor.backgroundColor,
                                      fontSize: 10),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  'Sector: Private',
                                  style: styles.copyWith(
                                      color: MyAppColor.backgroundColor,
                                      fontSize: 14),
                                ),
                              ),
                              SizedBox(
                                height: Sizeconfig.screenHeight! / 50,
                              ),
                              if (!Responsive.isDesktop(context)) tab(styles),
                              if (Responsive.isDesktop(context))
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: Sizeconfig.screenWidth! / 3,
                                      child: tab(styles),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 00,
                        right: !Responsive.isDesktop(context)
                            ? 5
                            : Sizeconfig.screenWidth! / 15,
                        child: Image.asset(
                          'assets/top_lakshay.png',
                          height: Sizeconfig.screenHeight! / 40,
                        ),
                      )
                    ],
                  ),
                if (companyPageModel != null)
                  SizedBox(
                    height: Sizeconfig.screenHeight!,
                    child: TabBarView(
                      controller: _control,
                      children: [
                        OfferingByCompany(
                          jobs: companyPageModel != null
                              ? companyPageModel!.postedJobs!
                              : [],
                        ),
                        OverViewCompany(
                          userData: companyPageModel!.companyDetail,
                        ),
                        WorkCulture(
                          companyImageList: companyPageModel != null
                              ? companyPageModel!.companyPhoto!
                              : [],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TabBar tab(TextStyle styles) {
    return TabBar(
      indicatorColor: MyAppColor.orangelight,
      controller: _control,
      labelColor: MyAppColor.blacklight,
      unselectedLabelColor: Colors.black,
      tabs: [
        Text(
          '   Jobs Offering\n by the Company',
          style:
              styles.copyWith(color: MyAppColor.backgroundColor, fontSize: 11),
        ),
        Text(
          ' Company\n Overview',
          style:
              styles.copyWith(color: MyAppColor.backgroundColor, fontSize: 11),
        ),
        Text(
          '   Work Culture\n in the Company',
          style:
              styles.copyWith(color: MyAppColor.backgroundColor, fontSize: 11),
        ),
      ],
    );
  }


  Container _menu() {
    return Container(
      width: Responsive.isDesktop(context) ? Sizeconfig.screenWidth! / 3 : null,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 2, right: 2),
                child: Column(
                  children: [
                    Container(
                      height: 3,
                      color: MyAppColor.orangelight,
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      "Job-seeker Account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: MyAppColor.orangelight),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 2, right: 2),
                child: Column(
                  children: [
                    Container(
                      height: 3,
                      color: MyAppColor.greynormal,
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      "Home-service provider",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 11,
                          color: MyAppColor.normalblack,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 2, right: 2),
                child: Column(
                  children: [
                    Container(
                      height: 3,
                      color: MyAppColor.greynormal,
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      "Home-service seeker",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: MyAppColor.normalblack,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 2, right: 2),
                child: Column(
                  children: [
                    Container(
                      height: 3,
                      color: MyAppColor.greynormal,
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      "Local Hunar Account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: MyAppColor.normalblack,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _back() {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: Container(
        height: Sizeconfig.screenHeight! / 20,
        color: MyAppColor.greynormal,
        child: Row(
          children: [
            SizedBox(
              width: 3,
            ),
            Container(
              height: 30,
              child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: MyAppColor.backgray,
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 17,
                      color: Colors.black,
                    ),
                  )),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Back",
              style: TextStyle(
                color: MyAppColor.blackdark,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Text("HOME (JOB-SEEKER) / COMPANY: LAKSHYA CORPORATION",
                style: GoogleFonts.darkerGrotesque(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
