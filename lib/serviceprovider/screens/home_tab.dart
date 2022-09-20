// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, unused_import, must_be_immutable, unused_local_variable

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/model/serviceProviderModal/mybranch.dart';
import 'package:hindustan_job/candidate/model/serviceProviderModal/service_provider_dashboard.dart';
import 'package:hindustan_job/candidate/model/services_model.dart';
import 'package:hindustan_job/candidate/model/subscription_list.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/drawer/subscriptions_plan.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/company/home/pages/barchats.dart';
import 'package:hindustan_job/company/home/pages/servieproviderchart.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/serviceprovider/screens/HomeServiceProviderTabs/ServicesRequests/view_service_request_details_screen.dart';
import 'package:hindustan_job/serviceprovider/screens/HomeServiceProviderTabs/my_services_tab.dart';
import 'package:hindustan_job/serviceprovider/widget/radialPainter.dart';
import 'package:hindustan_job/services/api_service_serviceProvider/service_provider.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/services_constant/api_string_constant.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:hindustan_job/widget/subscription_alert_box.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:vrouter/vrouter.dart';
import '../../candidate/pages/job_seeker_page/home/homeappbar.dart';
import '../../utility/function_utility.dart';
import 'HomeServiceProviderTabs/ServicesRequests/services_requests_screen.dart';
import 'HomeServiceProviderTabs/complete_your_profile_screen.dart';
import 'HomeServiceProviderTabs/my_profile.dart';

class HomeServiceProviderTab extends ConsumerStatefulWidget {
  final flag;
  int? index;
  HomeServiceProviderTab({Key? key, this.flag, this.index}) : super(key: key);
  @override
  _HomeServiceProviderTabState createState() => _HomeServiceProviderTabState();
}

class _HomeServiceProviderTabState extends ConsumerState<HomeServiceProviderTab>
    with TickerProviderStateMixin {
  int branchCount = 0;

  int providerServiceCount = 0;

  List<RequestData> requestd = [];

  List<GrapData>? grapData = [];

  ServiceProviderDashboard dshboard = ServiceProviderDashboard(
    serviceProviderServiceCount: 0,
    serviceProviderBranchCount: 0,
    grapData: [],
  );

  List<_SalesData> data = [
    _SalesData('Jan', 35),
    _SalesData('Feb', 28),
    _SalesData('Mar', 34),
    _SalesData('Apr', 32),
    _SalesData('May', 40)
  ];
  int selectedTabIndex = 0;
  TabController? tabController;
  List<int> arrayIndex = [0];
  @override
  void initState() {
    serviceDashBoard();
    fetchData();
    if (widget.index != null) {
      tabController =
          TabController(initialIndex: widget.index!, length: 4, vsync: this);
    } else {
      tabController = TabController(length: 4, vsync: this);
    }
    tabListner();
    BackButtonInterceptor.add(myInterceptor);
    ref.read(serviceProviderData).dashboard();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      ref.read(serviceProviderData).checkSubscription();
    });
    super.initState();
  }

  tabListner() {
    tabController?.addListener(() {
      setState(() {
        selectedTabIndex = tabController!.index;
      });
      if (arrayIndex.isEmpty) {
        arrayIndex.add(tabController?.index ?? 0);
      } else if (arrayIndex.last != tabController?.index) {
        arrayIndex.add(tabController?.index ?? 0);
      }
      if (tabController?.index == 0) {}
    });
  }

  serviceDashBoard() async {
    dshboard = await ref.read(serviceProviderData).dashboard();
    branchCount = dshboard.serviceProviderBranchCount ?? 0;
    providerServiceCount = dshboard.serviceProviderServiceCount!;
  }

  fetchData() async {
    await ref
        .read(serviceProviderData)
        .getdataserviceRequest(serviceStatus: 'PENDING');

    await ref
        .read(serviceProviderData)
        .getdataserviceRequest(serviceStatus: 'ACCEPTED');
  }

  int i = 0;
  moveTabBar(value) async {
    i = value == 3 ? 1 : value;
    setState(() {});
    Future.delayed(Duration(milliseconds: 30), () {
      tabController!.animateTo(value == 0 ? 1 : value);
      setState(() {});
    });
  }

  resetIndex() {
    i = 0;
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
    return Consumer(builder: (context, ref, child) {
      bool isUserSubscribed =
          ref.watch(serviceProviderData).isCandidateSubscribed;
      return DefaultTabController(
        length: 4,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: MyAppColor.backgroundColor,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(40),
              child: Container(color: MyAppColor.greynormal, child: tabs()),
            ),
            body: TabBarView(
              controller: tabController,
              children: [
                homeTab(),
                ServiceRequestsScreen(index: i, resetIndex: resetIndex),
                MyServicesTab(resetIndex: resetIndex),
                MyProfileScreen(index: i, resetIndex: resetIndex),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget homeTab() {
    return Consumer(builder: (context, ref, child) {
      bool isCandidateSubscribed =
          ref.watch(serviceProviderData).isCandidateSubscribed;
      bool isLoading = ref.watch(serviceProviderData).isLoading;

      TextTheme styles;
      return Container(
        color: MyAppColor.backgroundColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (!isCandidateSubscribed && !isLoading)
                SubscriptionAlertBox(isFromConnectedRoutes: true),
              Padding(
                padding: EdgeInsets.only(
                    right: Responsive.isMobile(context) ? 10 : 40.0,
                    left: Responsive.isMobile(context) ? 10 : 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (userData!.image == null) SizedBox(height: 30),
                    if (userData!.image == null) completeYourProfileDetails(),
                    SizedBox(height: Responsive.isDesktop(context) ? 20.0 : 25),
                    cardsRow(),
                    if (!Responsive.isDesktop(context))
                      const SizedBox(height: 10),
                    if (!Responsive.isDesktop(context)) cardsRow2(),
                    SizedBox(height: Responsive.isDesktop(context) ? 20.0 : 10),
                    Responsive.isDesktop(context)
                        ? Row(
                            children: [
                              graphPart(),
                              subscriptionPart(),
                            ],
                          )
                        : Column(children: [
                            SizedBox(height: 20),
                            _chart(),
                            const SizedBox(
                              height: 30,
                            ),
                            subscriptionPart(),
                          ]),
                    SizedBox(
                      height: Responsive.isDesktop(context) ? 20 : 20,
                    ),
                    Responsive.isDesktop(context)
                        ? Row(
                            children: [
                              pendingServiceRequestWidget(),
                              activeUpcomingServiceRequestWidget()
                            ],
                          )
                        : Column(
                            children: [
                              pendingServiceRequestWidget(),
                              SizedBox(height: 30),
                              activeUpcomingServiceRequestWidget()
                            ],
                          ),
                    SizedBox(
                      height: Responsive.isDesktop(context) ? 20 : 60,
                    ),
                  ],
                ),
              ),
              Footer()
            ],
          ),
        ),
      );
    });
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

  tabTextWithIcon({iconUrl, text}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [
        SizedBox(
          height: Responsive.isMobile(context) ? 25 : 20,
          child: CircleAvatar(
              backgroundColor: MyAppColor.greylight,
              child: ImageIcon(AssetImage(iconUrl),
                  size: 12, color: Colors.white)),
        ),
        SizedBox(
          width: Responsive.isDesktop(context) ? 10 : 0,
        ),
        Text("$text", style: blackDark12),
      ]),
    );
  }

  Widget tabs() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TabBar(
        controller: tabController,
        onTap: (value) {
          // if (kIsWeb) {
          //   context.vRouter
          //       .to("/hindustaan-jobs/HSP/${returnIndexHSPString(value)}");
          // }
        },
        isScrollable: true,
        labelColor: Colors.black,
        indicatorWeight: 2,
        indicatorColor: MyAppColor.orangelight,
        tabs: [
          tabTextWithIcon(iconUrl: "assets/home_company.png", text: 'Home'),
          tabTextWithIcon(
            iconUrl: "assets/company_home2.png",
            text: 'Services Req.',
          ),
          tabTextWithIcon(iconUrl: "assets/cut_staff.png", text: 'My Service'),
          tabTextWithIcon(iconUrl: "assets/cut_staff.png", text: 'My profile')
        ],
      ),
    );
  }

  activeUpcomingServiceRequestWidget() {
    return Consumer(builder: (context, ref, child) {
      List<Services> upcoming = ref.watch(serviceProviderData).upcoming;

      return Responsive.isDesktop(context)
          ? Expanded(
              child: Container(
                  height: Responsive.isDesktop(context) ? 620 : 0,
                  color: MyAppColor.lightGrey,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ACTIVE & UPCOMING SERVICE REQUESTS',
                          style: blackRegular16,
                        ),
                        SizedBox(
                          height: Responsive.isDesktop(context) ? 20 : 0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  alignment: Alignment.center,
                                  height:
                                      Responsive.isDesktop(context) ? 37 : 0,
                                  width: Responsive.isDesktop(context) ? 55 : 0,
                                  color: MyAppColor.grayplane,
                                  child: Text(
                                    'S. NO',
                                    style: black12,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  height:
                                      Responsive.isDesktop(context) ? 37 : 0,
                                  width: Responsive.isDesktop(context) ? 55 : 0,
                                  color: MyAppColor.grayplane,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Text(
                                      'CLIENT',
                                      style: black12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  height:
                                      Responsive.isDesktop(context) ? 37 : 0,
                                  width: Responsive.isDesktop(context) ? 55 : 0,
                                  color: MyAppColor.grayplane,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Text(
                                      'SERVICE REQUESTED',
                                      style: black12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                alignment: Alignment.center,
                                height: Responsive.isDesktop(context) ? 37 : 0,
                                width: Responsive.isDesktop(context) ? 65 : 0,
                                color: MyAppColor.grayplane,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'ACTION',
                                    style: black12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Responsive.isDesktop(context) ? 0 : 0,
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: upcoming.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: Responsive.isDesktop(context)
                                              ? 74
                                              : 0,
                                          width: Responsive.isDesktop(context)
                                              ? 55
                                              : 0,
                                          color: MyAppColor.grayplane,
                                          child: Text(
                                            '${index + 1}',
                                            style: black12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: Responsive.isDesktop(context)
                                              ? 74
                                              : 0,
                                          width: Responsive.isDesktop(context)
                                              ? 55
                                              : 0,
                                          color: MyAppColor.grayplane,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${upcoming[index].user!.name}',
                                                style: black14,
                                              ),
                                              Wrap(
                                                children: [
                                                  Image.asset(
                                                      'assets/location_icon.png'),
                                                  Text(
                                                    '${locationShow(city: upcoming[index].user!.city, state: upcoming[index].user!.state)}',
                                                    style: black12,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: Responsive.isDesktop(context)
                                              ? 74
                                              : 0,
                                          width: Responsive.isDesktop(context)
                                              ? 55
                                              : 0,
                                          color: MyAppColor.grayplane,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              '${upcoming[index].serviceName}',
                                              overflow: TextOverflow.fade,
                                              style: black14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: Responsive.isDesktop(context)
                                            ? 74
                                            : 0,
                                        width: Responsive.isDesktop(context)
                                            ? 65
                                            : 0,
                                        color: MyAppColor.grayplane,
                                        child: Container(
                                          margin: const EdgeInsets.all(15.0),
                                          padding: const EdgeInsets.all(3.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)
                                                //                 <--- border radius here
                                                ),
                                            border: Border.all(
                                                color: MyAppColor.black),
                                          ),
                                          child: Image.asset(
                                              'assets/forward_arrow.png'),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ),
                        SizedBox(
                          height: Responsive.isDesktop(context) ? 20 : 0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    primary: MyAppColor.greynormal,
                                    side: BorderSide(
                                        width: 1.0, color: MyAppColor.black)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12, top: 8, bottom: 8),
                                  child: Text(
                                    'VIEW ALL',
                                    style: black14,
                                  ),
                                )),
                          ],
                        )
                      ],
                    ),
                  )))
          : Container(
              child: Padding(
              padding: EdgeInsets.only(
                  right: Responsive.isDesktop(context) ? 16.0 : 4),
              child: Container(
                  height: Responsive.isDesktop(context)
                      ? 600
                      : MediaQuery.of(context).size.height - 300,
                  color: MyAppColor.lightGrey,
                  child: Padding(
                    padding: EdgeInsets.all(
                        Responsive.isDesktop(context) ? 30.0 : 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ACTIVE & UPCOMING SERVICE REQUESTS',
                          style: blackRegular16,
                        ),
                        SizedBox(
                          height: Responsive.isDesktop(context) ? 20 : 10,
                        ),
                        upcoming.isEmpty
                            ? Center(
                                child: Text('NO DATA'),
                              )
                            : Expanded(
                                ///height: 260,
                                // width: 400,
                                child: ListView.builder(
                                    itemCount: upcoming.length > 4
                                        ? 4
                                        : upcoming.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return upcoming.isEmpty
                                          ? Center(child: Text('No Data'))
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    70,
                                                color: MyAppColor.grayplane,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: Container(
                                                          height: Responsive
                                                                  .isDesktop(
                                                                      context)
                                                              ? 74
                                                              : 0,
                                                          width: Responsive
                                                                  .isDesktop(
                                                                      context)
                                                              ? 55
                                                              : 50,
                                                          child: Text(
                                                            (index + 1)
                                                                .toString(),
                                                            style:
                                                                greylightMediumGalano14,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        upcoming[index]
                                                            .serviceName
                                                            .toString(),
                                                        style: blackBold20,
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        upcoming[index]
                                                            .user!
                                                            .name
                                                            .toString(),
                                                        style: black16,
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Wrap(
                                                        children: [
                                                          Image.asset(
                                                              'assets/location_icon.png'),
                                                          Text(
                                                            '${upcoming[index].user!.state!.name.toString()} ${upcoming[index].user!.city!.name.toString()} ',
                                                            style: black14,
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ViewServiceRequestDetailsScreen(
                                                                      flag: upcoming[
                                                                              index]
                                                                          .serviceProviderStatus!,
                                                                      servicereques:
                                                                          upcoming[
                                                                              index],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              style: ElevatedButton.styleFrom(
                                                                  primary:
                                                                      MyAppColor
                                                                          .grayplane,
                                                                  elevation: 0,
                                                                  side: BorderSide(
                                                                      width:
                                                                          1.0,
                                                                      color: MyAppColor
                                                                          .black)),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    'VIEW REQUEST',
                                                                    style:
                                                                        blackRegular14,
                                                                  ),
                                                                  Icon(
                                                                    Icons
                                                                        .arrow_forward,
                                                                    color: MyAppColor
                                                                        .black,
                                                                  )
                                                                ],
                                                              )),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                    }),
                              ),
                        SizedBox(
                          height: Responsive.isDesktop(context) ? 20 : 0,
                        ),
                        if (!Responsive.isDesktop(context))
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (upcoming.isNotEmpty) Text('.  .  .  .  .'),
                              ],
                            ),
                          ),
                        SizedBox(
                          height: Responsive.isDesktop(context) ? 20 : 5,
                        ),
                        if (upcoming.isNotEmpty)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    primary: MyAppColor.greynormal,
                                    elevation: 0,
                                    side: BorderSide(
                                        width: 1.0, color: MyAppColor.black)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 28, right: 28, top: 10, bottom: 10),
                                  child: Text(
                                    'VIEW ALL',
                                    style: blackRegular14,
                                  ),
                                ),
                              )
                            ],
                          )
                      ],
                    ),
                  )),
            ));
    });
  }

  Widget row({text}) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          alignment: Alignment.center,
          height: Responsive.isDesktop(context) ? 74 : 0,
          width: Responsive.isDesktop(context) ? 55 : 0,
          color: MyAppColor.grayplane,
          child: Text(
            text,
            style: black12,
          ),
        ),
      ),
    );
  }

  pendingServiceRequestWidget() {
    return Consumer(builder: (context, ref, child) {
      List<Services> pendings = ref.watch(serviceProviderData).pending;
      return Responsive.isDesktop(context)
          ? Expanded(
              child: Padding(
              padding: EdgeInsets.only(
                  right: Responsive.isDesktop(context) ? 16.0 : 0),
              child: Container(
                  height: Responsive.isDesktop(context) ? 620 : 0,
                  color: MyAppColor.lightGrey,
                  child: Padding(
                    padding: EdgeInsets.all(
                        Responsive.isDesktop(context) ? 30.0 : 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PENDING SERVICE REQUESTS',
                          style: blackRegular16,
                        ),
                        SizedBox(
                          height: Responsive.isDesktop(context) ? 20 : 0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  alignment: Alignment.center,
                                  height:
                                      Responsive.isDesktop(context) ? 37 : 0,
                                  width: Responsive.isDesktop(context) ? 55 : 0,
                                  color: MyAppColor.grayplane,
                                  child: Text(
                                    'S. NO',
                                    style: black12,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  height:
                                      Responsive.isDesktop(context) ? 37 : 0,
                                  width: Responsive.isDesktop(context) ? 55 : 0,
                                  color: MyAppColor.grayplane,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Text(
                                      'CLIENT',
                                      style: black12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  height:
                                      Responsive.isDesktop(context) ? 37 : 0,
                                  width: Responsive.isDesktop(context) ? 55 : 0,
                                  color: MyAppColor.grayplane,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Text(
                                      'SERVICE REQUESTED',
                                      style: black12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Container(
                                alignment: Alignment.center,
                                height: Responsive.isDesktop(context) ? 37 : 0,
                                width: Responsive.isDesktop(context) ? 65 : 0,
                                color: MyAppColor.grayplane,
                                child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'ACTION',
                                      style: black12,
                                    )),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Responsive.isDesktop(context) ? 0 : 0,
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: pendings.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: Responsive.isDesktop(context)
                                              ? 74
                                              : 0,
                                          // width: Responsive.isDesktop(context)
                                          //     ? 55
                                          //     : 0,
                                          color: MyAppColor.grayplane,
                                          child: Text(
                                            '${index + 1}',
                                            style: black12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: Responsive.isDesktop(context)
                                              ? 74
                                              : 0,
                                          color: MyAppColor.grayplane,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${pendings[index].user!.name}',
                                                style: black14,
                                              ),
                                              Wrap(
                                                children: [
                                                  Image.asset(
                                                      'assets/location_icon.png'),
                                                  Text(
                                                    '${locationShow(city: pendings[index].user!.city, state: pendings[index].user!.state)}',
                                                    style: black12,
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: Responsive.isDesktop(context)
                                              ? 74
                                              : 0,
                                          width: Responsive.isDesktop(context)
                                              ? 55
                                              : 0,
                                          color: MyAppColor.grayplane,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              '${pendings[index].serviceName}',
                                              style: black14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: Responsive.isDesktop(context)
                                            ? 74
                                            : 0,
                                        width: Responsive.isDesktop(context)
                                            ? 65
                                            : 0,
                                        color: MyAppColor.grayplane,
                                        child: Container(
                                            margin: const EdgeInsets.all(15.0),
                                            padding: const EdgeInsets.all(3.0),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        5.0) //                 <--- border radius here
                                                    ),
                                                border: Border.all(
                                                    color: MyAppColor.black)),
                                            child: Image.asset(
                                                'assets/forward_arrow.png')),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ),
                        SizedBox(
                          height: Responsive.isDesktop(context) ? 20 : 0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    primary: MyAppColor.greynormal,
                                    side: BorderSide(
                                        width: 1.0, color: MyAppColor.black)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12, top: 8, bottom: 8),
                                  child: Text(
                                    'VIEW ALL',
                                    style: black14,
                                  ),
                                )),
                          ],
                        )
                      ],
                    ),
                  )),
            ))
          : Padding(
              padding: EdgeInsets.only(
                  right: Responsive.isDesktop(context) ? 16.0 : 4),
              child: Container(
                  height: Responsive.isDesktop(context)
                      ? 600
                      : MediaQuery.of(context).size.height - 300,
                  color: MyAppColor.lightGrey,
                  child: Padding(
                    padding: EdgeInsets.all(
                        Responsive.isDesktop(context) ? 30.0 : 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PENDING SERVICE REQUESTS',
                          style: blackRegular16,
                        ),
                        SizedBox(
                          height: Responsive.isDesktop(context) ? 20 : 10,
                        ),
                        Expanded(
                          ///height: 260,
                          // width: 400,
                          child: ListView.builder(
                              itemCount:
                                  pendings.length > 4 ? 4 : pendings.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return pendings.isEmpty
                                    ? Center(child: Text("No Data"))
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              70,
                                          color: MyAppColor.grayplane,
                                          child: Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: Container(
                                                    height:
                                                        Responsive.isDesktop(
                                                                context)
                                                            ? 74
                                                            : 0,
                                                    width: Responsive.isDesktop(
                                                            context)
                                                        ? 55
                                                        : 50,
                                                    child: Text(
                                                      (index + 1).toString(),
                                                      style:
                                                          greylightMediumGalano14,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  pendings[index]
                                                      .serviceName
                                                      .toString(),
                                                  style: blackBold20,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  pendings[index]
                                                      .user!
                                                      .name
                                                      .toString(),
                                                  style: black16,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Wrap(
                                                  children: [
                                                    Image.asset(
                                                        'assets/location_icon.png'),
                                                    Text(
                                                      '${pendings[index].user!.state!.name.toString()} ${pendings[index].user!.city!.name.toString()} ',
                                                      style: black14,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                pendings.isEmpty
                                                    ? Center(
                                                        child: Text("No Data"))
                                                    : Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ViewServiceRequestDetailsScreen(
                                                                      flag: pendings[
                                                                              index]
                                                                          .serviceProviderStatus!,
                                                                      servicereques:
                                                                          pendings[
                                                                              index],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              style: ElevatedButton.styleFrom(
                                                                  primary:
                                                                      MyAppColor
                                                                          .grayplane,
                                                                  elevation: 0,
                                                                  side: BorderSide(
                                                                      width:
                                                                          1.0,
                                                                      color: MyAppColor
                                                                          .black)),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    'VIEW REQUEST',
                                                                    style:
                                                                        blackRegular14,
                                                                  ),
                                                                  Icon(
                                                                    Icons
                                                                        .arrow_forward,
                                                                    color: MyAppColor
                                                                        .black,
                                                                  )
                                                                ],
                                                              )),
                                                        ],
                                                      )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                              }),
                        ),
                        SizedBox(
                          height: Responsive.isDesktop(context) ? 20 : 0,
                        ),
                        if (!Responsive.isDesktop(context))
                          if (pendings.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text('.  .  .  .  .'),
                                ],
                              ),
                            ),
                        SizedBox(
                          height: Responsive.isDesktop(context) ? 20 : 5,
                        ),
                        pendings.isEmpty
                            ? Center(child: Text("No Data"))
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                        primary: MyAppColor.greynormal,
                                        elevation: 0,
                                        side: BorderSide(
                                            width: 1.0,
                                            color: MyAppColor.black)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 28,
                                          right: 28,
                                          top: 10,
                                          bottom: 10),
                                      child: Text(
                                        'VIEW ALL',
                                        style: blackRegular14,
                                      ),
                                    ),
                                  )
                                ],
                              )
                      ],
                    ),
                  )),
            );
    });
  }

  subscriptionPart() {
    return Consumer(builder: (context, ref, child) {
      int? remainingDays = ref.watch(serviceProviderData).remainingDays;
      bool? isUserSubscribed =
          ref.watch(serviceProviderData).isCandidateSubscribed;
      String? planName = ref.watch(serviceProviderData).planName;
      String? startDataOfSubscription =
          ref.watch(serviceProviderData).startDateOfSubscription;
      return !isUserSubscribed
          ? SizedBox()
          : Responsive.isDesktop(context)
              ? Column(
                  children: [
                    Container(
                      color: MyAppColor.darkBlue,
                      height: Responsive.isDesktop(context) ? 486 : 0,
                      child: Column(
                        children: [
                          SizedBox(
                              height: Responsive.isDesktop(context) ? 10.0 : 0),
                          Image.asset('assets/company_homel.png'),
                          SizedBox(
                              height: Responsive.isDesktop(context) ? 10.0 : 0),
                          Expanded(
                              child: Text('YOU HAVE A SUBSCRIPTION',
                                  style: whiteMedium14)),
                          SizedBox(
                            height: Responsive.isDesktop(context) ? 10.0 : 0,
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Align(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                      'assets/company_circle1.png')),
                              Padding(
                                padding: EdgeInsets.only(top: 20.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: CustomPaint(
                                    foregroundPainter: RadialPainter(
                                        bgColor: Colors.grey,
                                        lineColor: Colors.orange,
                                        percent: 15.0,
                                        width: 2.0),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '$remainingDays',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Responsive.isDesktop(context) ? 10.0 : 0,
                          ),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'You can add Un-limited Services \n& can Accept Un-limited Service \nRequests.',
                                  style: Responsive.isDesktop(context)
                                      ? whiteMedium16
                                      : whiteMediumItalic14,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: Responsive.isDesktop(context) ? 10.0 : 0,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Container(
                  child: Column(
                    children: [
                      Container(
                        color: MyAppColor.darkBlue,
                        height: Responsive.isDesktop(context) ? 486 : 400,
                        child: Column(
                          children: [
                            SizedBox(
                              height: Responsive.isDesktop(context) ? 10.0 : 20,
                            ),
                            Image.asset('assets/company_homel.png'),
                            SizedBox(
                              height: Responsive.isDesktop(context) ? 10.0 : 10,
                            ),
                            Text('YOU HAVE A SUBSCRIPTION',
                                style: whitishMedium12),
                            SizedBox(
                              height: Responsive.isDesktop(context) ? 10.0 : 20,
                            ),
                            Stack(
                              children: [
                                Align(
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                        'assets/company_circle1.png')),
                                Padding(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      height: 170,
                                      child: CustomPaint(
                                        foregroundPainter: RadialPainter(
                                            bgColor: Colors.grey,
                                            lineColor: Colors.orange,
                                            percent: 15.0,
                                            width: 2.0),
                                        child: Center(
                                          child: Text(
                                            '$remainingDays',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: Responsive.isDesktop(context) ? 10.0 : 20,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'You can add Un-limited Services \n& can Accept Un-limited Service Requests.',
                                  style: Responsive.isDesktop(context)
                                      ? whiteMedium16
                                      : whiteMediumItalic14,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: Responsive.isDesktop(context) ? 10.0 : 10,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Responsive.isDesktop(context) ? 3.0 : 03,
                      ),
                      Container(
                        height: Responsive.isDesktop(context) ? 50 : 50,
                        color: MyAppColor.simplegrey,
                        child: Padding(
                          padding: EdgeInsets.all(
                            Responsive.isDesktop(context) ? 8.0 : 10,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Active Subscription Plan:',
                                  style: Responsive.isDesktop(context)
                                      ? black14
                                      : greyLightMedium12),
                              Text('$planName', style: black16)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                          height: Responsive.isDesktop(context) ? 3.0 : 3.0),
                      Container(
                        height: Responsive.isDesktop(context) ? 50 : 50,
                        color: MyAppColor.simplegrey,
                        child: Padding(
                          padding: EdgeInsets.all(
                            Responsive.isDesktop(context) ? 8.0 : 10,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Subscribed on:',
                                  style: Responsive.isDesktop(context)
                                      ? black14
                                      : greyLightMedium12),
                              Text('27.03.2021', style: black16)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
    });
  }

  Widget _chart({TextTheme? styles}) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(30),
          color: MyAppColor.greynormal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ALL REQUEST SERVICE',
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
                  child: Charts(grapData: grapData),
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

  graphPart() {
    return Responsive.isDesktop(context)
        ? Expanded(
            flex: Responsive.isDesktop(context) ? 6 : 2,
            child: Container(
              child: Padding(
                padding: EdgeInsets.only(
                    right: Responsive.isDesktop(context) ? 16.0 : 0),
                child: Column(
                  children: [
                    Container(
                      color: MyAppColor.greynormal,
                      height: Responsive.isDesktop(context) ? 540 : 0,
                      child: Padding(
                        padding: EdgeInsets.all(
                            Responsive.isDesktop(context) ? 25.0 : 4),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'SERVICE REQUEST HISTORY',
                                  style: blackRegular14,
                                ),
                                if (Responsive.isDesktop(context))
                                  Row(
                                    children: [
                                      Icon(Icons.arrow_drop_down),
                                      Text('All branches',
                                          style: blackMedium14),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Icon(Icons.arrow_drop_down),
                                      Text(
                                        '2020',
                                        style: blackMedium14,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Icon(Icons.arrow_drop_down),
                                      Text('Yearly', style: blackMedium14),
                                    ],
                                  ),
                              ],
                            ),
                            if (Responsive.isDesktop(context)) graphChart(),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Responsive.isDesktop(context) ? 0 : 2,
                    ),
                    Container(
                      color: MyAppColor.simplegrey,
                      height: Responsive.isDesktop(context) ? 53 : 30,
                      child: Padding(
                        padding: EdgeInsets.all(
                            Responsive.isDesktop(context) ? 12.0 : 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('X - Axis:', style: grey14),
                            Responsive.isDesktop(context)
                                ? SizedBox(width: 8)
                                : SizedBox(
                                    width: 0,
                                  ),
                            Text('Number of Service Requests', style: black14),
                            SizedBox(
                              width: Responsive.isDesktop(context) ? 30 : 30,
                            ),
                            Text(
                              'Y - Axis:',
                              style: grey14,
                            ),
                            SizedBox(
                              width: Responsive.isDesktop(context) ? 5 : 2,
                            ),
                            Text('Months', style: black14),
                            SizedBox(
                              width: Responsive.isDesktop(context) ? 42 : 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                  height: 22,
                                  width: 30,
                                  color: MyAppColor.green),
                            ),
                            Expanded(
                                child: Text('No. of Service Requests Accepted',
                                    style: black14)),
                            SizedBox(
                              width: Responsive.isDesktop(context) ? 10 : 4,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                  height:
                                      Responsive.isDesktop(context) ? 22 : 11,
                                  width:
                                      Responsive.isDesktop(context) ? 30 : 15,
                                  color: MyAppColor.orangelight),
                            ),
                            Expanded(
                                child: Text('No. of Service Requests Received',
                                    style: black14)),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        : Consumer(builder: (context, ref, child) {
            ServiceProviderDashboard? dashboardServiceProvider =
                ref.watch(serviceProviderData).dashboardServiceProvider;
            return Container(
              ///  height: 400,
              // width:200,
              child: Padding(
                padding: EdgeInsets.only(
                    right: Responsive.isDesktop(context) ? 16.0 : 0),
                child: Column(
                  children: [
                    Container(
                      color: MyAppColor.greynormal,
                      height: Responsive.isDesktop(context) ? 540 : 366,
                      child: Padding(
                        padding: EdgeInsets.all(
                            Responsive.isDesktop(context) ? 8.0 : 4),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'SERVICE REQUEST HISTORY',
                                    style: blackRegular16,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Icon(Icons.arrow_drop_down),
                                      Column(
                                        children: [
                                          Text(
                                            'All branches',
                                            style: blackMedium14,
                                          ),
                                          Text(
                                            dashboardServiceProvider!
                                                .serviceProviderBranchCount
                                                .toString(),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 20),
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Icon(Icons.arrow_drop_down),
                                      Column(
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              // await ref
                                              //     .read(serviceProviderData)
                                              //     .dashboard();
                                            },
                                            child: Text(
                                              '2022',
                                              style: blackMedium14,
                                            ),
                                          ),
                                          Column(
                                              children: List.generate(
                                                  dashboardServiceProvider
                                                      .grapData!.length,
                                                  (index) => Text(
                                                      dashboardServiceProvider
                                                          .grapData![index]
                                                          .count
                                                          .toString())))
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 20),
                                  // Wrap(
                                  //   crossAxisAlignment:
                                  //       WrapCrossAlignment.center,
                                  //   children: [
                                  //     Icon(Icons.arrow_drop_down),
                                  //     Text(
                                  //       'Yearly',
                                  //       style: blackMedium14,
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                            if (Responsive.isDesktop(context)) graphChart(),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Responsive.isDesktop(context) ? 3 : 0,
                    ),
                    Container(
                      color: MyAppColor.simplegrey,
                      //  height: Responsive.isDesktop(context) ? 50 : 50,
                      child: Padding(
                        padding: EdgeInsets.all(
                            Responsive.isDesktop(context) ? 12.0 : 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text('X - Axis:', style: grey12),
                                  SizedBox(
                                      width: Responsive.isDesktop(context)
                                          ? 30
                                          : 6),
                                  Text('Number of Service Requests',
                                      style: black14),
                                ]),
                            SizedBox(
                              height: Responsive.isDesktop(context) ? 30 : 6,
                            ),
                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    'Y - Axis:',
                                    style: grey12,
                                  ),
                                  SizedBox(
                                    width:
                                        Responsive.isDesktop(context) ? 10 : 6,
                                  ),
                                  Text('Months', style: black14),
                                ]),
                            SizedBox(
                              height: Responsive.isDesktop(context) ? 42 : 6,
                            ),
                            Row(children: [
                              Container(
                                  height: 20,
                                  width: 26,
                                  color: MyAppColor.green),
                              SizedBox(
                                width: Responsive.isDesktop(context) ? 30 : 10,
                              ),
                              Text('No. of Service Requests Accepted',
                                  style: black14),
                            ]),
                            SizedBox(
                              height: Responsive.isDesktop(context) ? 10 : 6,
                            ),
                            Row(children: [
                              Container(
                                  height:
                                      Responsive.isDesktop(context) ? 22 : 20,
                                  width:
                                      Responsive.isDesktop(context) ? 30 : 26,
                                  color: MyAppColor.orangelight),
                              SizedBox(
                                width: Responsive.isDesktop(context) ? 30 : 10,
                              ),
                              Text('No. of Service Requests Received',
                                  style: black14),
                            ])
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
    ;
  }

  Widget cardsRow() {
    return Consumer(builder: (context, ref, child) {
      List<Services> pendings = ref.watch(serviceProviderData).pending;
      List<Services> upcoming = ref.watch(serviceProviderData).upcoming;
      List<Services> all = ref.watch(serviceProviderData).serviceRequest;
      ServiceProviderDashboard? dashboardServiceProvider =
          ref.watch(serviceProviderData).dashboardServiceProvider;
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      Responsive.isDesktop(context) ? 0.0 : 0,
                      Responsive.isDesktop(context) ? 8.0 : 0,
                      Responsive.isDesktop(context) ? 8.0 : 5,
                      Responsive.isDesktop(context) ? 8.0 : 0),
                  child: cards(0,
                      icon: 'assets/service_icon.png',
                      count: pendings.isEmpty ? 0 : pendings.length.toString(),
                      text: Responsive.isDesktop(context)
                          ? 'Pending Service Request'
                          : 'Pending Service Request\n'))),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      Responsive.isDesktop(context) ? 0.0 : 05,
                      Responsive.isDesktop(context) ? 8.0 : 0,
                      Responsive.isDesktop(context) ? 8.0 : 0,
                      Responsive.isDesktop(context) ? 8.0 : 00),
                  child: cards(1,
                      icon: 'assets/accepted_request.png',
                      count: upcoming.isEmpty ? 0 : upcoming.length.toString(),
                      text: 'Accepted & Upcoming Request'))),
          if (Responsive.isDesktop(context))
            Expanded(
              child: Padding(
                  padding:
                      EdgeInsets.all(Responsive.isDesktop(context) ? 8.0 : 0),
                  child: cards(2,
                      icon: 'assets/my_services.png',
                      count: dashboardServiceProvider == null
                          ? 0
                          : dashboardServiceProvider
                              .serviceProviderServiceCount,
                      text: 'Total My Service')),
            ),
          if (Responsive.isDesktop(context))
            Expanded(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        Responsive.isDesktop(context) ? 8.0 : 4,
                        Responsive.isDesktop(context) ? 8.0 : 4,
                        Responsive.isDesktop(context) ? .0 : 4,
                        Responsive.isDesktop(context) ? 8.0 : 4),
                    child: cards(3,
                        icon: 'assets/branches.png',
                        count: dashboardServiceProvider == null
                            ? 0
                            : dashboardServiceProvider
                                .serviceProviderBranchCount,
                        text: 'My Branches'))),
        ],
      );
    });
  }

  Widget cardsRow2() {
    return Consumer(builder: (context, ref, child) {
      List<Services> pendings = ref.watch(serviceProviderData).pending;
      List<Services> upcoming = ref.watch(serviceProviderData).upcoming;
      List<Services> all = ref.watch(serviceProviderData).serviceRequest;
      all = pendings + upcoming;

      List<Branch> serviceget = ref.watch(serviceProviderData).serviceget;

      ServiceProviderDashboard? dashboardServiceProvider =
          ref.watch(serviceProviderData).dashboardServiceProvider;

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (!Responsive.isDesktop(context))
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    Responsive.isDesktop(context) ? 0.0 : 0,
                    Responsive.isDesktop(context) ? 8.0 : 0,
                    Responsive.isDesktop(context) ? 8.0 : 05,
                    Responsive.isDesktop(context) ? 8.0 : 00),
                // padding: EdgeInsets.all(Responsive.isDesktop(context) ? 8.0 : 5),
                child: cards(2,
                    icon: 'assets/my_services.png',
                    count: dashboardServiceProvider == null
                        ? 0
                        : dashboardServiceProvider.serviceProviderServiceCount,
                    text: 'Total My Service\n '),
              ),
            ),
          if (!Responsive.isDesktop(context))
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    Responsive.isDesktop(context) ? 0.0 : 05,
                    Responsive.isDesktop(context) ? 8.0 : 0,
                    Responsive.isDesktop(context) ? 8.0 : 0,
                    Responsive.isDesktop(context) ? 8.0 : 00),
                //  padding: EdgeInsets.all(Responsive.isDesktop(context) ? 8.0 : 5),
                child: cards(3,
                    icon: 'assets/branches.png',
                    count: dashboardServiceProvider == null
                        ? 0
                        : dashboardServiceProvider.serviceProviderBranchCount,
                    text: 'My Branches\n'),
              ),
            ),
        ],
      );
    });
  }

  Widget cards(value, {icon, text, count}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Responsive.isDesktop(context)
                ? FractionalOffset.topRight
                : FractionalOffset.centerRight,
            end: Responsive.isDesktop(context)
                ? FractionalOffset.bottomLeft
                : FractionalOffset.centerLeft,
            colors: [
              MyAppColor.greylight,
              MyAppColor.greylight,
              MyAppColor.applecolor,
              MyAppColor.applecolor,
            ],
            stops: [
              Responsive.isDesktop(context) ? 0.83 : 0.78,
              0.3,
              0.3,
              0.7,
            ]),
      ),
      height: Responsive.isDesktop(context) ? 100 : 130,
      child: Padding(
        padding: EdgeInsets.all(Responsive.isDesktop(context) ? 8.0 : 8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: Responsive.isDesktop(context) ? 8.0 : 22.0,
                    left: Responsive.isDesktop(context) ? 12.0 : 0.0,
                    right: Responsive.isDesktop(context) ? 8.0 : 0,
                    bottom: Responsive.isDesktop(context) ? 8.0 : 0,
                  ),
                  child: Image.asset(
                    icon,
                    height: Responsive.isDesktop(context) ? 30.0 : 20,
                    width: Responsive.isDesktop(context) ? 30.0 : 20,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: Responsive.isDesktop(context) ? 8.0 : 22.0,
                      left: Responsive.isDesktop(context) ? 16.0 : 22.0,
                      right: Responsive.isDesktop(context) ? 12.0 : 6,
                      bottom: Responsive.isDesktop(context) ? 8.0 : 4,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$count',
                          style: Responsive.isDesktop(context)
                              ? whiteDarkR24
                              : whiteSemiBoldGalano18,
                        ),
                        Text(
                          '$text',
                          style: Responsive.isDesktop(context)
                              ? whiteDarkR12
                              : whiteDarkR10,
                        )
                      ],
                    ),
                  ),
                ),
                if (Responsive.isDesktop(context))
                  InkWell(
                    onTap: () {
                      moveTabBar(value);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: Responsive.isDesktop(context) ? 8.0 : 0,
                        right: Responsive.isDesktop(context) ? 8.0 : 0,
                        top: Responsive.isDesktop(context) ? 8.0 : 0,
                        bottom: Responsive.isDesktop(context) ? 8.0 : 0,
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: MyAppColor.white,
                      ),
                    ),
                  ),
              ],
            ),
            if (!Responsive.isDesktop(context))
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      moveTabBar(value);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: Responsive.isDesktop(context) ? 8.0 : 0,
                        right: Responsive.isDesktop(context) ? 8.0 : 0,
                        top: Responsive.isDesktop(context) ? 8.0 : 0,
                        bottom: Responsive.isDesktop(context) ? 8.0 : 0,
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: MyAppColor.white,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  graphChart() {
    return Container(
      height: Responsive.isDesktop(context) ? 300.0 : 300,
      child: Column(children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(
              Responsive.isDesktop(context) ? 80.0 : 40,
            ),
            child: SfSparkLineChart.custom(
              //Enable the trackball
              trackball: SparkChartTrackball(
                  activationMode: SparkChartActivationMode.tap),
              //Enable marker
              marker: SparkChartMarker(
                  displayMode: SparkChartMarkerDisplayMode.all),
              //Enable data label
              labelDisplayMode: SparkChartLabelDisplayMode.all,
              xValueMapper: (int index) => data[index].year,
              yValueMapper: (int index) => data[index].sales,
              dataCount: 5,
            ),
          ),
        )
      ]),
    );
  }

  bottomRow2({title, text1, text2, text3, text4, text5}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: white16),
        SizedBox(
          height: Responsive.isDesktop(context) ? 10 : 10,
        ),
        Text(
          text1,
          style: greyRegular14,
        ),
        SizedBox(
          height: Responsive.isDesktop(context) ? 10 : 10,
        ),
        Text(
          text2,
          style: greyRegular14,
        ),
        SizedBox(
          height: Responsive.isDesktop(context) ? 10 : 10,
        ),
        Text(
          text3 ?? '',
          style: greyRegular14,
        ),
        SizedBox(
          height: Responsive.isDesktop(context) ? 10 : 10,
        ),
        Text(
          text4 ?? '',
          style: greyRegular14,
        ),
        SizedBox(
          height: Responsive.isDesktop(context) ? 10 : 10,
        ),
        Text(
          text5 ?? '',
          style: greyRegular14,
        ),
      ],
    );
  }

  completeYourProfileDetails() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CompleteYourProfileScreen()));
      },
      child: Center(
        child: Container(
            color: MyAppColor.lightBlue,
            height: Responsive.isDesktop(context) ? 60 : 87,
            width: Responsive.isDesktop(context)
                ? 750
                : MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Image.asset(
                    'assets/cut_staff.png',
                    color: Colors.blue,
                  ),
                ),
                Text(
                    Responsive.isDesktop(context)
                        ? 'Complete your Profile for better Placing for Service Searches and to get better Service Requests.'
                        : 'Complete your Profile for better \nPlacing for Service Searches and to \nget better Service Requests.',
                    style: whiteM12()),
                if (Responsive.isDesktop(context))
                  Padding(
                    padding: EdgeInsets.only(
                        top: Responsive.isDesktop(context) ? 48.0 : 75),
                    child: Image.asset('assets/mask.png'),
                  ),
                Icon(
                  Icons.arrow_forward,
                  color: MyAppColor.white,
                )
              ],
            )),
      ),
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final double sales;
  final year;
}
