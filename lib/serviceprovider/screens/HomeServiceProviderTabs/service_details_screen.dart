// ignore_for_file: unused_import, import_of_legacy_library_into_null_safe, prefer_const_literals_to_create_immutables, must_be_immutable, sized_box_for_whitespace, prefer_const_constructors, unused_element, unused_local_variable, avoid_unnecessary_containers, prefer_final_fields, unnecessary_null_comparison

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/candidateWidget/hash_tag_widget.dart';
import 'package:hindustan_job/candidate/model/serviceProviderModal/alldata_get_modal.dart';
import 'package:hindustan_job/candidate/model/serviceProviderModal/rate_service.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/label_string.dart';
import 'package:hindustan_job/serviceprovider/screens/HomeServiceProviderTabs/add_a_service_screen.dart';
import 'package:hindustan_job/serviceprovider/screens/HomeServiceProviderTabs/my_profile.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import '../../../candidate/header/back_text_widget.dart';
import '../../../candidate/pages/job_seeker_page/home/drawer/drawer_jobseeker.dart';
import '../../../candidate/pages/job_seeker_page/home/homeappbar.dart';
import '../../../services/api_service_serviceProvider/service_provider.dart';
import '../../../services/services_constant/response_model.dart';
import '../../../widget/common_app_bar_widget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:clippy_flutter/clippy_flutter.dart';

class ServiceDetailsScreen extends ConsumerStatefulWidget {
  AllServiceFetch allservice;
  String? serviceId;
  ServiceDetailsScreen({Key? key, required this.allservice, this.serviceId})
      : super(key: key);

  @override
  _ServiceDetailsScreenState createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends ConsumerState<ServiceDetailsScreen>
    with SingleTickerProviderStateMixin {
  var listOfDays = [
    LabelString.monday,
    //  LabelString.tuesday,     //
    LabelString.wednesday,
    LabelString.thursday,
    LabelString.friday,
    LabelString.sunday
  ];
  var listOfDaysLetters = [
    LabelString.m,
    LabelString.w,
    LabelString.t,
    LabelString.f,
    LabelString.s
  ];
  bool? _value = false;
  List<bool?>? _isChecked;
  int selectedTabIndex = 0;
  bool? isSwitched;

  final List<Widget> myTabs = [
    Tab(text: 'Service Details'),
    Tab(text: 'Client Review'),
  ];

  TabController? _tabController;
  int _tabIndex = 0;

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    ref
        .read(serviceProviderData)
        .rate(widget.serviceId ?? widget.allservice.id.toString());
    getServiceDetails(widget.serviceId ?? widget.allservice.id);
    _tabController = TabController(length: 2, vsync: this);
    _tabController!.addListener(_handleTabSelection);
    super.initState();
    _isChecked = List<bool>.filled(listOfDaysLetters.length, false);
    ref.read(serviceProviderData).getAlldataservice();
  }

  _handleTabSelection() {
    if (_tabController!.indexIsChanging) {
      setState(() {
        _tabIndex = _tabController!.index;
      });
    }
  }

  AllServiceFetch? fetchedService;
  getServiceDetails(id) async {
    ApiResponse response = await getService(id: id);
    if (response.status == 200) {
      fetchedService = AllServiceFetch.fromJson(response.body!.data);
      isSwitched = fetchedService!.serviceStatus == "Y" ? true : false;
      setState(() {});
    }
  }

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColor.backgroundColor,
      key: _drawerKey,
      drawer: Drawer(
        child: DrawerJobSeeker(),
      ),
      appBar: !kIsWeb
          ? PreferredSize(
              child: BackWithText(
                  text: "HOME (HOME-SERVICE-PROVIDER) / SERVICE DETAILS"),
              preferredSize: Size.fromHeight(50))
          : PreferredSize(
              preferredSize:
                  Size.fromHeight(Responsive.isDesktop(context) ? 140 : 150),
              child: CommomAppBar(
                drawerKey: _drawerKey,
              ),
            ),
      body: Column(
        children: [
          SingleChildScrollView(
            child: Container(
              height: Responsive.isDesktop(context)
                  ? MediaQuery.of(context).size.height - 140
                  : MediaQuery.of(context).size.height - 214,
              child: ListView(
                children: <Widget>[
                  if (Responsive.isDesktop(context))
                    SizedBox(
                      height: 30,
                    ),
                  Responsive.isDesktop(context)
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 80),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  child: Center(
                                    child: TabBar(
                                      controller: _tabController,
                                      labelColor: Colors.black,
                                      isScrollable: true,
                                      tabs: myTabs,
                                      indicatorWeight: 2,
                                      indicatorColor: MyAppColor.orangelight,
                                      labelStyle: blackBold14,
                                    ),
                                  ),
                                ),
                              ),
                              _tabIndex != 1
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 10),
                                      child: Container(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddAServiceScreen(
                                                      allservice:
                                                          fetchedService,
                                                    ),
                                                  ),
                                                );
                                                getServiceDetails(
                                                    widget.serviceId ??
                                                        widget.allservice.id);
                                              },
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                      'assets/edit_small_icon.png'),
                                                  Text('edit service',
                                                      style:
                                                          orangeDarkSemibold12),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15.0,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          Container(
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(.3),
                                                          offset: const Offset(
                                                            5.0,
                                                            5.0,
                                                          ),
                                                          blurRadius: 8.0,
                                                        ),
                                                      ],
                                                    ),
                                                    child: AlertDialog(
                                                      backgroundColor:
                                                          MyAppColor
                                                              .backgroundColor,
                                                      elevation: 10,
                                                      title: Text(
                                                        "Do You want Delete ?",
                                                        style: TextStyle(
                                                            color: MyAppColor
                                                                .blackdark,
                                                            fontSize: 18),
                                                      ),
                                                      content: Text("Added",
                                                          style: TextStyle(
                                                              color: MyAppColor
                                                                  .blackdark)),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  'Cancel'),
                                                          child: Text(
                                                            'No',
                                                            style: TextStyle(
                                                                color: MyAppColor
                                                                    .blackdark),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            await ref
                                                                .read(
                                                                    serviceProviderData)
                                                                .alldeleteServiceData(
                                                                    widget
                                                                        .allservice
                                                                        .id,
                                                                    context);

                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text('Yes',
                                                              style: TextStyle(
                                                                  color: MyAppColor
                                                                      .blackdark)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                      'assets/delete.png'),
                                                  Text('delete service',
                                                      style:
                                                          orangeDarkSemibold12)
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: Responsive.isDesktop(context)
                                ? MediaQuery.of(context).size.width - 1000
                                : MediaQuery.of(context).size.width - 100,
                            child: Center(
                              child: TabBar(
                                controller: _tabController,
                                labelColor: Colors.black,
                                isScrollable: true,
                                tabs: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Tab(text: 'Service Details'),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Tab(text: 'Client Review'),
                                  ),
                                ],
                                indicatorWeight: 2,
                                indicatorColor: MyAppColor.orangelight,
                                labelStyle: blackBold14,
                              ),
                            ),
                          ),
                        ),
                  Center(
                    child: [
                      Column(
                        children: [
                          if (!Responsive.isDesktop(context))
                            _tabIndex != 1
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 10),
                                    child: Container(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddAServiceScreen(
                                                    allservice: fetchedService,
                                                  ),
                                                ),
                                              );
                                              getServiceDetails(
                                                  widget.serviceId ??
                                                      widget.allservice.id);
                                            },
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                    'assets/edit_small_icon.png'),
                                                Text('edit service',
                                                    style:
                                                        orangeDarkSemibold12),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15.0,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              showDialog<String>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(.3),
                                                        offset: const Offset(
                                                          5.0,
                                                          5.0,
                                                        ),
                                                        blurRadius: 8.0,
                                                      ),
                                                    ],
                                                  ),
                                                  child: AlertDialog(
                                                    backgroundColor: MyAppColor
                                                        .backgroundColor,
                                                    elevation: 10,
                                                    title: Text(
                                                      "Do You want Delete ?",
                                                      style: TextStyle(
                                                          color: MyAppColor
                                                              .blackdark,
                                                          fontSize: 18),
                                                    ),
                                                    content: Text("Added",
                                                        style: TextStyle(
                                                            color: MyAppColor
                                                                .blackdark)),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context,
                                                                'Cancel'),
                                                        child: Text(
                                                          'No',
                                                          style: TextStyle(
                                                              color: MyAppColor
                                                                  .blackdark),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          await ref
                                                              .read(
                                                                  serviceProviderData)
                                                              .alldeleteServiceData(
                                                                  widget
                                                                      .allservice
                                                                      .id,
                                                                  context);

                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text('Yes',
                                                            style: TextStyle(
                                                                color: MyAppColor
                                                                    .blackdark)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                    'assets/delete.png'),
                                                Text('delete service',
                                                    style: orangeDarkSemibold12)
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          fetchedService != null
                              ? serviceDetailsTab()
                              : loaderIndicator(context),
                          Footer()
                        ],
                      ),
                      Column(
                        children: [clientReviewsTab(), Footer()],
                      ),
                    ][_tabIndex],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  clientReviewsTab() {
    return Consumer(builder: (context, ref, child) {
      List<RatingServices> rateService =
          ref.watch(serviceProviderData).rateService;
      RateService? rateServiceData =
          ref.watch(serviceProviderData).rateServiceData;
      return Column(
        children: [
          SizedBox(
            height: Responsive.isDesktop(context) ? 30 : 20,
          ),
          rateServiceData != null
              ? Container(
                  width: Responsive.isDesktop(context)
                      ? MediaQuery.of(context).size.width - 760
                      : MediaQuery.of(context).size.width - 20,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: Responsive.isDesktop(context) ? 12.0 : 0,
                                right: Responsive.isDesktop(context) ? 5 : 5),
                            child: Container(
                                // height: Responsive.isDesktop(context) ? 45 : 60,
                                color: MyAppColor.greynormal,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ratingBar(all: rateServiceData.mean),
                                      Text(
                                          '  ${rateServiceData.mean} ' +
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
                                right: Responsive.isDesktop(context) ? 12.0 : 0,
                                left: Responsive.isDesktop(context) ? 5 : 5),
                            child: Container(
                                color: MyAppColor.greynormal,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${rateServiceData.count}',
                                        textAlign: TextAlign.center,
                                        style: blackBold20,
                                      ),
                                      Text(
                                        'Total no. of Reviews',
                                        style: blackDark12,
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ]),
                )
              : SizedBox(),
          SizedBox(
            height: Responsive.isDesktop(context) ? 10 : 20,
          ),
          Column(
              children: List.generate(
            rateService.length,
            (index) => Column(
              children: [
                clientReviewMobileViewList(rateService, index)
                //
                // Responsive.isDesktop(context)
                //     ? Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 10),
                //         child: Column(
                //           children: List.generate(
                //               50, (index) => clientREviewWindoesView()).toList(),
                //         ),
                //       )
                //     : Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 10),
                //         child: Column(
                //           children: List.generate(
                //               50, (index) => clientReviewMobileViewList()).toList(),
                //         ),
                //       ),
              ],
            ),
          )),
        ],
      );
    });
  }

  Widget clientREviewWindoesView() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        color: MyAppColor.greynormal,
        // height: Responsive.isDesktop(context) ? 200 : 300,
        width: Responsive.isDesktop(context)
            ? MediaQuery.of(context).size.width - 780
            : MediaQuery.of(context).size.width - 20,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 25,
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
                  Text('John Kumar Cena', style: blackBold20),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('26.04.2021 | 10:30 am', style: blackDark12),
                  const SizedBox(
                    height: 10,
                  ),
                  ratingBar(),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    Responsive.isDesktop(context)
                        ? 'The quick, brown fox jumps over a lazy dog. DJs flock by when MTV ax quiz prog. \nJunk MTV quiz graced by fox whelps. Bawds jog, flick quartz, vex nymphs. Waltz, \nbad nymph, for quick jigs vex! Fox nymphs.'
                        : 'The quick, brown fox jumps over\n a lazy dog. DJs flock by \nwhen MTV ax quiz prog. Junk \nMTV quiz graced by fox whelps.\nBawds jog, flick quartz, vex \nnymphs. Waltz, bad nymph, for\nquick jigs vex! Fox nymphs.',
                    style: Responsive.isDesktop(context)
                        ? blackRegular16
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

  Widget clientReviewMobileViewList(
      List<RatingServices> rateService, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 5, horizontal: Responsive.isDesktop(context) ? 20 : 0),
      child: Container(
        color: MyAppColor.greynormal,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Column(
                children: [
                  CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 25,
                      child: Image.network(
                        "${currentUrl(rateService[index].user!.image)}",
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Image.asset(
                            'assets/profileIcon.png',
                            height: 36,
                            width: 36,
                            fit: BoxFit.cover,
                          );
                        },
                      )),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(rateService[index].user!.name.toString(),
                      style: blackBold20),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                      '${formatDate(rateService[index].updatedAt)} | ${formatTime(rateService[index].updatedAt)}',
                      style: blackDark12),
                  const SizedBox(
                    height: 10,
                  ),
                  ratingBar(all: rateService[index].star),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    Responsive.isDesktop(context)
                        ? '${rateService[index].comment}'
                        : '${rateService[index].comment}',
                    style: Responsive.isDesktop(context)
                        ? blackRegular16
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

  serviceDetailsTab() {
    return Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignmentMA
        children: [
          if (Responsive.isDesktop(context))
            SizedBox(
              height: 30,
            ),
          Container(
            width: Responsive.isDesktop(context)
                ? MediaQuery.of(context).size.width - 760
                : MediaQuery.of(context).size.width - 20,
            height: 40,
            color: MyAppColor.greynormal,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Status: ', style: blackMedium14),
                      Text(
                          fetchedService!.serviceStatus != "N"
                              ? 'Active'
                              : 'DeActive',
                          style: blackBold16),
                    ],
                  ),
                  Center(
                    child: Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        value:
                            fetchedService!.serviceStatus == "Y" ? true : false,
                        onChanged: (value) async {
                          isSwitched = value;
                          ApiResponse response = await updateServiceStatus(
                              status: value ? 'Y' : "N",
                              id: fetchedService!.id);

                          if (response.status == 200) {
                            isSwitched = value;
                            if (value) {
                              fetchedService!.serviceStatus = 'Y';
                            } else {
                              fetchedService!.serviceStatus = 'N';
                            }
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text('.   .   .   .   .   .   .   .   .   .   .   .   .'),
          const SizedBox(
            height: 30,
          ),
          Container(
            /// width: Responsive.isDesktop(context) ? 770 : 332,
            width: Responsive.isDesktop(context)
                ? MediaQuery.of(context).size.width - 760
                : MediaQuery.of(context).size.width - 20,
            height: 40,
            color: MyAppColor.greyDark,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    child: Text(
                  LabelString.serviceDetails,
                )),
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
            width: Responsive.isDesktop(context)
                ? MediaQuery.of(context).size.width - 760
                : MediaQuery.of(context).size.width - 20,
            height: Responsive.isDesktop(context) ? 60 : 80,
            color: MyAppColor.greynormal,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    LabelString.serviceName,
                    style: black12,
                  ),
                  Text(fetchedService!.serviceName.toString(),
                      style: Responsive.isDesktop(context)
                          ? blackBold18
                          : blackBold14),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            /// width: Responsive.isDesktop(context) ? 770 : 332,
            width: Responsive.isDesktop(context)
                ? MediaQuery.of(context).size.width - 760
                : MediaQuery.of(context).size.width - 20,
            height: Responsive.isDesktop(context) ? 60 : 90,
            color: MyAppColor.greynormal,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(LabelString.selectCategories, style: black12),
                  SizedBox(
                    height: 3,
                  ),
                  Responsive.isDesktop(context)
                      ? Wrap(
                          children: List.generate(
                            fetchedService!.serviceCategories!.length,
                            (index) => HashTag(
                              text: fetchedService!
                                      .serviceCategories![index].name ??
                                  '',
                            ),
                          ),
                        )
                      : fetchedService!.serviceCategories != null
                          ? Wrap(
                              children: List.generate(
                                fetchedService!.serviceCategories!.length,
                                (index) => HashTag(
                                  text: fetchedService!
                                          .serviceCategories![index].name ??
                                      '',
                                ),
                              ),
                            )
                          : SizedBox()
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            /// width: Responsive.isDesktop(context) ? 770 : 332,
            width: Responsive.isDesktop(context)
                ? MediaQuery.of(context).size.width - 760
                : MediaQuery.of(context).size.width - 20,
            height: Responsive.isDesktop(context) ? 65 : 80,
            color: MyAppColor.greynormal,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(LabelString.serviceCharge, style: black12),
                  Text(fetchedService!.serviceCharge.toString(),
                      style: blackBold18),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text('.   .   .   .   .   .   .   .   .   .   .   .   .'),
          const SizedBox(
            height: 20,
          ),
          Container(
              width: Responsive.isDesktop(context)
                  ? MediaQuery.of(context).size.width - 760
                  : MediaQuery.of(context).size.width - 20,
              height: 40,
              color: MyAppColor.greyDark,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(LabelString.servicePhotos),
                ],
              )),
          const SizedBox(
            height: 20,
          ),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(
              fetchedService!.serviceImages!.length,
              (i) {
                return Container(
                  alignment: Alignment.center,
                  height: 170,
                  width: 170,
                  color: MyAppColor.greynormal,
                  child: Image.network(
                    currentUrl(
                      fetchedService!.serviceImages![i].image.toString(),
                    ),
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          Text('.   .   .   .   .   .   .   .   .   .   .   .   .'),
          SizedBox(
            height: 20,
          ),
          Container(
              width: Responsive.isDesktop(context)
                  ? MediaQuery.of(context).size.width - 760
                  : MediaQuery.of(context).size.width - 20,
              height: Responsive.isDesktop(context) ? 40 : 60,
              color: MyAppColor.greyDark,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Responsive.isDesktop(context)
                        ? LabelString.daysAvailableInWeekForBooking
                        : LabelString.daysAvailableInWeekForBookingMobile,
                    textAlign: TextAlign.center,
                  )
                ],
              )),
          SizedBox(
            height: Responsive.isDesktop(context) ? 20 : 10,
          ),
          SizedBox(
              height: Responsive.isDesktop(context) ? 160 : 200,
              width: Responsive.isDesktop(context)
                  ? MediaQuery.of(context).size.width - 760
                  : MediaQuery.of(context).size.width - 20,
              child: Padding(
                padding: EdgeInsets.only(
                  left: Responsive.isDesktop(context) ? 80.0 : 0,
                  right: Responsive.isDesktop(context) ? 80 : 0,
                ),
                child: GridView.count(
                  crossAxisCount: Responsive.isDesktop(context) ? 5 : 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  children: List.generate(
                    fetchedService!.serviceDays!.length,
                    (i) {
                      return Container(
                        alignment: Alignment.center,
                        color: MyAppColor.greynormal,
                        child: Text(
                          fetchedService!.serviceDays![i].dayName.toString(),
                          style: grey12,
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ),
              )),
          SizedBox(
            height: Responsive.isDesktop(context) ? 20 : 40,
          ),
        ]);
  }

  Widget backButtonContainer() {
    return Container(
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
              Text(LabelString.homeMyServicesAddServices, style: greyMedium10)
            ],
          )
        ],
      ),
    );
  }

  Widget _tabSection(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      height: Responsive.isDesktop(context)
          ? MediaQuery.of(context).size.height * 2.2
          : MediaQuery.of(context).size.height * 3.66,
      child: DefaultTabController(
        length: 2,
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
              // mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Responsive.isDesktop(context)
                    ? Padding(
                        padding: EdgeInsets.only(
                            left: Responsive.isDesktop(context) ? 90.0 : 10,
                            right: Responsive.isDesktop(context) ? 90 : 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: Responsive.isDesktop(context)
                                  ? MediaQuery.of(context).size.width - 1000
                                  : MediaQuery.of(context).size.width - 100,
                              child: TabBar(

                                  /// controller: tabController,
                                  onTap: (value) {
                                    setState(() {
                                      selectedTabIndex = value;
                                    });
                                  },
                                  isScrollable: true,
                                  labelColor: Colors.black,
                                  indicatorWeight: 2,
                                  indicatorColor: MyAppColor.orangelight,
                                  labelStyle: blackBold14 //For Selected tab
                                  /// unselectedLabelStyle: //F
                                  ,
                                  tabs: [
                                    Container(
                                        width: 120,
                                        child:
                                            const Tab(text: "Service Details")),
                                    Container(
                                      width: 120,
                                      child: const Tab(
                                        text: "Client Reviews",
                                      ),
                                    ),

                                    /// Tab(text: "User"),
                                  ]),
                            ),
                            selectedTabIndex != 1
                                ? Container(
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            'assets/edit_small_icon.png'),
                                        Text('edit service',
                                            style: orangeDarkSemibold12),
                                        const SizedBox(
                                          width: 15.0,
                                        ),
                                        Image.asset('assets/delete.png'),
                                        Text('delete service',
                                            style: orangeDarkSemibold12)
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(
                            left: Responsive.isDesktop(context) ? 90.0 : 0,
                            right: Responsive.isDesktop(context) ? 90 : 0),
                        child: Column(
                          ///  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: Responsive.isDesktop(context)
                                  ? MediaQuery.of(context).size.width - 1000
                                  : MediaQuery.of(context).size.width,
                              child: TabBar(
                                  onTap: (value) {
                                    setState(() {
                                      selectedTabIndex = value;
                                    });
                                  },
                                  isScrollable: true,
                                  labelColor: Colors.black,
                                  indicatorWeight: 2,
                                  indicatorColor: MyAppColor.orangelight,
                                  labelStyle: blackBold14,
                                  tabs: [
                                    Container(
                                        //width: 120,
                                        child:
                                            const Tab(text: "Service Details")),
                                    Container(
                                      /// width: 120,
                                      child: const Tab(
                                        text: "Client Reviews",
                                      ),
                                    ),
                                  ]),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            selectedTabIndex != 1
                                ? Container(
                                    child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Image.asset('assets/edit_small_icon.png'),
                                      Text('edit service',
                                          style: orangeDarkSemibold12),
                                      const SizedBox(
                                        width: 15.0,
                                      ),
                                      Image.asset('assets/delete.png'),
                                      Text('delete service',
                                          style: orangeDarkSemibold12),
                                      const SizedBox(
                                        width: 15.0,
                                      ),
                                    ],
                                  ))
                                : const SizedBox(),
                            const SizedBox(height: 30)
                          ],
                        ),
                      ),
                Container(
                  //Add this to give height
                  height: Responsive.isDesktop(context)
                      ? MediaQuery.of(context).size.height * 1.9
                      : MediaQuery.of(context).size.height * 3.5,
                  child: TabBarView(children: [
                    Container(
                      height: Responsive.isDesktop(context)
                          ? MediaQuery.of(context).size.height * 2.2
                          : MediaQuery.of(context).size.height * 3,
                      child:
                          // if (!Responsive.isDesktop(context))
                          //   bottomGreyContainer(),

                          //  if (!Responsive.isDesktop(context))
                          Container(
                        height: Responsive.isDesktop(context) ? 50 : 50,
                        color: MyAppColor.normalblack,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  'Designed by Akash Divya, HackerKernel with',
                                  style: greyRegular12,
                                ),
                                Image.asset('assets/heart.png',
                                    height: 20, width: 20)
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ]),
                ),
                //second Tab
                clientReviewTab()
              ]),
        ),
      ),
    ));
  }

  Widget container({text, double? width}) {
    return Parallelogram(
      cutLength: 7.0,
      edge: Edge.RIGHT,
      child: Container(
        color: MyAppColor.greylight,
        width: width,
        height: 25.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Image.asset('assets/setting.png'),
            ),
            Center(child: Text(text, style: whiteBoldGalano12)),
          ],
        ),
      ),
    );
  }

  clientReviewTab() {
    return Container(
      height: Responsive.isDesktop(context)
          ? MediaQuery.of(context).size.height * 3.1
          : MediaQuery.of(context).size.height * 4.4,
      width: Responsive.isDesktop(context)
          ? MediaQuery.of(context).size.width - 760
          : MediaQuery.of(context).size.width - 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        //checcck
        children: [
          Responsive.isDesktop(context)
              ? Container(
                  height: Responsive.isDesktop(context)
                      ? MediaQuery.of(context).size.height * 1.6
                      : MediaQuery.of(context).size.height * 1.1,
                  width: Responsive.isDesktop(context)
                      ? MediaQuery.of(context).size.width - 770
                      : MediaQuery.of(context).size.width - 20,
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            color: MyAppColor.greynormal,
                            height: Responsive.isDesktop(context) ? 200 : 300,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      const CircleAvatar(
                                        backgroundColor: Colors.red,
                                        radius: 25,
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('John Kumar Cena',
                                          style: blackBold20),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text('26.04.2021 | 10:30 am',
                                          style: blackDark12),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      // ratingBar(all: ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        Responsive.isDesktop(context)
                                            ? 'The quick, brown fox jumps over a lazy dog. DJs flock by when MTV ax quiz prog. \nJunk MTV quiz graced by fox whelps. Bawds jog, flick quartz, vex nymphs. Waltz, \nbad nymph, for quick jigs vex! Fox nymphs.'
                                            : 'The quick, brown fox jumps over\n a lazy dog. DJs flock by \nwhen MTV ax quiz prog. Junk \nMTV quiz graced by fox whelps.\nBawds jog, flick quartz, vex \nnymphs. Waltz, bad nymph, for\nquick jigs vex! Fox nymphs.',
                                        style: Responsive.isDesktop(context)
                                            ? blackRegular16
                                            : blackRegular14,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }))
              : Expanded(
                  // height: Responsive.isDesktop(context)
                  //     ? MediaQuery.of(context).size.height * 1.6
                  //     : MediaQuery.of(context).size.height * 1.1,
                  // width: Responsive.isDesktop(context)
                  //     ? MediaQuery.of(context).size.width - 770
                  //     : MediaQuery.of(context).size.width - 20,
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (context, int index) {
                        return Container();
                      })),
          if (!Responsive.isDesktop(context)) Footer()
        ],
      ),
    );
  }

  ratingBar({all}) {
    double reciprocal(double d) => 1 / d;
    int x = all;
    reciprocal(x.toDouble());
    return RatingBar.builder(
      initialRating: x != null ? x.toDouble() : 0,
      minRating: x != null ? x.toDouble() : 0,
      maxRating: x != null ? x.toDouble() : 0,
      direction: Axis.horizontal,
      allowHalfRating: true,
      ignoreGestures: true,
      unratedColor: Colors.amber.withAlpha(50),
      itemCount: 5,
      itemSize: 20.0,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        setState(() {
          //   _rating = rating;
        });
      },
      tapOnlyMode: all == null ? true : false,
      updateOnDrag: all == null ? true : false,
    );
  }

  bottomGreyContainer() {
    return Container(
      color: MyAppColor.greylight,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Responsive.isDesktop(context)
                ? Image.asset(
                    'assets/Group.png',
                  )
                : Image.asset(
                    'assets/Group.png',
                    width: 130,
                  ),
            SizedBox(
              height: Responsive.isDesktop(context) ? 20 : 10,
            ),
            Text(
              '©2022 All Rights Reserved',
              style: greyRegular14,
            ),
            SizedBox(
              height: Responsive.isDesktop(context) ? 0 : 20,
            ),
            bottomRow2(
              title: 'Links',
              text1: 'About Us',
              text2: 'Privacy Policy',
              text3: 'T & C',
              text4: 'Subscription',
            ),
            bottomRow2(
                title: 'Roles',
                text1: 'Job-Seekers',
                text2: 'Company',
                text3: 'Home-Service Provider',
                text4: 'Home-Service Seeker',
                text5: 'Local Hunar'),
            SizedBox(
              height: Responsive.isDesktop(context) ? 0 : 22,
            ),
            bottomRow2(
                title: 'Work with Us',
                text1: 'Business Correspondence',
                text2: 'Cluster Manager',
                text3: 'Advisor',
                text4: 'Field Sales Executive'),
            SizedBox(
              height: Responsive.isDesktop(context) ? 0 : 20,
            ),
            bottomRow2(
                title: 'Contact',
                text1: '+91 987 654 3210',
                text2: '+91 987 654 3210',
                text3: 'support@hindustanjobs.com'),
          ],
        ),
      ),
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
    return Container(
        color: MyAppColor.lightBlue,
        height: 87,
        width: MediaQuery.of(context).size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 30,
              width: 30,
              color: Colors.white,
            ),
            Text(
                'Complete your Profile for better \nPlacing for Service Searches and to \nget better Service Requests.',
                style: whiteM12()),
            Icon(
              Icons.arrow_forward,
              color: MyAppColor.white,
            )
          ],
        ));
  }
}

// //
//   Widget serviceDetailsTab() {
//     return Column(
//       children: [
//         SizedBox(
//           height: Responsive.isDesktop(context) ? 40 : 20,
//         ),
//         const Text(LabelString.addaService),
//         const SizedBox(
//           height: 20,
//         ),
//         const Text('.   .   .   .   .   .   .   .   .   .   .   .   .'),
//         const SizedBox(
//           height: 30,
//         ),
//         Container(
//           /// width: Responsive.isDesktop(context) ? 770 : 332,
//           width: Responsive.isDesktop(context)
//               ? MediaQuery.of(context).size.width - 760
//               : MediaQuery.of(context).size.width - 100,
//           height: 40,
//           color: MyAppColor.greynormal,
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(child: Text(LabelString.serviceDetails)),
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 40,
//         ),
//         Responsive.isDesktop(context)
//             ? Container(
//                 // width:
//                 //     Responsive.isDesktop(context) ? 770 : 332,
//                 width: Responsive.isDesktop(context)
//                     ? MediaQuery.of(context).size.width - 760
//                     : MediaQuery.of(context).size.width - 100,
//                 height: 40,
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.only(right: 12.0),
//                         child: Container(
//                             height: 40,
//                             //   width: 370,
//                             // width: Responsive.isDesktop(context)
//                             //     ? MediaQuery.of(context)
//                             //             .size
//                             //             .width -
//                             //         760
//                             //     : MediaQuery.of(context)
//                             //             .size
//                             //             .width -
//                             //         100,
//                             alignment: Alignment.centerLeft,
//                             color: MyAppColor.white,
//                             child: Padding(
//                               padding: const EdgeInsets.only(left: 8.0),
//                               child: Text(
//                                 LabelString.serviceName,

//                                 ///  textAlign: TextAlign.center,
//                               ),
//                             )),
//                       ),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 12.0),
//                         child: Container(
//                             height: 40,
//                             alignment: Alignment.centerLeft,
//                             color: MyAppColor.white,
//                             child: Padding(
//                               padding: const EdgeInsets.only(left: 8.0),
//                               child: Text(
//                                 LabelString.selectCategories,
//                                 // textAlign: TextAlign.center,
//                               ),
//                             )),
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             : Container(
//                 // width:
//                 //     Responsive.isDesktop(context) ? 770 : 332,
//                 // height: 40,
//                 width: Responsive.isDesktop(context)
//                     ? MediaQuery.of(context).size.width - 760
//                     : MediaQuery.of(context).size.width - 100,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                         height: 40,
//                         width: Responsive.isDesktop(context) ? 370 : 332,
//                         alignment: Alignment.centerLeft,
//                         color: MyAppColor.white,
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 8.0),
//                           child: Text(
//                             LabelString.serviceName,

//                             ///  textAlign: TextAlign.center,
//                           ),
//                         )),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Container(
//                         height: 40,
//                         width: Responsive.isDesktop(context) ? 370 : 332,
//                         alignment: Alignment.centerLeft,
//                         color: MyAppColor.white,
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Text(
//                                 LabelString.selectCategories,
//                                 // textAlign: TextAlign.center,
//                               ),
//                               Icon(Icons.arrow_drop_down)
//                             ],
//                           ),
//                         )),
//                   ],
//                 ),
//               ),
//         SizedBox(
//           height: Responsive.isDesktop(context) ? 40 : 20,
//         ),
//         Container(
//           height: 40,

//           /// width: Responsive.isDesktop(context) ? 370 : 332,
//           width: Responsive.isDesktop(context)
//               ? MediaQuery.of(context).size.width - 760
//               : MediaQuery.of(context).size.width - 100,
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Container(
//                   height: 40,
//                   width: Responsive.isDesktop(context) ? 370 : 332,
//                   color: MyAppColor.white,
//                   alignment: Alignment.centerLeft,
//                   child: Padding(
//                     padding: EdgeInsets.only(left: 8.0),
//                     child: Text(
//                       LabelString.specifyServiceCharges,
//                     ),
//                   )),
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 20,
//         ),
//         const Text('.   .   .   .   .   .   .   .   .   .   .   .   .'),
//         const SizedBox(
//           height: 20,
//         ),
//         Container(
//             // width: Responsive.isDesktop(context) ? 770 : 332,
//             width: Responsive.isDesktop(context)
//                 ? MediaQuery.of(context).size.width - 760
//                 : MediaQuery.of(context).size.width - 100,
//             height: 40,
//             color: MyAppColor.greynormal,
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: const [
//                 Text(LabelString.servicePhotos),
//               ],
//             )),

//         const SizedBox(
//           height: 20,
//         ),
//         Container(
//           alignment: Alignment.center,
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(
//                   height: Responsive.isDesktop(context) ? 408 : 700,
//                   width: Responsive.isDesktop(context) ? 770 : 332,
//                   child: GridView.count(
//                     crossAxisCount: Responsive.isDesktop(context) ? 4 : 2,
//                     crossAxisSpacing: 20,
//                     mainAxisSpacing: 20,
//                     shrinkWrap: true,
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     children: List.generate(
//                       8,
//                       (index) {
//                         return Container(
//                           alignment: Alignment.center,
//                           height: 170,
//                           width: 170,
//                           color: MyAppColor.greynormal,
//                           child: Stack(
//                             children: [
//                               Image.asset('assets/photo.png'),
//                               Align(
//                                   alignment: Alignment.topRight,
//                                   child: Container(
//                                     color: MyAppColor.greynormal,
//                                     child: Padding(
//                                       padding: EdgeInsets.all(3.0),
//                                       child: Image.asset('assets/close.png'),
//                                     ),
//                                   )),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   )),
//             ],
//           ),
//         ),

//         Responsive.isMobile(context)
//             ? SizedBox(
//                 height: 20,
//               )
//             : SizedBox(
//                 height: 0,
//               ),

//         const Text('.   .   .   .   .   .   .   .   .   .   .   .   .'),

//         const SizedBox(
//           height: 20,
//         ),
//         Container(

//             ///   width: Responsive.isDesktop(context) ? 770 : 332,
//             width: Responsive.isDesktop(context)
//                 ? MediaQuery.of(context).size.width - 760
//                 : MediaQuery.of(context).size.width - 100,
//             height: 40,
//             color: MyAppColor.greynormal,
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                     Responsive.isDesktop(context)
//                         ? LabelString.daysAvailableInWeekForBooking
//                         : LabelString.daysAvailableInWeekForBookingMobile,
//                     textAlign: TextAlign.center)
//               ],
//             )),
//         SizedBox(
//           height: Responsive.isDesktop(context) ? 20 : 10,
//         ),

// Container(
//   alignment: Alignment.center,
//   child: Row(
//     crossAxisAlignment: CrossAxisAlignment.center,
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       SizedBox(
//           height: Responsive.isDesktop(context) ? 150 : 400,
//           width: Responsive.isDesktop(context)
//               ? MediaQuery.of(context).size.width - 760
//               : MediaQuery.of(context).size.width - 100,
//           child: GridView.count(
//             crossAxisCount: Responsive.isDesktop(context) ? 7 : 3,
//             crossAxisSpacing: 20,
//             mainAxisSpacing: 20,
//             shrinkWrap: true,
//             padding: EdgeInsets.symmetric(vertical: 10),
//             children: List.generate(
//               7,
//               (index) {
//                 return Container(
//                   alignment: Alignment.center,
//                   height: 84,
//                   width: 84,
//                   color: MyAppColor.whiteNormal,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Align(
//                           alignment: Alignment.topLeft,
//                           child: Checkbox(
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(5)),
//                             onChanged: (bool? value) {
//                               setState(() {

//                                 _isChecked![index] = value;
//                               });
//                             },
//                             activeColor: MyAppColor.orangelight,
//                             value: _isChecked![index],

//                             //  onChanged:(bool newValue){
//                           )),
//                       // SizedBox(
//                       //   height: 10,
//                       // ),
//                       Text(
//                         listOfDaysLetters[index],
//                         style: blackMedium24,
//                         textAlign: TextAlign.center,
//                       ),
//                       // SizedBox(
//                       //   height: 10,
//                       // ),
//                       Text(
//                         listOfDays[index],
//                         style: grey12,
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           )),
//     ],
//   ),
// ),

// Responsive.isDesktop(context)
//     ? Text(
//         '_____________________________________________________________')
//     : Text('___________________________________________________'),
// SizedBox(
//   height: 20,
// ),

// Container(
//   width: 220,
//         height: 40,
//         child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               primary: MyAppColor.orangelight,
//               // side: BorderSide(
//               //     width: 1.0,
//               //     color: MyAppColor.black)
//             ),
//             onPressed: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const ServiceDetailsScreen()));
//             },
//             child: Padding(
//               padding: EdgeInsets.only(right: 4, left: 4),
//               child: Align(
//                 alignment: Alignment.center,
//                 child: Text(
// //                   LabelString.addService,
// //                   style: whiteR14(),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             )),
//       ),
//       SizedBox(
//         height: Responsive.isDesktop(context) ? 20 : 40,
//       ),

//       //
//       if (!Responsive.isDesktop(context)) bottomGreyContainer(),
//     ],
//   );
// }
