
import 'package:clippy_flutter/paralellogram.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/label_string.dart';
import 'package:hindustan_job/serviceprovider/screens/HomeServiceProviderTabs/ServicesRequests/services_requests_screen.dart';
import 'package:hindustan_job/serviceprovider/screens/HomeServiceProviderTabs/add_a_service_screen.dart';
import 'package:hindustan_job/serviceprovider/screens/HomeServiceProviderTabs/my_profile.dart';
import 'package:hindustan_job/serviceprovider/screens/HomeServiceProviderTabs/service_details_screen.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';

import '../../../../candidate/header/back_text_widget.dart';
import '../../../../candidate/model/serviceProviderModal/alldata_get_modal.dart';
import '../../../../candidate/model/services_model.dart';
import '../../../../candidate/pages/job_seeker_page/home/drawer/drawer_jobseeker.dart';
import '../../../../candidate/pages/job_seeker_page/home/homeappbar.dart';
import '../../../../services/api_service_serviceProvider/service_provider.dart';
import '../../../../services/services_constant/constant.dart';
import '../../../../services/services_constant/response_model.dart';
import '../../../../widget/common_app_bar_widget.dart';

class ViewServiceRequestDetailsScreen extends ConsumerStatefulWidget {
  Services? servicereques;
  int? serviceRequestId;
  String flag;

  ViewServiceRequestDetailsScreen(
      {Key? key, required this.flag, this.serviceRequestId, this.servicereques})
      : super(key: key);
  @override
  _ViewServiceRequestDetailsScreenState createState() =>
      _ViewServiceRequestDetailsScreenState();
}

class _ViewServiceRequestDetailsScreenState
    extends ConsumerState<ViewServiceRequestDetailsScreen> {
  Services? servicereques;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      getServiceRequestDetails();
    } else {
      getServiceDetails(widget.servicereques!.id);
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        ref
            .read(serviceProviderData)
            .updateStatus(widget.flag, widget.servicereques!.userStatus);
      });
    }
  }

  getServiceRequestDetails() async {
    try {
      ApiResponse response =
          await getServiceRequest(serviceRequestId: widget.serviceRequestId);
      if (response.status == 200) {

        widget.servicereques =
            ServicesModel.fromJson(response.body!.data).services!.first;
        getServiceDetails(widget.servicereques!.id);
        SchedulerBinding.instance.addPostFrameCallback((_) async {
          ref
              .read(serviceProviderData)
              .updateStatus(widget.flag, widget.servicereques!.userStatus);
        });
        setState(() {});
      }
    } catch (e) {
    }
  }

  AllServiceFetch? fetchedService;
  getServiceDetails(id) async {
    ApiResponse response = await getService(id: id);
    if (response.status == 200) {
      fetchedService = AllServiceFetch.fromJson(response.body!.data);
      setState(() {});
    }
  }

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    return DefaultTabController(
      length: 4,
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle(statusBarColor: MyAppColor.backgroundColor),
        child: SafeArea(
          child: Scaffold(
            drawerEnableOpenDragGesture: false,
            backgroundColor: MyAppColor.backgroundColor,
            key: _drawerKey,
            drawer: Drawer(
              child: DrawerJobSeeker(),
            ),
            appBar: !kIsWeb
                ? PreferredSize(
                    child: BackWithText(text: ""),
                    preferredSize: Size.fromHeight(50))
                : PreferredSize(
                    preferredSize: Size.fromHeight(
                        Responsive.isDesktop(context) ? 150 : 150),
                    child: CommomAppBar(
                      drawerKey: _drawerKey,
                    ),
                  ),
            body: SingleChildScrollView(
              child: mainBody(),
            ),
          ),
        ),
      ),
    );
  }

  backButtonContainer() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: MyAppColor.greynormal,
            height: Responsive.isDesktop(context) ? 50 : 40,
            child: Row(
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  children: [
                    SizedBox(
                      width: Responsive.isDesktop(context) ? 40 : 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                        height: Responsive.isMobile(context) ? 25 : 20,
                        child: CircleAvatar(
                          radius: Responsive.isDesktop(context) ? 20.0 : 15,
                          backgroundColor: MyAppColor.backgray,
                          child: Icon(
                            Icons.arrow_back,
                            color: MyAppColor.greylight,
                            size: Responsive.isDesktop(context) ? 20 : 20,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Responsive.isDesktop(context) ? 20 : 10,
                    ),
                    Text(
                      LabelString.back,
                      style: grey14,
                    ),
                    SizedBox(
                      width: Responsive.isDesktop(context) ? 40 : 20,
                    ),
                    Text(
                      'HOME (HSP) / COMPLETE PROFILE',
                      style: greyMedium10,
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  var sizeBoxHeight = 20.0;
  Widget mainBody() {
    return Consumer(builder: (context, ref, child) {
      bool upcoming = ref.watch(serviceProviderData).isUpcoming;
      bool complete = ref.watch(serviceProviderData).isComplete;
      bool rejected = ref.watch(serviceProviderData).isRejected;
      bool pending = ref.watch(serviceProviderData).isPending;
      bool cancelled = ref.watch(serviceProviderData).isCancelled;
      return Container(
        height: Responsive.isDesktop(context)
            ? MediaQuery.of(context).size.height - 140
            : MediaQuery.of(context).size.height,
        child: widget.servicereques == null
            ? loaderIndicator(context)
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: Responsive.isDesktop(context)
                          ? Sizeconfig.screenWidth! / 3
                          : MediaQuery.of(context).size.width - 10,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(height: sizeBoxHeight),
                            SizedBox(height: sizeBoxHeight),
                            Text(
                              'SERVICE REQUEST',
                              style: blackDarkR18,
                            ),
                            SizedBox(height: sizeBoxHeight),
                            SizedBox(height: sizeBoxHeight),
                            Container(
                              margin: EdgeInsets.only(
                                bottom: 5,
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    if (pending && !cancelled)
                                      Container(
                                        color: MyAppColor.greylight,
                                        child: Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Column(
                                            children: [
                                              header(
                                                  pending,
                                                  complete,
                                                  upcoming,
                                                  rejected,
                                                  cancelled),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: Responsive
                                                                .isDesktop(
                                                                    context)
                                                            ? 8.0
                                                            : 2.0),
                                                    child: cancelRequestButton(
                                                        function: () async {
                                                          await ref
                                                              .read(
                                                                  serviceProviderData)
                                                              .accept(
                                                                context,
                                                                serReqId: widget
                                                                    .servicereques!
                                                                    .serviceRequestId,
                                                                status:
                                                                    'REJECTED',
                                                              );
                                                        },
                                                        text: Responsive
                                                                .isDesktop(
                                                                    context)
                                                            ? widget.flag ==
                                                                    'pending'
                                                                ? 'REJECT REQUEST'
                                                                : 'CANCEL REQUEST'
                                                            : 'REJECT'),
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: Responsive
                                                                  .isDesktop(
                                                                      context)
                                                              ? 8.0
                                                              : 2),
                                                      child: button(
                                                        function: () async {
                                                          setState(() {
                                                            upcoming = true;
                                                          });
                                                          await ref
                                                              .read(
                                                                  serviceProviderData)
                                                              .accept(
                                                                context,
                                                                serReqId: widget
                                                                    .servicereques!
                                                                    .serviceRequestId,
                                                                status:
                                                                    'ACCEPTED',
                                                              );
                                                          await ref
                                                              .read(
                                                                  serviceProviderData)
                                                              .getdataserviceRequest(
                                                                  serviceStatus:
                                                                      'PENDING');
                                                        },
                                                        text: 'ACCEPT REQUEST',
                                                      ))
                                                ],
                                              ),
                                              if (widget.flag != 'completed')
                                                SizedBox(
                                                  height: 20,
                                                ),
                                            ],
                                          ),
                                        ),
                                      ), //blue container
                                    if (pending && cancelled)
                                      Container(
                                          color: MyAppColor.greylight,
                                          child: Padding(
                                              padding: EdgeInsets.all(16.0),
                                              child: Column(children: [
                                                header(
                                                    pending,
                                                    complete,
                                                    upcoming,
                                                    rejected,
                                                    cancelled),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                              ]))),
                                    if (upcoming)
                                      Container(
                                        color: MyAppColor.darkBlue,
                                        child: Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Column(
                                            children: [
                                              header(
                                                  pending,
                                                  complete,
                                                  upcoming,
                                                  rejected,
                                                  cancelled),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: Responsive
                                                                .isDesktop(
                                                                    context)
                                                            ? 8.0
                                                            : 2.0),
                                                    child: cancelRequestButton(
                                                        function: () {
                                                          ref
                                                              .read(
                                                                  serviceProviderData)
                                                              .accept(
                                                                context,
                                                                serReqId: widget
                                                                    .servicereques!
                                                                    .serviceRequestId,
                                                                status:
                                                                    'REJECTED',
                                                              );
                                                        },
                                                        text: 'REJECT'),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: Responsive
                                                                .isDesktop(
                                                                    context)
                                                            ? 8.0
                                                            : 2),
                                                    child: button(
                                                      function: () async {
                                                        await ref
                                                            .read(
                                                                serviceProviderData)
                                                            .sends(
                                                              context,
                                                              serReqId: widget
                                                                  .servicereques!
                                                                  .serviceRequestId,
                                                              status:
                                                                  'COMPLETED',
                                                            );
                                                        await ref
                                                            .read(
                                                                serviceProviderData)
                                                            .getdataserviceRequest(
                                                                serviceStatus:
                                                                    'ACCEPTED');
                                                      },
                                                      text: 'MARK AS COMPLETED',
                                                    ),
                                                  )
                                                ],
                                              ),
                                              if (widget.flag != 'completed')
                                                SizedBox(
                                                  height: 20,
                                                ),
                                            ],
                                          ),
                                        ),
                                      ), //blue container
                                    if (rejected)
                                      Container(
                                        color: MyAppColor.black,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            children: [
                                              header(
                                                  pending,
                                                  complete,
                                                  upcoming,
                                                  rejected,
                                                  cancelled),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              if (widget.flag != 'completed')
                                                SizedBox(
                                                  height: 20,
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    if (complete)
                                      Container(
                                        color: MyAppColor.green,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            children: [
                                              header(
                                                  pending,
                                                  complete,
                                                  upcoming,
                                                  rejected,
                                                  cancelled),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              if (widget.flag != 'completed')
                                                SizedBox(
                                                  height: 20,
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    Container(
                                      color: MyAppColor.greynormal,
                                      margin: EdgeInsets.only(bottom: 5),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                        'assets/maintenance_grey.png'),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      widget.servicereques!
                                                          .serviceName
                                                          .toString(),
                                                      style: BlackDarkSb18(),
                                                    )
                                                  ],
                                                ),
                                                ratingBar()
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                                children: List.generate(
                                              widget.servicereques!
                                                  .serviceCategories!.length,
                                              (index) => container(
                                                  text: widget
                                                      .servicereques!
                                                      .serviceCategories![index]
                                                      .categoryName,
                                                  image: 'assets/setting.png',
                                                  width: 110),
                                            )),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Responsive.isDesktop(context)
                                                ? Row(
                                                    children: [
                                                      Text(
                                                          '${widget.servicereques!.serviceCharge}',
                                                          style:
                                                              BlackDarkSb18()),
                                                      Text('Service Charge')
                                                    ],
                                                  )
                                                : Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Wrap(
                                                        crossAxisAlignment:
                                                            WrapCrossAlignment
                                                                .center,
                                                        children: [
                                                          Image.asset(
                                                              'assets/location_icon.png'),
                                                          Text(
                                                            widget
                                                                .servicereques!
                                                                .user!
                                                                .city!
                                                                .name!
                                                                .toString(),
                                                            style: black14,
                                                          ),
                                                          Text(
                                                            widget
                                                                .servicereques!
                                                                .user!
                                                                .state!
                                                                .name!
                                                                .toString(),
                                                            style: black14,
                                                          ),
                                                        ],
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      ServiceDetailsScreen(
                                                                          allservice:
                                                                              fetchedService!)));
                                                        },
                                                        child: Wrap(
                                                          crossAxisAlignment:
                                                              WrapCrossAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'view  ',
                                                              style:
                                                                  orangeDarkSemibold12,
                                                            ),
                                                            Image.asset(
                                                              'assets/forward_arrow.png',
                                                              color: MyAppColor
                                                                  .orangedark,
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  )
                                          ],
                                        ),
                                      ),
                                    ),
                                    containersLabelsTextDetails(
                                        lable: 'CLIENT NAME',
                                        text: widget.servicereques!.user!.name),
                                    if (!rejected && !cancelled && !pending)
                                      contactContainersLabelsTextDetails(
                                          lable: 'CONTACT NUMBER',
                                          text: widget.servicereques!.user!
                                                  .mobile ??
                                              ''),
                                    containersLabelsTextDetails(
                                        lable: 'ADDRESS',
                                        text: (widget.servicereques!.user!
                                                    .addressLine1 ??
                                                '') +
                                            (widget.servicereques!.user!
                                                    .addressLine2 ??
                                                '')),
                                    containersLabelsTextDetails(
                                        lable: 'DATE SERVICE REQUESTED FOR',
                                        text:
                                            widget.servicereques!.requestDate ??
                                                ''),
                                    containersLabelsTextDetails(
                                        lable: 'DATE REQUEST GENERATED',
                                        text: formatDate(widget
                                                .servicereques!.createdAt) ??
                                            ''),
                                  ]),
                            ),
                            Container(
                              color: MyAppColor.greynormal,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        'APPLICABLE BRANCH',
                                        style: blackRegular12,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 0, 16, 16),
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0, right: 5),
                                                  child: Image.asset(
                                                      'assets/bharat_service_co.png'),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                color: MyAppColor.grayplane,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 2.0,
                                                                    right: 2),
                                                            child: Image.asset(
                                                                'assets/location_icon.png'),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0.0),
                                                        child: Container(
                                                          color: MyAppColor
                                                              .grayplane,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              // Text(
                                                              //   widget
                                                              //       .servicereques!
                                                              //       .serviceProviderBranch!
                                                              //       .address1!
                                                              //       .toString(),
                                                              //   style:
                                                              //       blackDarkSemibold14,
                                                              // ),
                                                              Text(
                                                                widget
                                                                    .servicereques!
                                                                    .user!
                                                                    .city!
                                                                    .name
                                                                    .toString(),
                                                                style:
                                                                    blackDarkSemibold14,
                                                              ),
                                                              Text(
                                                                widget
                                                                    .servicereques!
                                                                    .user!
                                                                    .state!
                                                                    .name
                                                                    .toString(),
                                                                style:
                                                                    blackDarkSemibold14,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: sizeBoxHeight,
                            ),
                            SizedBox(
                              height: sizeBoxHeight,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Footer()
                  ],
                ),
              ),
      );
    });
  }

  header(isPending, isComplete, isAccepted, isRejected, isCancelled) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isPending
            ? Image.asset(
                'assets/service_icon.png',
              )
            : isComplete
                ? Image.asset(
                    'assets/service_icon.png',
                  )
                : Image.asset(
                    'assets/accept_request.png',
                  ),
        if (!Responsive.isDesktop(context)) SizedBox(width: 10),
        isAccepted
            ? Text(
                Responsive.isDesktop(context)
                    ? 'You have accepted this Service Request.'
                    : 'You have accepted this\nService Request.',
                style: greyMedium18,
              )
            : isComplete
                ? Text(
                    Responsive.isDesktop(context)
                        ? 'You have Completed this Service Request.'
                        : 'You have Completed this\nService Request.',
                    style: greyMedium18,
                  )
                : isCancelled
                    ? Text(
                        Responsive.isDesktop(context)
                            ? 'Seeker has cancelled this Service'
                            : 'Seeker has cancelled\nthis Service',
                        style: greyMedium18,
                      )
                    : isPending
                        ? Text(
                            Responsive.isDesktop(context)
                                ? 'Client has requested for this Service'
                                : 'Client has requested for\nthis Service',
                            style: greyMedium18,
                          )
                        : Text(
                            Responsive.isDesktop(context)
                                ? 'You rejected request for this Service'
                                : 'You rejected request for\nthis Service',
                            style: greyMedium18,
                          )
      ],
    );
  }

  containersLabelsTextDetails({lable, text}) {
    return Container(
      color: MyAppColor.greynormal,
      margin: const EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lable, style: blackRegular12),
                Text(
                  "$text",
                  style: blackdarkM16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  contactContainersLabelsTextDetails({lable, text}) {
    return Container(
      color: MyAppColor.greynormal,
      margin: const EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lable, style: blackRegular12),
                Text(
                  text,
                  style: blackdarkM16,
                ),
                CALL_SERVICE_PROVIDER()
              ],
            ),
          ),
        ],
      ),
    );
  }

  CALL_SERVICE_PROVIDER() {
    return ElevatedButton(
        onPressed: () async {
          await FlutterPhoneDirectCaller.callNumber(
              widget.servicereques!.user!.mobile!);
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: widget.servicereques!.serviceProviderStatus ==
                  ServiceStatus.pending
              ? MyAppColor.greylight
              : MyAppColor.greylightOpacity,
        ),
        child: Row(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Wrap(
                  children: [
                    Icon(Icons.call, size: 15),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'CALL SERVICE SEEKER',
                      style: whiteRegularGalano12,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget container({text, double? width, image}) {
    return Parallelogram(
      cutLength: 5.0,
      edge: Edge.RIGHT,
      child: Container(
        color: MyAppColor.greylight,
        width: width,
        height: 25.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Image.asset(image),
                  )
                : SizedBox(),
            Text(text, style: whiteBoldGalano12),
          ],
        ),
      ),
    );
  }

  ratingBar() {
    return RatingBar.builder(
      initialRating: 3,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      unratedColor: MyAppColor.white,
      itemCount: 5,
      ignoreGestures: true,
      itemSize: 18.0,
      //itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        setState(() {
          //   _rating = rating;
        });
      },
      updateOnDrag: true,
    );
  }

  markAsCompleted() {}

  cancelRequestFun() {}

  Widget cancelRequestButton({required Function function, text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
            onPressed: () => function(),
            style: ElevatedButton.styleFrom(
                primary: widget.flag != 'PENDING'
                    ? MyAppColor.darkBlue
                    : MyAppColor.greylight,
                side: BorderSide(width: 1.0, color: MyAppColor.white)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    text,
                    style: whiteRegular14,
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget button({required Function function, text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
            onPressed: () => function(),
            style: ElevatedButton.styleFrom(
              primary: MyAppColor.orangelight,
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    text,
                    style: whiteRegular14,
                  ),
                ),
              ],
            )),
      ],
    );
  }
//   Widget button({required Function function, text}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 18.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ElevatedButton(
//               onPressed: () => function,
//               style: ElevatedButton.styleFrom(
//                 primary: MyAppColor.orangelight,
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: [
//                     Text(
//                       text,
//                       style: whiteRegular14,
//                     ),
//                   ],
//                 ),
//               )),
//         ],
//       ),
//     );
//   }
// }
}

// class BottomBarGreyForWindow extends StatelessWidget {
//   const BottomBarGreyForWindow({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     bottomRow({title, text1, text2, text3, text4, text5}) {
//       return Expanded(
//         flex: 2,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(title, style: white16),
//             SizedBox(
//               height: Responsive.isDesktop(context) ? 10 : 0,
//             ),
//             Text(
//               text1,
//               style: greyRegular14,
//             ),
//             SizedBox(
//               height: Responsive.isDesktop(context) ? 10 : 0,
//             ),
//             Text(
//               text2,
//               style: greyRegular14,
//             ),
//             SizedBox(
//               height: Responsive.isDesktop(context) ? 10 : 0,
//             ),
//             Text(
//               text3 ?? '',
//               style: greyRegular14,
//             ),
//             SizedBox(
//               height: Responsive.isDesktop(context) ? 10 : 0,
//             ),
//             Text(
//               text4 ?? '',
//               style: greyRegular14,
//             ),
//             SizedBox(
//               height: Responsive.isDesktop(context) ? 10 : 0,
//             ),
//             Text(
//               text5 ?? '',
//               style: greyRegular14,
//             ),
//           ],
//         ),
//       );
//     }

//     bottomBarWidget(context) {
//       return Container(
//         height: Responsive.isDesktop(context) ? 333 : 0,
//         // width: 47,
//         child: Column(
//           children: [
//             Container(
//               height: Responsive.isDesktop(context) ? 283 : 0,
//               color: MyAppColor.greylight,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Expanded(
//                     flex: 4,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Image.asset('assets/Group.png'),
//                         SizedBox(
//                           height: Responsive.isDesktop(context) ? 20 : 0,
//                         ),
//                         Text(
//                           '©2022 All Rights Reserved',
//                           style: greyRegular14,
//                         ),
//                       ],
//                     ),
//                   ),
//                   bottomRow(
//                     title: 'Links',
//                     text1: 'About Us',
//                     text2: 'Privacy Policy',
//                     text3: 'T & C',
//                     text4: 'Subscription',
//                   ),
//                   bottomRow(
//                       title: 'Roles',
//                       text1: 'Job-Seekers',
//                       text2: 'Company',
//                       text3: 'Home-Service Provider',
//                       text4: 'Home-Service Seeker',
//                       text5: 'Local Hunar'),
//                   bottomRow(
//                       title: 'Work with Us',
//                       text1: 'Business Correspondence',
//                       text2: 'Cluster Manager',
//                       text3: 'Advisor',
//                       text4: 'Field Sales Executive'),
//                   bottomRow(
//                       title: 'Contact',
//                       text1: '+91 987 654 3210',
//                       text2: '+91 987 654 3210',
//                       text3: 'support@hindustanjobs.com'),
//                 ],
//               ),
//             ),
//             Container(
//               height: Responsive.isDesktop(context) ? 50 : 0,
//               color: MyAppColor.normalblack,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Wrap(
//                     crossAxisAlignment: WrapCrossAlignment.center,
//                     children: [
//                       Text(
//                         'Designed by Akash Divya, HackerKernel with',
//                         style: greyRegular12,
//                       ),
//                       Image.asset('assets/heart.png', height: 20, width: 20)
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return bottomBarWidget(context);
//   }
// }
