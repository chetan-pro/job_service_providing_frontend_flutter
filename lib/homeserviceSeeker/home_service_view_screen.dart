import 'package:clippy_flutter/paralellogram.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/model/branch_model.dart';
import 'package:hindustan_job/candidate/model/services_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/drawer/drawer_jobseeker.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/label_string.dart';
import 'package:hindustan_job/homeserviceSeeker/search_home_service_list_screen.dart';
import 'package:hindustan_job/homeserviceSeeker/service_provider_details_screen.dart';
import 'package:hindustan_job/services/api_services/seeker_service_search.dart';
import 'package:hindustan_job/services/api_services/service_seeker_services.dart';
import 'package:hindustan_job/services/services_constant/constant.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/buttons/radio_button_widget.dart';
import 'package:hindustan_job/widget/drop_down_widget/drop_down_dynamic_widget.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:hindustan_job/widget/text/date_picker.dart';
import 'package:vrouter/vrouter.dart';

import '../candidate/dropdown/dropdown_list.dart';
import '../candidate/dropdown/dropdown_string.dart';
import '../candidate/header/back_text_widget.dart';
import '../candidate/model/experience_filter_model.dart';
import '../candidate/model/serviceProviderModal/alldata_get_modal.dart';
import '../candidate/model/serviceProviderModal/mybranch.dart';
import '../candidate/model/serviceProviderModal/rate_service.dart';
import '../services/api_service_serviceProvider/category.dart';
import '../widget/common_app_bar_widget.dart';
import '../widget/text_form_field_widget.dart';
import 'branch_card.dart';

class HomeServiceViewScreen extends ConsumerStatefulWidget {
  var flag;
  String serviceId;
  String? serviceRequestId;

  HomeServiceViewScreen(
      {Key? key, this.flag, required this.serviceId, this.serviceRequestId})
      : super(key: key);
  @override
  ConsumerState<HomeServiceViewScreen> createState() =>
      _HomeServiceViewScreenState();
}

class _HomeServiceViewScreenState extends ConsumerState<HomeServiceViewScreen> {
  int group = 1;

  var listOfDays = [
    LabelString.monday,
    LabelString.tuesday,
    LabelString.wednesday,
    LabelString.thursday,
    LabelString.friday,
    LabelString.saturday,
    LabelString.sunday
  ];

  bool isReviewSubmitted = false;
  String? selectedTime;
  var timeToSend;
  Branch? selectedBranch;
  TextEditingController reviewController = TextEditingController();
  double? _rating;
  TextEditingController searchController = TextEditingController();
  List<ExperienceFilter> serviceChargeList = [];
  ExperienceFilter? selectedServiceChargeList;
  List<ServiceCategories> catogaries = [];
  ServiceCategories? selectedCategory;

  @override
  void initState() {
    super.initState();
    print(DateTime(DateTime.now().year, DateTime.now().month + 1,
        DateTime.now().day + 30));
    serviceChargeList =
        ExperienceFilterModel.fromJson(ListDropdown.serviceChargeList)
            .experienceFilter!;
    fetchcatogary();
    ref.read(serviceProviderData).rate(widget.serviceId.toString());
    getServiceById(
        serviceId: widget.serviceId, serviceRequestId: widget.serviceRequestId);
  }

  fetchcatogary() async {
    catogaries = await categoryData(context);
    setState(() {});
  }

  Services? service;
  getServiceById({serviceId, serviceRequestId}) async {
    service = await getService(context,
        id: serviceId, serviceRequestId: serviceRequestId);
    if (service != null) {
      if (serviceRequestId != null) {
        await getRateRequest(serviceId, serviceRequestId);
      }
      await getProviderBranches(service!.serviceProviderId);
    }
    setState(() {});
  }

  getRateRequest(serviceId, serviceRequestId) async {
    ApiResponse response =
        await getRateServiceRequest(serviceId, serviceRequestId);
    if (response.status == 200) {
      if (response.body!.data.isNotEmpty) {
        isReviewSubmitted = true;
        ref.read(serviceProviderData).rate(widget.serviceId.toString());
        setState(() {});
      }
    }
  }

  cancelRequest(id) async {
    var carryData = {"user_status": "REJECT", "service_request_id": id};
    ApiResponse response = await updateServiceRequestSeeker(carryData);
    if (response.status == 200) {
      await getServiceById(serviceRequestId: id, serviceId: widget.serviceId);
    }
    setState(() {});
  }

  List<Branch> branches = [];
  getProviderBranches(providerId) async {
    branches = await getBranches(context, providerId: providerId);
  }

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    return Consumer(builder: (context, ref, child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        key: _drawerKey,
        drawer: Drawer(
          child: DrawerJobSeeker(),
        ),
        appBar: !kIsWeb
            ? PreferredSize(
                child:
                    BackWithText(text: "HOME (SERVICE-SEEKER) /VIEW SERVICE"),
                preferredSize: Size.fromHeight(50))
            : PreferredSize(
                preferredSize:
                    Size.fromHeight(Responsive.isDesktop(context) ? 150 : 150),
                child: CommomAppBar(
                  drawerKey: _drawerKey,
                  back: "HOME (SERVICE-SEEKER) /VIEW SERVICE",
                ),
              ),
        body: Responsive.isDesktop(context)
            ? ListView(
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                          right: Responsive.isMobile(context) ? 10 : 130.0,
                          left: Responsive.isMobile(context) ? 10 : 130),
                      child: Column(children: [
                        SizedBox(
                            height: Responsive.isDesktop(context) ? 20.0 : 25),
                        radioButtonsWithSearch(),
                        const SizedBox(
                          height: 20,
                        ),
                        service != null && service!.id != null
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [partLeft1(), partRight2()],
                              )
                            : loaderIndicator(context)
                      ])),
                  Footer()
                ],
              )
            : Column(
                children: [
                  service != null && service!.id != null
                      ? Padding(
                          padding: const EdgeInsets.all(00.0),
                          child: SizedBox(
                            height: Sizeconfig.screenHeight! - 204,
                            child: ListView(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: SeekerSearch(
                                      isUserSubscribed: true,
                                      isNavigater: true),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: flagAccordingColoredContainer(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: container1(),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: servicePhotosContainer(),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: daysListContainer(),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                          '.   .   .   .   .   .   .   .   .   .   .   .   .   .'),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Container(
                                    color: MyAppColor.greynormal,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // ignore: prefer_const_constructors
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          child: Text(
                                            'REVIEWS',
                                            style: blackRegular16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                service!.serviceProviderStatus ==
                                            ServiceStatus.completed &&
                                        isReviewSubmitted == false
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: Container(
                                          color: MyAppColor.greynormal,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  color: MyAppColor
                                                      .backgroundColor,
                                                  child: Row(
                                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                                    // mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      // ignore: prefer_const_constructors
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 5,
                                                                horizontal: 10),
                                                        child: Text(
                                                          'ADD REVIEWS',
                                                          style: blackRegular16,
                                                        ),
                                                      ),
                                                      ratingBar()
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  child: textfieldContainer(
                                                      context,
                                                      height: 100.0,
                                                      control: reviewController,
                                                      text:
                                                          'Type your review here...',
                                                      maxlines: 6,
                                                      topPadding: 4.0)),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  child: submitButton(context)),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: reviewsContainerList()),
                                const SizedBox(
                                  height: 10,
                                ),
                                Footer()
                              ],
                            ),
                          ),
                        )
                      : loaderIndicator(context),
                ],
              ),
      );
    });
  }

  Widget submitButton(context) {
    return ElevatedButton(
        onPressed: () async {
          if (reviewController.text == '') {
            return showSnack(
                context: context, msg: "Type something...", type: 'error');
          }
          var carryData = {
            "star": _rating,
            "comment": reviewController.text,
            "service_request_id": service!.serviceRequestId
          };
          ApiResponse response = await addReviewsService(carryData);
          if (response.status == 200) {
            showSnack(
              context: context,
              msg: "Review added successfully",
            );
            isReviewSubmitted = true;
            await getServiceById(
                serviceId: service!.id,
                serviceRequestId: service!.serviceRequestId);
            setState(() {});
          } else {
            showSnack(
              context: context,
              msg: "Something went wrong",
            );
          }
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: MyAppColor.orangelight,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Text(
            Responsive.isDesktop(context) ? 'SUBMIT ' : 'SUBMIT ',
            textAlign: TextAlign.center,
            style: Responsive.isDesktop(context) ? whiteR14() : whiteR12(),
          ),
        ));
  }

  backButtonContainer() {
    return Container(
        color: MyAppColor.greynormal,
        height: Responsive.isDesktop(context) ? 40 : 40,
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
        ));
  }

  similarSErvicesContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'SIMILAR HOME-SERVICES',
          style:
              Responsive.isDesktop(context) ? blackRegular18 : blackRegular14,
        ),
        const SizedBox(height: 20),
        latestHomeServiceListViewItemWidget(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: _viewAll(),
            ),
          ],
        )
      ],
    );
  }

  partRight2() {
    return Expanded(flex: 2, child: Container());
  }

  radioButtonsWithSearch() {
    return Container(
      color: MyAppColor.greynormal,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RadioButton(
              text: 'Search Home-Services',
              groupValue: group,
              onChanged: (value) => setState(() {
                group = value;
              }),
              value: 1,
            ),
            RadioButton(
              text: 'Search Home-Service Providers',
              groupValue: group,
              onChanged: (value) => setState(() {
                group = value;
              }),
              value: 2,
            ),
            const Spacer(),
            SizedBox(
              width: Sizeconfig.screenWidth! / 7,
              child: TextFormFieldWidget(
                text: 'Search Services here..',
                type: TextInputType.multiline,
                control: searchController,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            selectCategoryDropdown(),
            const SizedBox(
              width: 10,
            ),
            serviceChargeDropdown(),
            const SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                var carryData = {
                  "categoryIds": selectedCategory != null
                      ? selectedCategory!.id.toString()
                      : '',
                  "priceRange[0]": selectedServiceChargeList != null
                      ? selectedServiceChargeList!.from.toString()
                      : '',
                  "priceRange[1]": selectedServiceChargeList != null
                      ? selectedServiceChargeList!.to.toString()
                      : '',
                };
                carryData[group == 2 ? 'ServiceProviderName' : 'service_name'] =
                    searchController.text.trim();
                context.vRouter.to("/home-service-seeker/search-service/false",
                    queryParameters: carryData);
              },
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                      color: MyAppColor.orangelight),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Icon(
                      Icons.search,
                      size: 17,
                      color: MyAppColor.white,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  flagAccordingColoredContainer() {
    print(service!.serviceProviderStatus);
    return service!.serviceProviderStatus != null
        ? Container(
            ///margin: EdgeInsets.only(bottom: 5),
            color: service!.serviceProviderStatus == ServiceStatus.completed
                ? MyAppColor.green
                : service!.serviceProviderStatus == ServiceStatus.accepted
                    ? MyAppColor.darkBlue
                    : MyAppColor.greylight,
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          service!.serviceProviderStatus ==
                                  ServiceStatus.pending
                              ? Image.asset(
                                  'assets/service_icon.png',
                                )
                              : service!.serviceProviderStatus ==
                                      ServiceStatus.completed
                                  ? Image.asset(
                                      'assets/service_icon.png',
                                    )
                                  : Image.asset(
                                      'assets/accept_request.png',
                                    ),
                          const SizedBox(
                            width: 6,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                service!.serviceProviderStatus ==
                                        ServiceStatus.completed
                                    ? 'This Home-Service is completed'
                                    : service!.serviceProviderStatus ==
                                            ServiceStatus.accepted
                                        ? 'Your Home-Service Request has\nbeen accepted by the Service\nProvider.'
                                        : service!.userStatus ==
                                                    ServiceStatus.request &&
                                                service!.serviceProviderStatus ==
                                                    ServiceStatus.pending
                                            ? 'You have requested for this Service.\nPlease wait for Approval from\nService Provider.'
                                            : service!.serviceProviderStatus ==
                                                    ServiceStatus.rejected
                                                ? 'Service provider cancelled request for\nthis Service.'
                                                : 'You cancelled request for this Service.',
                                style: whitishM14,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Wrap(
                                runAlignment: WrapAlignment.center,
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 11,
                                    color: MyAppColor.white,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    dateFormat(service!.updatedAt),
                                    style: whitishM14,
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (Responsive.isDesktop(context))
                      if (service!.serviceProviderStatus ==
                          ServiceStatus.pending)
                        viewRequestButton(service!.serviceProviderStatus)
                  ],
                ),
                if (!Responsive.isDesktop(context))
                  if (service!.serviceProviderStatus == ServiceStatus.pending &&
                      service!.userStatus == ServiceStatus.request)
                    viewRequestButton(service!.serviceProviderStatus),
                const SizedBox(
                  height: 8,
                )
              ],
            ),
          )
        : const SizedBox();
  }

  Widget viewRequestButton(flag) {
    return Padding(
      padding: EdgeInsets.all(Responsive.isDesktop(context) ? 4 : 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () async {
                await cancelRequest(service!.serviceRequestId);
              },
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: MyAppColor.greylight,
                  side: BorderSide(width: 1.0, color: MyAppColor.white)),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Responsive.isDesktop(context) ? 12.0 : 12.0),
                    child: Text(
                      'CANCEL REQUEST',
                      style: whiteDarkR12,
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  onPressedViewRequest(flag) {
    Navigator.pop(context);
  }

  partLeft1() {
    return Expanded(
        flex: 4,
        child: Padding(
          padding: const EdgeInsets.only(right: 80.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              flagAccordingColoredContainer(),
              container1(),
              const SizedBox(height: 5),
              servicePhotosContainer(),
              const SizedBox(
                height: 5,
              ),
              daysListContainer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                        '.   .   .   .   .   .   .   .   .   .   .   .   .   .'),
                  ],
                ),
              ),
              Container(
                color: MyAppColor.greynormal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ignore: prefer_const_constructors
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: Text(
                        'REVIEWS',
                        style: blackRegular16,
                      ),
                    ),
                  ],
                ),
              ),
              service!.serviceProviderStatus == ServiceStatus.completed &&
                      isReviewSubmitted == false
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Container(
                        color: MyAppColor.greynormal,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                color: MyAppColor.backgroundColor,
                                child: Row(
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // ignore: prefer_const_constructors
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      child: Text(
                                        'ADD REVIEWS',
                                        style: blackRegular16,
                                      ),
                                    ),
                                    ratingBar()
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: textfieldContainer(context,
                                    height: 100.0,
                                    control: reviewController,
                                    text: 'Type your review here...',
                                    maxlines: 6,
                                    topPadding: 4.0)),
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: submitButton(context)),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              const SizedBox(
                height: 10,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: reviewsContainerList()),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ));
  }

  serviceProviderGreyContainer() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ServiceProviderDetailsScreen(
                      id: service!.user!.id.toString(),
                    )));
      },
      child: Container(
        color: MyAppColor.greylight,
        margin: EdgeInsets.only(top: Responsive.isDesktop(context) ? 0 : 5.0),
        child: Padding(
          padding: Responsive.isDesktop(context)
              ? const EdgeInsets.all(8.0)
              : const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //VIEW DETAILS BUTTON
              Padding(
                padding:
                    EdgeInsets.all(Responsive.isDesktop(context) ? 0 : 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'SERVICE PROVIDER',
                      style: whitish12,
                    ),
                    Text('${service!.user!.name}', style: whitishM14)
                  ],
                ),
              ),
              // if (Responsive.isDesktop(context)) viewDeatils(),
              if (!Responsive.isDesktop(context))
                Container(
                  alignment: Alignment.center,
                  height: Responsive.isDesktop(context) ? 55 : 55,
                  color: MyAppColor.greylight,
                  child: Container(
                      margin: const EdgeInsets.fromLTRB(0.0, 10, 10, 10),
                      padding: const EdgeInsets.all(0.0),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(
                                  5.0) //                 <--- border radius here
                              ),
                          border: Border.all(color: MyAppColor.white)),
                      child: Image.asset(
                        'assets/forward_arrow.png',
                        color: MyAppColor.white,
                      )),
                ),
            ],
          ),
        ),
      ),
    );
  }

  container1() {
    return Column(children: [
      Container(
        // height: 100,
        color: MyAppColor.greynormal,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  runAlignment: WrapAlignment.center,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Image.asset(
                      'assets/maintenance_grey.png',
                      height: 10,
                      width: 10,
                    ),
                    if (service!.serviceCategories!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                            '${service?.serviceCategories!.first.categoryName}',
                            style: appleColorSemiBold12),
                      )
                  ],
                ),
                ratingBar(rate: service!.mean)
              ],
            ),
            SizedBox(
              height: !Responsive.isDesktop(context) ? 5 : 0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    !Responsive.isDesktop(context)
                        ? '${service!.serviceName}'
                        : '${service!.serviceName}',
                    style: !Responsive.isDesktop(context)
                        ? blackBold14
                        : blackBold18),
                !Responsive.isDesktop(context)
                    ? const SizedBox()
                    : Text('₹ ${service!.serviceCharge}', style: blackBold18)
              ],
            ),
            const SizedBox(
              height: 3,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  children: [
                    container(
                        text: 'AC', image: 'assets/setting.png', width: 60),
                    container(
                        text: 'Electrician',
                        image: 'assets/setting.png',
                        width: 110),
                    container(
                        text: 'AC', image: 'assets/setting.png', width: 60),
                    container(
                        text: '...', image: 'assets/setting.png', width: 40),
                  ],
                ),
                !Responsive.isDesktop(context)
                    ? const SizedBox()
                    : Text('Base Service Charge',
                        overflow: TextOverflow.clip, style: blackDarkSb12())
              ],
            ),
            SizedBox(
              height: !Responsive.isDesktop(context) ? 10 : 0,
            ),
            Responsive.isDesktop(context)
                ? const SizedBox()
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('₹ ${service!.serviceCharge}', style: blackBold14),
                    ],
                  ),
            Responsive.isDesktop(context)
                ? const SizedBox()
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Base Service Charge',
                          overflow: TextOverflow.clip, style: blackDarkSb12())
                    ],
                  ),
          ]),
        ),
      ),
      const SizedBox(height: 5),
      if (Responsive.isDesktop(context))
        widget.flag == null
            ? Container(
                color: MyAppColor.greynormal,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      !Responsive.isDesktop(context)
                          ? Align(
                              alignment: FractionalOffset.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      DynamicDropDownListOfFields(
                                        dropDownList: branches,
                                        label: '',
                                        selectingValue: null,
                                        setValue: null,
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: orangeButton(
                                          text: 'REQUEST HOME-SERVICE',
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : SizedBox()
                    ],
                  ),
                ),
              )
            : const SizedBox(),
      // if (!Responsive.isDesktop(context))
      service!.serviceProviderStatus == null
          ? Container(
              color: MyAppColor.greynormal,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DatePicker(
                      text: 'Service Date',
                      changeType: service!.serviceDays,
                      value: selectedTime,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year,
                          DateTime.now().month + 1, DateTime.now().day + 30),
                      onSelect: (value, showValue) {
                        selectedTime = value;
                        timeToSend = showValue;
                      },
                    ),
                    TextFormFieldWidget(
                        text: selectedBranch != null
                            ? 'Select Branch'
                            : 'Select Another Branch',
                        control: TextEditingController(
                            text: selectedBranch != null
                                ? selectedBranch!.shopName
                                : ''),
                        isRequired: false,
                        type: TextInputType.none,
                        onTap: () async {
                          await showBranchList(branches);
                          setState(() {});
                        }),
                    if (selectedBranch != null)
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(5),
                        child: BranchCard(
                          branch: selectedBranch!,
                        ),
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    orangeButton(
                      text: 'REQUEST HOME-SERVICE',
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox(),
      const SizedBox(height: 5),
      if (service!.userStatus == ServiceStatus.request &&
          (service!.serviceProviderStatus == ServiceStatus.completed ||
              service!.serviceProviderStatus == ServiceStatus.accepted))
        Container(
            color: MyAppColor.greynormal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //textf
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('CONTACT NO.', style: blackRegular12),
                            Text(
                              service!.user!.mobile ?? '',
                              style: blackMedium14,
                            )
                          ],
                        ),
                        //CALL SERVICE PROVIDER
                        if (Responsive.isDesktop(context))
                          CALL_SERVICE_PROVIDER()
                      ],
                    ),
                  ),
                ),
                //vie details
                // if (Responsive.isDesktop(context))
                //   Expanded(
                //     flex: 4,
                //     child: Container(
                //       color: MyAppColor.greylight,
                //       child: Padding(
                //         padding: const EdgeInsets.all(20.0),
                //         child: Row(
                //           crossAxisAlignment: CrossAxisAlignment.center,
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Padding(
                //               padding: EdgeInsets.all(
                //                   Responsive.isDesktop(context) ? 0 : 8.0),
                //               child: Column(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 mainAxisAlignment: MainAxisAlignment.start,
                //                 children: [
                //                   Text(
                //                     'SERVICE PROVIDER',
                //                     style: whitish12,
                //                   ),
                //                   Text('Bharat Services Co.', style: whitishM14)
                //                 ],
                //               ),
                //             ),
                //             viewDeatils(),
                //           ],
                //         ),
                //       ),
                //     ),
                //   )
              ],
            )),
      if (!Responsive.isDesktop(context) &&
          service!.userStatus == ServiceStatus.request &&
          (service!.serviceProviderStatus == ServiceStatus.completed ||
              service!.serviceProviderStatus == ServiceStatus.accepted))
        Container(
          color: MyAppColor.greynormal,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: CALL_SERVICE_PROVIDER(),
                ),
              ],
            ),
          ),
        ),
      if (!Responsive.isDesktop(context)) serviceProviderGreyContainer()
    ]);
  }

//
  daysListContainer() {
    return Container(
        color: MyAppColor.greynormal,
        width: Sizeconfig.screenWidth! / 2,
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'DAYS AVAILABLE IN A WEEK FOR BOOKING',
                        style: blackRegular12,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runAlignment: WrapAlignment.center,
                      alignment: WrapAlignment.start,
                      children: List.generate(
                          service!.serviceDays!.length,
                          (i) => Container(
                                alignment: Alignment.center,
                                height: 74,
                                width: 95,
                                color: MyAppColor.grayplane,
                                child: Text(
                                  service!.serviceDays![i].dayName.toString(),
                                  style: greenMedium14,
                                  textAlign: TextAlign.center,
                                ),
                              ))),
                ])));
  }

  servicePhotosContainer() {
    return Container(
        color: MyAppColor.greynormal,
        width: Sizeconfig.screenWidth! / 2,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'SERVICE PHOTOS',
                    style: blackRegular12,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runAlignment: WrapAlignment.center,
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  runSpacing: 20,
                  children: List.generate(
                      service!.serviceImages!.length,
                      (index) => Image.network(
                            currentUrl(service!.serviceImages![index].image),
                            width: Responsive.isDesktop(context) ? 160 : 140,
                            height: Responsive.isDesktop(context) ? 160 : 140,
                          ))),
            ],
          ),
        ));
  }

//

  viewDeatils() {
    return OutlinedButton(
        onPressed: () {},
        style:
            OutlinedButton.styleFrom(side: BorderSide(color: MyAppColor.white)),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'VIEW DETAILS',
                style: whiteRegularGalano12,
              ),
            ),
          ],
        ));
  }

//CALL SERVICE PROVIDER
  CALL_SERVICE_PROVIDER() {
    return ElevatedButton(
        onPressed: () async {
          await FlutterPhoneDirectCaller.callNumber(service!.user!.mobile!);
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: service!.serviceProviderStatus == ServiceStatus.pending
              ? MyAppColor.greylight
              : MyAppColor.greylightOpacity,
        ),
        child: Row(
          children: [
            Container(
              // color: MyAppColor.greylightOpacity,
              // width: Responsive.isDesktop(context)
              //     ? null
              //     : Sizeconfig.screenWidth! / 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Wrap(
                  children: [
                    Icon(Icons.call, size: 15),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'CALL SERVICE PROVIDER',
                      style: whiteRegularGalano12,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  reviewsContainerList() {
    return Consumer(builder: (context, ref, child) {
      RateService? rateServiceData =
          ref.watch(serviceProviderData).rateServiceData;
      List<RatingServices> rateService =
          ref.watch(serviceProviderData).rateService;
      return Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          if (rateServiceData != null)
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Responsive.isDesktop(context) ? 10 : 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            right: Responsive.isDesktop(context) ? 5 : 5),
                        child: Container(
                            height: Responsive.isDesktop(context) ? 60 : 60,
                            color: MyAppColor.greynormal,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ratingBar(
                                      rate: double.parse(
                                          rateServiceData.mean.toString())),
                                  Text(
                                      '${rateServiceData.mean} ' +
                                          LabelString.rating,
                                      style: blackDark12,
                                      textAlign: TextAlign.center)
                                ],
                              ),
                            )),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: Responsive.isDesktop(context) ? 5 : 0),
                        child: Container(
                            color: MyAppColor.greynormal,
                            height: Responsive.isDesktop(context) ? 60 : 60,
                            child: Padding(
                              padding: EdgeInsets.all(
                                  Responsive.isDesktop(context) ? 10 : 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${rateService.length}',
                                    textAlign: TextAlign.center,
                                    style: Responsive.isDesktop(context)
                                        ? blackBold16
                                        : blackBold16,
                                  ),
                                  Text('Total no. of Reviews',
                                      style: blackDark12,
                                      textAlign: TextAlign.center)
                                ],
                              ),
                            )),
                      ),
                    ),
                  ]),
            ),
          //
          SizedBox(
            height: 20,
          ),
          Wrap(
              children: List.generate(rateService.length,
                  (index) => reviewList(rateService[index])))
        ],
      );
    });
  }

  reviewList(RatingServices ratingServices) {
    return Padding(
      padding: Responsive.isDesktop(context)
          ? const EdgeInsets.all(8)
          : const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        color: MyAppColor.greynormal,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage:
                        NetworkImage(currentUrl(ratingServices.user!.image)),
                  )
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('${ratingServices.user!.name}',
                      style: Responsive.isDesktop(context)
                          ? blackBold20
                          : blackBold16),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                      '${formatDate(ratingServices.updatedAt)} | ${formatTime(ratingServices.updatedAt)}',
                      style: blackDark12),
                  const SizedBox(
                    height: 10,
                  ),
                  ratingBar(rate: double.parse(ratingServices.star.toString())),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${ratingServices.comment}",
                    style: Responsive.isDesktop(context)
                        ? blackRegular14
                        : blackRegular14,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  onClickRequest() async {
    if (selectedTime == null) {
      showSnack(
          context: context,
          msg: "Please select date of service first",
          type: 'error');
    }
    if (selectedBranch == null) {
      showSnack(
          context: context,
          msg: "Please select branch of service ",
          type: 'error');
    }
    ApiResponse response = await requestService(context,
        status: 'REQUEST',
        serviceId: service!.id,
        branchId: selectedBranch!.id,
        serviceDate: timeToSend);
    if (response.status == 200) {
      service!.serviceProviderStatus = ServiceStatus.pending;
      service!.userStatus = ServiceStatus.request;
      await getServiceById(
          serviceId: service!.id, serviceRequestId: response.body!.data['id']);
      setState(() {});
    } else {}
  }

  Widget orangeButton({text}) {
    return Row(
      crossAxisAlignment: !Responsive.isDesktop(context)
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.end,
      mainAxisAlignment: !Responsive.isDesktop(context)
          ? MainAxisAlignment.center
          : MainAxisAlignment.end,
      children: [
        ElevatedButton(
            onPressed: () => onClickRequest(),
            style: ElevatedButton.styleFrom(
                elevation: 0, primary: MyAppColor.orangelight
                // : !Responsive.isDesktop(context)
                //     ? MyAppColor.greylightOpacity
                //     : MyAppColor.greylightOpacity,
                ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    text,
                    style: whiteRegularGalano12,
                  ),
                ),
              ],
            )),
      ],
    );
  }

  Widget _viewAll() {
    return OutlinedButton(
      onPressed: () {},
      child: Container(
          alignment: Alignment.center,
          width: 110,
          child: const Text(
            "VIEW ALL",
            style: TextStyle(
              color: Colors.black,
            ),
          )),
      style:
          OutlinedButton.styleFrom(side: const BorderSide(color: Colors.black)),
    );
  }

  showBranchList(List<Branch> branches) {
    final theme = Theme.of(context);
    return showDialog(
        context: context,
        builder: (cont) => Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            color: MyAppColor.backgroundColor.withOpacity(0.3),
            alignment: Alignment.center,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                color: MyAppColor.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(getCapitalizeString("Select Branch"),
                              style: blackDarkSemiBold16),
                          InkWell(
                            onTap: () {
                              Navigator.pop(cont, false);
                            },
                            child: Icon(
                              Icons.cancel,
                              size: 20,
                              color: theme.indicatorColor,
                            ),
                          )
                        ]),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: ListView(
                        children: List.generate(
                            branches.length,
                            (index) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                      onTap: () {
                                        selectedBranch = branches[index];
                                        Navigator.pop(cont, true);
                                      },
                                      child:
                                          BranchCard(branch: branches[index])),
                                )),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(cont);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: MyAppColor.orangelight,
                        ),
                        child: Text(
                          'Done',
                          style: whiteRegularGalano12,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )));
  }

//
  latestHomeServiceListViewItemWidget() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeServiceViewScreen(
                      serviceId: '1',
                    )));
      },
      child: Padding(
        padding: Responsive.isDesktop(context)
            ? const EdgeInsets.all(0.0)
            : const EdgeInsets.all(0.0),
        child: Container(
          width: !Responsive.isDesktop(context)
              ? Sizeconfig.screenWidth!
              : Sizeconfig.screenWidth!,
          color: MyAppColor.greynormal,
          child: Column(
            children: [
              //menu row
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => const AddAServiceScreen()));
                    },
                    child: Container(
                        color: MyAppColor.grayplane,
                        child: Image.asset('assets/menus.png')),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    //for image
                    Column(
                      children: [
                        Image.asset('assets/photo.png', height: 100, width: 100)
                      ],
                    ),
                    const SizedBox(width: 8), //for rating and all
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Wrap(
                                children: [
                                  Image.asset('assets/maintenance_grey.png'),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Image.asset('assets/orange_lock_small.png'),
                                ],
                              ),
                              ratingBar()
                            ],
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                    'Air Conditioning Fitting,\nService & Repair',
                                    overflow: TextOverflow.clip,
                                    style: Responsive.isDesktop(context)
                                        ? blackDarkSemiBold16
                                        : blackDarkSemiBold16),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Bharat Services Co.',
                                style: appleColorM12,
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      children: [
                        container(
                            text: 'AC', image: 'assets/setting.png', width: 60),
                        container(
                            text: 'Electrician',
                            image: 'assets/setting.png',
                            width: 110),
                        container(text: '...', width: 30),
                      ],
                    ),
                    Text('599.0',
                        overflow: TextOverflow.clip, style: BlackDarkSb18())
                  ],
                ),
              ),
              // const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Wrap(
                        children: [
                          Image.asset('assets/location_icon.png'),
                          Text(
                            'Bhopal,Madhya Pradesh ',
                            style: !Responsive.isDesktop(context)
                                ? blackDarkSb10()
                                : blackDarkSb10(),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeServiceViewScreen(
                                      serviceId: '1',
                                    )));
                      },
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text('Book a service ',
                              style: !Responsive.isDesktop(context)
                                  ? orangeDarkSb10()
                                  : orangeDarkSb10()),
                          Image.asset(
                            'assets/forward_arrow.png',
                            color: MyAppColor.orangedark,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget container({text, double? width, image}) {
    return Parallelogram(
      cutLength: 5.0,
      edge: Edge.RIGHT,
      child: Container(
        color: MyAppColor.greylight,
        width: width,
        height: 23.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Image.asset(image),
                  )
                : const SizedBox(),
            Center(child: Text(text, style: whiteDarkR10)),
          ],
        ),
      ),
    );
  }

  ratingBar({rate}) {
    return RatingBar.builder(
      initialRating: double.parse(((rate ?? 0).toString())),
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      unratedColor: MyAppColor.white,
      itemCount: 5,
      itemSize: 18.0,
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        if (rate == null) {
          setState(() {
            _rating = rating;
          });
        }
      },
      updateOnDrag: rate == null ? true : false,
    );
  }

  textfieldContainer(context,
      {text, maxlines, height, topPadding, bottomPadding, control}) {
    return Container(
      height: height ?? 30,
      color: MyAppColor.white,
      margin: EdgeInsets.only(top: 20),
      width: Responsive.isDesktop(context)
          ? Sizeconfig.screenWidth! / 4.5
          : Sizeconfig.screenWidth!,
      child: TextFormField(
        controller: control,
        onTap: () {},
        style: blackDarkM14(),
        maxLines: maxlines ?? 1,
        // onChanged: (value) =>
        //     onChanged != null ? onChanged!(value) : {},
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            // width: 0.0 produces a thin "hairline" border
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            borderSide: BorderSide.none,
            //borderSide: const BorderSide(),
          ),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.only(
              top: topPadding ?? 0,
              left: 8,
              right: 0,
              bottom: bottomPadding ?? 20),
          fillColor: Colors.white,
          filled: true,
          hintText: text,

          hintStyle: !Responsive.isDesktop(context)
              ? blackDarkO40M14
              : blackMediumGalano12,
          // labelText: "$text",
          // labelStyle:
          //     !Responsive.isDesktop(context) ? blackDarkO40M14 : blackDarkO40M12,
        ),
      ),
    );
  }

  selectCategoryDropdown() {
    return DynamicDropDownListOfFields(
        label: DropdownString.category,
        dropDownList: catogaries,
        selectingValue: selectedCategory,
        setValue: (value) {
          if (DropdownString.category != value) {
            selectedCategory =
                catogaries.firstWhere((element) => element.name == value);
          }
        });
  }

  serviceChargeDropdown() {
    return DynamicDropDownListOfFields(
        label: "Service Charge",
        dropDownList: serviceChargeList,
        selectingValue: selectedServiceChargeList,
        setValue: (value) {
          if ('Service Charge' != value) {
            selectedServiceChargeList = serviceChargeList
                .firstWhere((element) => element.name == value);
          }
        });
  }
}
//
