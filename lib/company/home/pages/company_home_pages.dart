// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_declarations, constant_identifier_names, unused_element, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_list.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_string.dart';
import 'package:hindustan_job/candidate/icons/icon.dart';
import 'package:hindustan_job/candidate/model/Company/chart_bar.dart';
import 'package:hindustan_job/candidate/model/chat_contact_model.dart';
import 'package:hindustan_job/candidate/model/company_dashboard_model.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/chatscreen.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/drawer/subscriptions_plan.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/company/home/add_staff_member.dart';
import 'package:hindustan_job/company/home/create_job_post.dart';
import 'package:hindustan_job/company/home/homepage.dart';
import 'package:hindustan_job/company/home/pages/barchats.dart';
import 'package:hindustan_job/company/home/search/searchcompany.dart';
import 'package:hindustan_job/company/home/widget/createjob_findjob.dart';
import 'package:hindustan_job/company/home/widget/home_filter_options.dart';
import 'package:hindustan_job/company/resume_result_box.dart';
import 'package:hindustan_job/company/resume_results.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/auth/company_services.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/landing_page_widget/chat_contacts_widget.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:hindustan_job/widget/landing_page_widget/resume_builder.dart';
import 'package:hindustan_job/widget/register_page_widget/text_field.dart';
import 'package:hindustan_job/widget/subscription_alert_box.dart';
import 'package:vrouter/vrouter.dart';

import '../../../widget/search_widget.dart/candidate_search_widget.dart';
import '../candidate_profile.dart';

const TWO_PI = 3.14 * 2;

class CompanyHomePage extends ConsumerStatefulWidget {
  Function? onControllerChange;
  CompanyHomePage({Key? key, this.onControllerChange}) : super(key: key);

  @override
  _CompanyHomePageState createState() => _CompanyHomePageState();
}

class _CompanyHomePageState extends ConsumerState<CompanyHomePage> {
  int unreadMessage = 0;
  int pendingRequest = 0;
  int acceptedOffers = 0;
  int totalActiveJobs = 0;
  CompanyDashboardModel companyDashboardData = CompanyDashboardModel(
    graphData: [],
    receivedPendingRequest: 0,
    totalActiveJob: 0,
    unreadMessageCount: 0,
    newAcceptedOffer: 0,
  );
  List<GraphData>? graphData = [];

  final List<HiredApplication> data = [];
  @override
  void initState() {
    super.initState();
    getDashboardData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(companyProfile).checkSubscription();
      ref.read(jobData).fetchCompanyHomeData(context);
    });
  }

  getDashboardData() async {
    companyDashboardData = await getCompanyDashBoardData();
    if (companyDashboardData.totalActiveJob != null) {
      totalActiveJobs = companyDashboardData.totalActiveJob!;
      unreadMessage = companyDashboardData.unreadMessageCount!;
      acceptedOffers = companyDashboardData.newAcceptedOffer!;
      pendingRequest = companyDashboardData.receivedPendingRequest!;
      graphData = companyDashboardData.graphData;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    final size = 200.00;
    final styles = Mytheme.lightTheme(context).textTheme;
    return Consumer(
      builder: (context, watch, child) {
        bool isUserSubscribed = ref.watch(companyProfile).isUserSubscribed;
        bool isLoading = ref.watch(companyProfile).isLoading;
        int? remainingDays = ref.watch(companyProfile).remainingDays;
        String? planName = ref.watch(companyProfile).planName;
        String? startDataOfSubscription =
            ref.watch(companyProfile).startDateOfSubscription;
        return Scaffold(
          backgroundColor: MyAppColor.backgroundColor,
          body: ListView(
            children: [
              if (!isUserSubscribed && !isLoading)
                SizedBox(
                    child: SubscriptionAlertBox(
                        flag: "Company", isFromConnectedRoutes: false)),
              Padding(
                padding: Responsive.isDesktop(context)
                    ? EdgeInsets.symmetric(horizontal: 100.0)
                    : EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: Sizeconfig.screenHeight! / 40,
                    ),
                    if (!Responsive.isDesktop(context))
                      CreateFindJOb(
                        isUserSubscribed: isUserSubscribed,
                      ),
                    SizedBox(height: 15),
                    if (!Responsive.isDesktop(context))
                      CandidateSearch(
                        isUserSubscribed: isUserSubscribed,
                      ),
                    if (Responsive.isDesktop(context))
                      HomeFilterOptions(
                        flag: 'post',
                        isUserSubscribed: isUserSubscribed,
                      ),
                    SizedBox(
                      height: 40,
                    ),
                    if (Responsive.isDesktop(context))
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                if (Responsive.isDesktop(context)) {
                                  webChatContactBox(context, chatingMessage);
                                } else {
                                  await chatContactBox(context, chatingMessage);
                                }
                                ref
                                    .read(chatingMessage)
                                    .getMesssageCount(context);
                              },
                              child: _message(styles,
                                  image: 'assets/company_home11.png',
                                  number: '$unreadMessage',
                                  title: 'Unread  ',
                                  sub: 'Messages'),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                context.vRouter.to(
                                    "/home-company/search-candidates",
                                    queryParameters: {
                                      "application_status": "PENDING",
                                    });
                              },
                              child: _message(styles,
                                  image: 'assets/company_home2.png',
                                  number: '$pendingRequest',
                                  title: 'Pending  ',
                                  sub: 'Applications'),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                context.vRouter.to(
                                    "/home-company/search-candidates",
                                    queryParameters: {
                                      "application_status": "SEND_OFFER",
                                    });
                              },
                              child: _message(styles,
                                  image: 'assets/company_home1.png',
                                  number: '$acceptedOffers',
                                  title: 'New Accepted ',
                                  sub: 'Offers'),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                widget.onControllerChange!();
                              },
                              child: _message(styles,
                                  image: 'assets/company_home2.png',
                                  number: '$totalActiveJobs',
                                  title: 'Total Active ',
                                  sub: 'Jobs'),
                            ),
                          ),
                        ],
                      ),
                    if (!Responsive.isDesktop(context))
                      Row(
                        children: [
                          Expanded(
                            child: _home(styles, context),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SearchCompany(
                                              isUserSubscribed:
                                                  isUserSubscribed,
                                              data: {
                                                "application_status": "PENDING"
                                              },
                                            )));
                              },
                              child: _message(styles,
                                  image: 'assets/company_home2.png',
                                  number: '$pendingRequest',
                                  title: 'Pending',
                                  sub: 'Applications'),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: Sizeconfig.screenHeight! / 70,
                    ),
                    if (!Responsive.isDesktop(context))
                      Row(
                        children: [
                          Expanded(
                              child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SearchCompany(
                                            isUserSubscribed: isUserSubscribed,
                                            data: {
                                              "application_status": "SEND_OFFER"
                                            },
                                          )));
                            },
                            child: _offers(styles),
                          )),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: InkWell(
                            onTap: () {
                              widget.onControllerChange!();
                            },
                            child: _totalActive(styles),
                          )),
                        ],
                      ),
                    SizedBox(
                      height: Sizeconfig.screenHeight! / 25,
                    ),
                    if (Responsive.isDesktop(context))
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 3,
                            child: _chart(styles),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            flex: 1,
                            child: __subscription(context, styles, size,
                                daysLeft: remainingDays,
                                planName: planName,
                                startDate: startDataOfSubscription),
                          ),
                        ],
                      ),
                    if (!Responsive.isDesktop(context)) _chart(styles),
                    SizedBox(
                      height: Sizeconfig.screenHeight! / 25,
                    ),
                    if (!Responsive.isDesktop(context) && isUserSubscribed)
                      __subscription(context, styles, size,
                          daysLeft: remainingDays,
                          startDate: startDataOfSubscription,
                          planName: planName),
                    SizedBox(
                      height: 3,
                    ),
                    SizedBox(
                      height: Sizeconfig.screenHeight! / 20,
                    ),
                    if (!Responsive.isDesktop(context)) _mymessage(styles),
                    if (Responsive.isDesktop(context))
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(child: _mymessage(styles)),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Consumer(
                                  builder: (context, ref, child) {
                                    List jobAcceptedOffersApplicants = ref
                                        .watch(jobData)
                                        .jobAcceptedOffersApplicants;
                                    return jobAcceptedOffersApplicants
                                            .isNotEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: _applicationApplied(
                                                styles,
                                                'APPLICANTS ACCEPTED JOB OFFERS',
                                                isUserSubscribed,
                                                applicantsList:
                                                    jobAcceptedOffersApplicants),
                                          )
                                        : SizedBox();
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Consumer(
                                  builder: (context, ref, child) {
                                    List jobAppliedApplicants =
                                        ref.watch(jobData).jobAppliedApplicants;
                                    return jobAppliedApplicants.isNotEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: _applicationApplied(
                                                styles,
                                                'APPLICANTS APPLIED',
                                                isUserSubscribed,
                                                applicantsList:
                                                    jobAppliedApplicants),
                                          )
                                        : SizedBox();
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Consumer(
                                  builder: (context, ref, child) {
                                    List jobShortlistedApplicants = ref
                                        .watch(jobData)
                                        .jobShortlistedApplicants;
                                    return jobShortlistedApplicants.isNotEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: _applicationApplied(
                                                styles,
                                                'SHORT-LISTED CANDIDATES',
                                                isUserSubscribed,
                                                applicantsList:
                                                    jobShortlistedApplicants),
                                          )
                                        : SizedBox();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    if (!Responsive.isDesktop(context))
                      Consumer(
                        builder: (context, ref, child) {
                          List jobAppliedApplicants =
                              ref.watch(jobData).jobAppliedApplicants;
                          return jobAppliedApplicants.isNotEmpty
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: _applicationApplied(styles,
                                      'APPLICANTS APPLIED', isUserSubscribed,
                                      applicantsList: jobAppliedApplicants),
                                )
                              : SizedBox();
                        },
                      ),
                    if (!Responsive.isDesktop(context))
                      Consumer(
                        builder: (context, ref, child) {
                          List jobShortlistedApplicants =
                              ref.watch(jobData).jobShortlistedApplicants;
                          return jobShortlistedApplicants.isNotEmpty
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: _applicationApplied(
                                      styles,
                                      'SHORT-LISTED CANDIDATES',
                                      isUserSubscribed,
                                      applicantsList: jobShortlistedApplicants),
                                )
                              : SizedBox();
                        },
                      ),
                    if (!Responsive.isDesktop(context))
                      Consumer(
                        builder: (context, ref, child) {
                          List jobAcceptedOffersApplicants =
                              ref.watch(jobData).jobAcceptedOffersApplicants;
                          return jobAcceptedOffersApplicants.isNotEmpty
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: _applicationApplied(
                                      styles,
                                      'APPLICANTS ACCEPTED JOB OFFERS',
                                      isUserSubscribed,
                                      applicantsList:
                                          jobAcceptedOffersApplicants),
                                )
                              : SizedBox();
                        },
                      ),
                  ],
                ),
              ),
              Footer(),
            ],
          ),
        );
      },
    );
  }

  Widget _subscribe(TextTheme styles, {startDate}) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 15, vertical: !Responsive.isDesktop(context) ? 10 : 20),
      color: MyAppColor.greynormal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Subscribed on:',
            style:
                !Responsive.isDesktop(context) ? blackDarkM14() : blackdarkM12,
          ),
          Text(
            '${startDate ?? ''}',
            style:
                !Responsive.isDesktop(context) ? blackDarkM14() : blackdarkM12,
          ),
        ],
      ),
    );
  }

  Container _activesubscription(TextTheme styles, {planName}) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 15, vertical: !Responsive.isDesktop(context) ? 10 : 20),
      color: MyAppColor.greynormal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Active Subscription Plan:',
              style: !Responsive.isDesktop(context)
                  ? blackDarkM14()
                  : blackdarkM12,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              '$planName',
              style: !Responsive.isDesktop(context)
                  ? blackDarkM14()
                  : blackdarkM12,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Column __subscription(BuildContext context, TextTheme styles, double size,
      {daysLeft, startDate, planName}) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SubscriptionPlans(isLimitPlans: false)));
          },
          child: Container(
            width: double.infinity,
            padding: !Responsive.isDesktop(context)
                ? EdgeInsets.all(20)
                : EdgeInsets.symmetric(horizontal: 30, vertical: 37),
            color: MyAppColor.darkBlue,
            child: Column(
              children: [
                Image.asset('assets/company_homel.png'),
                Text(
                  'YOU HAVE A SUBSCRIPTION',
                  style: whiteR12(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Container(
                    height: 240,
                    width: 240,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: Image.asset(
                        'assets/company_circle.png',
                      ).image),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(

                            // shape: BoxShape.circle,

                            ),
                        height: 200,
                        width: 200,
                        child: Stack(
                          children: [
                            ShaderMask(
                              shaderCallback: (rect) {
                                return SweepGradient(
                                  colors: [
                                    MyAppColor.orangelight,
                                    MyAppColor.white
                                  ],
                                  startAngle: 0.0,
                                  center: Alignment.center,
                                  endAngle: TWO_PI,
                                ).createShader(rect);
                              },
                              child: Container(
                                height: size,
                                width: size,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: MyAppColor.white,
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: size - 15,
                                width: size - 15,
                                decoration: BoxDecoration(
                                    color: MyAppColor.darkBlue,
                                    shape: BoxShape.circle),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${daysLeft ?? 0}",
                                      style: whiteSb18(),
                                    ),
                                    Text(
                                      'Days left',
                                      style: whiteR12(),
                                    ),
                                    Text(
                                      'in Subscription',
                                      style: whiteR12(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  'You can post Unlimited Jobs  ',
                  style: whiteR12(),
                ),
                Text(
                  '& Get Unlimited Candidates too. ',
                  style: whiteR12(),
                ),
              ],
            ),
          ),
        ),
        _activesubscription(styles, planName: planName),
        SizedBox(
          height: 4,
        ),
        _subscribe(styles, startDate: startDate),
      ],
    );
  }

  Widget _chart(TextTheme styles) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(30),
          color: MyAppColor.greynormal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HIRED APPLICANTS HISTORY',
                style: blackDarkR14(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // IconButton(
                    //   onPressed: () {},
                    //   icon: Icon(Icons.expand_more),
                    // ),
                    Text(
                      '2020',
                      style: blackdarkM12,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    // IconButton(
                    //   onPressed: () {},
                    //   icon: Icon(Icons.expand_more),
                    // ),
                    Text(
                      'Yearly',
                      style: blackdarkM12,
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  height: 400,
                  color: MyAppColor.greynormal,
                  child: Chart(graphData: graphData!),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: !Responsive.isDesktop(context)
              ? EdgeInsets.all(20)
              : EdgeInsets.all(5),
          // height: Sizeconfig.screenHeight! / 30,
          color: MyAppColor.grayplane,
          child: !Responsive.isDesktop(context)
              ? Column(
                  children: [
                    _axis(),
                    _month(),
                    SizedBox(
                      height: 10,
                    ),
                    _hired(),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: _axis(),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        _month(),
                      ],
                    ),
                    Row(
                      children: [
                        _hired(),
                      ],
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  _hired() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        children: [
          Container(
            height: 20,
            width: 30,
            color: MyAppColor.orangelight,
          ),
          SizedBox(
            width: 6,
          ),
          Text(
            'Number of Applicants got Hired',
            style: blackdarkM12,
          ),
        ],
      ),
    );
  }

  _month() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            'Y - Axis: ',
            style: companyNameM9(),
          ),
          Text(
            'Months',
            style: blackdarkM12,
          ),
        ],
      ),
    );
  }

  _axis() {
    return Row(
      children: [
        Text(
          'X - Axis: ',
          style: companyNameM9(),
        ),
        Text(
          'Number of Applicants',
          style: blackdarkM12,
        ),
      ],
    );
  }

  Widget _totalActive(TextTheme styles) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
              padding: EdgeInsets.all(5),
              color: MyAppColor.applecolor,
              height: Sizeconfig.screenHeight! / 6,
              child: Icon(Icons.card_travel,
                  size: 20, color: MyAppColor.backgroundColor)),
        ),
        Expanded(
          flex: 7,
          child: Container(
            padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 00),
            height: Sizeconfig.screenHeight! / 6,
            color: MyAppColor.greylight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$totalActiveJobs',
                  style: whiteSb16(),
                ),
                Text(
                  'Total Active ',
                  style:
                      !Responsive.isDesktop(context) ? whiteM14() : whiteM12(),
                ),
                Text(
                  'Jobs',
                  style:
                      !Responsive.isDesktop(context) ? whiteM14() : whiteM12(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.arrow_forward,
                      color: MyAppColor.white,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _offers(TextTheme styles) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            padding: EdgeInsets.all(10),
            color: MyAppColor.applecolor,
            height: Sizeconfig.screenHeight! / 6,
            child: Image.asset(
              'assets/company_home1.png',
              height: 00,
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: Container(
            padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 00),
            height: Sizeconfig.screenHeight! / 6,
            color: MyAppColor.greylight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$acceptedOffers',
                  style: whiteSb16(),
                ),
                Text(
                  'New Accepted ',
                  style:
                      !Responsive.isDesktop(context) ? whiteM14() : whiteM12(),
                ),
                Text(
                  'Offers',
                  style:
                      !Responsive.isDesktop(context) ? whiteM14() : whiteM12(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.arrow_forward,
                      color: MyAppColor.white,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _message(TextTheme styles,
      {String? image, String? number, String? title, String? sub}) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            padding: EdgeInsets.all(22),
            color: MyAppColor.applecolor,
            height: !Responsive.isDesktop(context)
                ? Sizeconfig.screenHeight! / 6
                : Sizeconfig.screenHeight! / 9,
            child: Image.asset(
              // image!,
              'assets/company_home2.png',
              height: 15,
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: Container(
            padding: EdgeInsets.only(top: 18, left: 10, right: 10, bottom: 00),
            height: !Responsive.isDesktop(context)
                ? Sizeconfig.screenHeight! / 6
                : Sizeconfig.screenHeight! / 9,
            color: MyAppColor.greylight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!Responsive.isDesktop(context))
                  Text(
                    number!,

                    // '84',
                    style: whiteSb16(),
                  ),
                if (Responsive.isDesktop(context))
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            number!,
                            style: whiteSb16(),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: icons(),
                          ),
                        ],
                      ),
                      // icons(),
                    ],
                  ),
                Row(
                  children: [
                    pending(
                      title!,
                    ),
                    // application(sub!),
                  ],
                ),
                // if (!Responsive.isDesktop(context)) pending(title),
                if (!Responsive.isDesktop(context)) application(sub),
                if (!Responsive.isDesktop(context))
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      icons(),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget application(sub) {
    return Text(
      sub,
      style: !Responsive.isDesktop(context) ? whiteM14() : whiteM10(),
    );
  }

  Widget pending(title) {
    return Text(
      title!,

      // 'Pending Received ',
      style: !Responsive.isDesktop(context) ? whiteM14() : whiteM8(),
    );
  }

  Widget icons() {
    return Icon(
      Icons.arrow_forward,
      color: MyAppColor.white,
      size: 16,
    );
  }

  Widget _home(TextTheme styles, BuildContext context) {
    return Row(children: [
      Expanded(
        flex: 2,
        child: Container(
          padding: EdgeInsets.all(10),
          color: MyAppColor.applecolor,
          height: !Responsive.isDesktop(context)
              ? Sizeconfig.screenHeight! / 6
              : Sizeconfig.screenHeight! / 8,
          child: Image.asset(
            'assets/company_home11.png',
            height: 00,
          ),
        ),
      ),
      Expanded(
        flex: 7,
        child: Container(
          padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 00),
          height: !Responsive.isDesktop(context)
              ? Sizeconfig.screenHeight! / 6
              : Sizeconfig.screenHeight! / 8,
          color: MyAppColor.greylight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!Responsive.isDesktop(context))
                Text(
                  '$unreadMessage',
                  style: whiteSb16(),
                ),
              if (Responsive.isDesktop(context))
                Row(
                  children: [
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '05',
                          style: whiteSb16(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Unread ',
                                  style: !Responsive.isDesktop(context)
                                      ? whiteM14()
                                      : whiteM12(),
                                ),
                                Text(
                                  'Messages',
                                  style: !Responsive.isDesktop(context)
                                      ? whiteM14()
                                      : whiteM12(),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Resume_builder()));
                                  },
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: MyAppColor.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              if (!Responsive.isDesktop(context))
                Text(
                  'Unread ',
                  style:
                      !Responsive.isDesktop(context) ? whiteM14() : whiteM12(),
                ),
              if (!Responsive.isDesktop(context))
                Text(
                  'Messages',
                  style:
                      !Responsive.isDesktop(context) ? whiteM14() : whiteM12(),
                ),
              if (!Responsive.isDesktop(context))
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await chatContactBox(context, chatingMessage);
                          ref.read(chatingMessage).getMesssageCount(context);
                        },
                        child: Icon(
                          Icons.arrow_forward,
                          color: MyAppColor.white,
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    ]);
  }

  Container _applicationApplied(TextTheme styles, String text, isUserSubscribed,
      {required List applicantsList}) {
    return Container(
      // width:
      //     !Responsive.isDesktop(context) ? null : Sizeconfig.screenWidth! / 2.3,
      height: !Responsive.isDesktop(context) ? null : 300,
      padding: EdgeInsets.only(top: 15, bottom: 25, left: 20, right: 20),
      color: MyAppColor.grayplane,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(text, style: blackDarkR14()),
          ),
          if (Responsive.isDesktop(context))
            Table(
              border: TableBorder.all(color: MyAppColor.greynormal, width: 1.0),
              children: [
                TableRow(children: [
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      'S.No',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      'APPLICANTS NAME',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      'DATE APPLIED ON',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      'ACTION',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ]),
                for (var i = 0;
                    i < (applicantsList.length > 2 ? 3 : applicantsList.length);
                    i++)
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text('${i + 1}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text('${applicantsList[i].name}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                          '${formatDate(applicantsList[i]!.userAppliedJobs[0].updatedAt.toString())}'),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CandidateProfileView(
                                      applicants: applicantsList[i],
                                      isUserDataFlag: true,
                                      job: applicantsList[i]
                                          .userAppliedJobs[0]
                                          .jobPost,
                                    )));
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 5),
                        color: MyAppColor.lightNormalGray,
                        padding:
                            EdgeInsets.symmetric(horizontal: 26, vertical: 10),
                        child: Text(
                          'ACTION',
                          style: blackdarkM10,
                        ),
                      ),
                    ),
                  ]),
              ],
            ),
          if (!Responsive.isDesktop(context))
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: List.generate(
                applicantsList.length > 4 ? 4 : applicantsList.length,
                (index) => Container(
                  padding: EdgeInsets.all(15),
                  color: MyAppColor.grayplane,
                  width: MediaQuery.of(context).size.width - 40,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('#0${index + 1}',
                              style: styles.headline1!.copyWith(
                                fontSize: 12,
                              )),
                          Row(
                            children: [
                              if (applicantsList[index]!
                                  .userAppliedJobs
                                  .isNotEmpty)
                                Text(formatDate(applicantsList[index]!
                                    .userAppliedJobs[0]
                                    .updatedAt
                                    .toString())),
                              Icon(Icons.card_travel)
                            ],
                          ),
                        ],
                      ),
                      Text('${applicantsList[index]!.name}',
                          style: styles.headline1!.copyWith(
                              fontSize: 20, fontWeight: FontWeight.w800)),
                      Text('Experience: 3+ Years',
                          style: styles.headline1!.copyWith(
                            fontSize: 12,
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(15),
                          color: MyAppColor.lightNormalGray,
                          // height: Sizeconfig.screenHeight! / 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Resume Submitted'),
                              Text('Yes'),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            child: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CandidateProfileView(
                                                applicants:
                                                    applicantsList[index],
                                                isUserDataFlag: true,
                                                job: applicantsList[index]
                                                    .userAppliedJobs[0]
                                                    .jobPost,
                                              )));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('VIEW APPLICATION',
                                        style: styles.headline1!.copyWith(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600)),
                                    Icon(
                                      Icons.arrow_forward,
                                      size: 20,
                                      color: MyAppColor.blackdark,
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )),
            ),
          SizedBox(
            height: Sizeconfig.screenHeight! / 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchCompany(
                                  isUserSubscribed: isUserSubscribed,
                                  data: {},
                                )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 7),
                    child: Text(
                      'VIEW ALL',
                      style: blackdarkM12,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(color: MyAppColor.blackdark)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _mymessage(TextTheme styles) {
    return Consumer(builder: (context, ref, child) {
      List<ChatContact> chatContact = ref.watch(chatingMessage).contacts;
      return chatContact.isEmpty
          ? SizedBox()
          : Container(
              height: !Responsive.isDesktop(context) ? null : 300,
              width: !Responsive.isDesktop(context)
                  ? null
                  : Sizeconfig.screenWidth! / 2.5,
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 28, bottom: 20),
              color: MyAppColor.grayplane,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      'MY MESSAGES',
                      style: !Responsive.isDesktop(context)
                          ? blackDarkR16
                          : blackDarkR14(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (Responsive.isDesktop(context) && chatContact.isNotEmpty)
                    Column(
                      children: [
                        Row(
                          children: [
                            _myMessageContainer(context, styles,
                                user: findOppositeUser(chatContact.first),
                                chatContact: chatContact.first),
                          ],
                        ),
                      ],
                    ),
                  if (!Responsive.isDesktop(context) && chatContact.isNotEmpty)
                    _myMessageContainer(context, styles,
                        user: findOppositeUser(chatContact.first),
                        chatContact: chatContact.first),
                  if (!Responsive.isDesktop(context) && chatContact.isNotEmpty)
                    _sureConsiderContainer(context, styles,
                        user: findOppositeUser(chatContact.first)),
                  SizedBox(
                    height: Sizeconfig.screenHeight! / 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: OutlinedButton(
                          onPressed: () async {
                            await chatContactBox(context, chatingMessage);
                            ref.read(chatingMessage).getMesssageCount(context);
                          },
                          child: Padding(
                            padding: !Responsive.isDesktop(context)
                                ? EdgeInsets.all(0.0)
                                : EdgeInsets.symmetric(
                                    horizontal: 23.0, vertical: 8),
                            child: Text(
                              'VIEW ALL',
                              style: blackdarkM12,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(color: MyAppColor.blackdark)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
    });
  }

  Container _quickMethod(TextTheme styles) {
    return Container(
      width: !Responsive.isDesktop(context)
          ? Sizeconfig.screenWidth!
          : Sizeconfig.screenWidth! / 3.9,
      padding: !Responsive.isDesktop(context)
          ? EdgeInsets.symmetric(horizontal: 20, vertical: 15)
          : EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      color: MyAppColor.greynormal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('The quick, brown fox...',
              style:
                  !Responsive.isDesktop(context) ? blackdarkM12 : blackdarkM10),
          _buttonMessage(),
        ],
      ),
    );
  }

  _sureConsiderContainer(BuildContext context, styles, {user}) {
    return Container(
      width: !Responsive.isDesktop(context)
          ? Sizeconfig.screenWidth!
          : Sizeconfig.screenWidth! / 3.9,
      padding: !Responsive.isDesktop(context)
          ? EdgeInsets.symmetric(horizontal: 20, vertical: 15)
          : EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      color: MyAppColor.greynormal,
      // height: !Responsive.isDesktop(context)
      //     ? Sizeconfig.screenHeight! / 6.5
      //     : null,
      child: !Responsive.isDesktop(context)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                sureConsider(styles),
                _buttonMessage(user: user),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                sureConsider(styles),
                _buttonMessage(user: user),
              ],
            ),
    );
  }

  quickContainer(BuildContext context, styles) {
    return Container(
      width: !Responsive.isDesktop(context)
          ? Sizeconfig.screenWidth!
          : Sizeconfig.screenWidth! / 3.9,
      padding: !Responsive.isDesktop(context)
          ? EdgeInsets.symmetric(horizontal: 20, vertical: 15)
          : EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      color: MyAppColor.greynormal,
      height: !Responsive.isDesktop(context)
          ? Sizeconfig.screenHeight! / 6.5
          : null,
      child: !Responsive.isDesktop(context)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _quick(styles),
                _buttonMessage(),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _quick(styles),
                _buttonMessage(),
              ],
            ),
    );
  }

  _myMessageContainer(BuildContext context, styles, {user, chatContact}) {
    return Container(
      padding: !Responsive.isDesktop(context)
          ? EdgeInsets.all(15)
          : EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      color: MyAppColor.lightNormalGray,

      // height: Sizeconfig.screenHeight! / 8.5,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CircleAvatar(
          //   radius: 50,

          //   backgroundImage: AssetImage('assets/male.png'),
          // ),
          Padding(
            padding:
                EdgeInsets.only(top: !Responsive.isDesktop(context) ? 10 : 0),
            child: Container(
              height: !Responsive.isDesktop(context) ? 50 : 30,
              width: !Responsive.isDesktop(context) ? 50 : 30,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(currentUrl(user.image)),
                    fit: BoxFit.cover),
                color: MyAppColor.applecolor,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!Responsive.isDesktop(context))
                  Text('#01',
                      style: styles.headline1!.copyWith(
                        fontSize: 10.0,
                      )),
                Text('${user.name}',
                    style: !Responsive.isDesktop(context)
                        ? blackDarkM16()
                        : blackdarkM10),
                if (chatContact.chats.isNotEmpty)
                  Text(
                    "${formatDate(chatContact.chats![0].updatedAt)} | ${formatTime(chatContact.chats![0].updatedAt)}",
                    style: !Responsive.isDesktop(context)
                        ? greylightBoldGalano10
                        : greylightBoldGalano6,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row _buttonMessage({user}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: !Responsive.isDesktop(context)
              ? Sizeconfig.screenWidth! / 2
              : null,
          child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatScreen(
                              oppositeUser: user,
                            )));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.message,
                    color: MyAppColor.white,
                  ),
                  if (!Responsive.isDesktop(context)) Text('SEND A MESSAGE')
                ],
              )),
        ),
      ],
    );
  }

  Row sureConsider(TextTheme styles) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Sure! Consider it done.',
          style: blackdarkM12.copyWith(color: Colors.green),
        ),
      ],
    );
  }

  Row _quick(TextTheme styles) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('The quick, brown fox jumps over a lazy dog. DJs flo...',
            style: styles.headline1!.copyWith(
                fontSize: Responsive.isDesktop(context) ? 15 : 12,
                color: Colors.green,
                fontStyle: FontStyle.italic)),
      ],
    );
  }
}
