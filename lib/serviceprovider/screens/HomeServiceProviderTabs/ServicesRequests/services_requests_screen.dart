import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/model/services_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/label_string.dart';
import 'package:hindustan_job/serviceprovider/screens/HomeServiceProviderTabs/ServicesRequests/view_service_request_details_screen.dart';
import 'package:hindustan_job/services/services_constant/constant.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:vrouter/vrouter.dart';

import '../../../../candidate/dropdown/dropdown_list.dart';
import '../../../../utility/function_utility.dart';
import '../../../../widget/drop_down_widget/select_dropdown.dart';

class ServiceRequestsScreen extends ConsumerStatefulWidget {
  int? index;
  Function? resetIndex;
  ServiceRequestsScreen({Key? key, this.index, this.resetIndex})
      : super(key: key);

  @override
  _ServiceRequestsScreenState createState() => _ServiceRequestsScreenState();
}

class _ServiceRequestsScreenState extends ConsumerState<ServiceRequestsScreen>
    with SingleTickerProviderStateMixin {
  final List<Widget> myTabs = [
    const Tab(text: LabelString.pendingRequets),
    const Tab(text: LabelString.upcoming),
    const Tab(text: LabelString.completed),
    const Tab(text: LabelString.rejected),
    const Tab(text: LabelString.cancelled),
  ];
  final etSkillScore1Key = GlobalKey<FormState>();

  String? selectedMonth;
  String? selectedSortBy;
  String? selectedYear;
  String? selectedBranchId;

  TabController? _tabController;
  int _tabIndex = 0;

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _tabController =
        TabController(length: 5, vsync: this, initialIndex: widget.index ?? 0);
    _tabIndex = widget.index ?? 0;
    if (widget.resetIndex != null) {
      widget.resetIndex!();
    }
    _tabController!.addListener(_handleTabSelection);
    fetchRequestService();
    super.initState();
  }

  fetchRequestService() async {
    ref
        .read(serviceProviderData)
        .getdataserviceRequest(serviceStatus: ServiceStatus.pending);
    ref
        .read(serviceProviderData)
        .getdataserviceRequest(serviceStatus: ServiceStatus.accepted);
    ref
        .read(serviceProviderData)
        .getdataserviceRequest(serviceStatus: ServiceStatus.completed);
    ref
        .read(serviceProviderData)
        .getdataserviceRequest(serviceStatus: ServiceStatus.rejected);
    ref.read(serviceProviderData).getdataserviceRequest(
        serviceStatus: ServiceStatus.pending, userStatus: ServiceStatus.reject);
  }

  _handleTabSelection() {
    if (_tabController!.indexIsChanging) {
      setState(() {
        _tabIndex = _tabController!.index;
      });
    }
  }

  bool? _value = false;
  List<bool?>? _isChecked;
  int selectedTabIndex = 0;
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            height: 20,
          ),
          Responsive.isDesktop(context)
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 90),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Container(
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
                          )),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Icon(Icons.arrow_drop_down),
                                Text(
                                  LabelString.allBranches,
                                  style: blackMedium14,
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Icon(Icons.arrow_drop_down),
                                Text(
                                  'March',
                                  style: blackMedium14,
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Icon(Icons.arrow_drop_down),
                                Text(
                                  '2021',
                                  style: blackMedium14,
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Icon(Icons.arrow_drop_down),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  LabelString.sortByRelevance,
                                  style: blackMedium14,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        width: Responsive.isDesktop(context)
                            ? MediaQuery.of(context).size.width - 1000
                            : MediaQuery.of(context).size.width - 16,
                        child: Center(
                          child: TabBar(
                            controller: _tabController,
                            labelColor: Colors.black,
                            indicatorWeight: 2,
                            indicatorColor: MyAppColor.orangelight,
                            labelStyle: blackBold12,
                            labelPadding: const EdgeInsets.all(0),
                            tabs: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child:
                                    const Tab(text: LabelString.pendingRequets),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: const Tab(
                                  text: LabelString.upcoming,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: const Tab(
                                  text: LabelString.completed,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: const Tab(
                                  text: LabelString.rejected,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: const Tab(
                                  text: LabelString.cancelled,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          Center(
            child: [
              Consumer(builder: (context, ref, child) {
                List<Services> pendingServices =
                    ref.watch(serviceProviderData).pending;
                return Column(
                  children: [
                    pendingRequestWidget(flag: ServiceStatus.pending),
                    Responsive.isDesktop(context)
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 90),
                            child: Column(
                              children: List.generate(
                                pendingServices.length,
                                (index) => listItemofWIndoeView(
                                    index, pendingServices[index]),
                              ).toList(),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: List.generate(
                                pendingServices.length,
                                (index) =>
                                    itemsOfList(index, pendingServices[index]),
                              ).toList(),
                            ),
                          ),
                    const SizedBox(
                      height: 30,
                    ),
                    Footer()
                  ],
                );
              }),
              Consumer(builder: (context, ref, child) {
                List<Services> upcomingServices =
                    ref.watch(serviceProviderData).upcoming;
                return Column(
                  children: [
                    pendingRequestWidget(flag: 'upcoming'),
                    Responsive.isDesktop(context)
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 90),
                            child: Column(
                              children: List.generate(
                                upcomingServices.length,
                                (index) => listItemofWIndoeView(
                                    index, upcomingServices[index]),
                              ).toList(),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: List.generate(
                                upcomingServices.length,
                                (index) =>
                                    itemsOfList(index, upcomingServices[index]),
                              ).toList(),
                            ),
                          ),
                    const SizedBox(
                      height: 30,
                    ),
                    Footer()
                  ],
                );
              }),
              Consumer(builder: (context, ref, child) {
                List<Services> completedServices =
                    ref.watch(serviceProviderData).completed;
                return Column(
                  children: [
                    pendingRequestWidget(flag: 'completed'),
                    Responsive.isDesktop(context)
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 90),
                            child: Column(
                              children: List.generate(
                                completedServices.length,
                                (index) => listItemofWIndoeView(
                                    index, completedServices[index]),
                              ).toList(),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: List.generate(
                                completedServices.length,
                                (index) => itemsOfList(
                                    index, completedServices[index]),
                              ).toList(),
                            ),
                          ),
                    const SizedBox(
                      height: 30,
                    ),
                    Footer()
                  ],
                );
              }),
              Consumer(builder: (context, ref, child) {
                List<Services> rejectedServices =
                    ref.watch(serviceProviderData).rejected;
                return Column(
                  children: [
                    pendingRequestWidget(flag: 'rejected'),
                    Responsive.isDesktop(context)
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 90),
                            child: Column(
                              children: List.generate(
                                rejectedServices.length,
                                (index) => listItemofWIndoeView(
                                    index, rejectedServices[index]),
                              ).toList(),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: List.generate(
                                rejectedServices.length,
                                (index) =>
                                    itemsOfList(index, rejectedServices[index]),
                              ).toList(),
                            ),
                          ),
                    const SizedBox(
                      height: 30,
                    ),
                    Footer()
                  ],
                );
              }),
              Consumer(builder: (context, ref, child) {
                List<Services> cancelledServices =
                    ref.watch(serviceProviderData).cancelled;
                return Column(
                  children: [
                    pendingRequestWidget(flag: 'rejected'),
                    Responsive.isDesktop(context)
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 90),
                            child: Column(
                              children: List.generate(
                                cancelledServices.length,
                                (index) => listItemofWIndoeView(
                                    index, cancelledServices[index]),
                              ).toList(),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: List.generate(
                                cancelledServices.length,
                                (index) => itemsOfList(
                                    index, cancelledServices[index]),
                              ).toList(),
                            ),
                          ),
                    const SizedBox(
                      height: 30,
                    ),
                    Footer()
                  ],
                );
              }),
            ][_tabIndex],
          ),
        ],
      ),
    );
  }

  Widget listItemofWIndoeView(index, Services service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          container2(text: '${index + 1}', flex: 1),
          service.serviceProviderStatus == 'completed'
              ? container2(text: "${service.updatedAt}", flex: 2)
              : container2(text: "${service.requestDate}", flex: 2),
          container3(
              text: service.user!.name,
              state: service.user!.state,
              city: service.user!.city,
              flex: 3),
          container2(text: '${service.serviceName}', flex: 4),
          container2(
              text: service.serviceProviderStatus == 'upcoming'
                  ? 'Accepted & Upcoming'
                  : service.serviceProviderStatus == 'completed'
                      ? 'Completed'
                      : 'Waiting for Approval',
              flex: 3),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: InkWell(
                onTap: () {
                  context.vRouter.to(
                      "/home-service-seeker/view-service-request-details-screen/${service.serviceProviderStatus}/${service.serviceRequestId}");
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 8),
                  height: Responsive.isDesktop(context) ? 55 : 0,
                  color: MyAppColor.grayplane,
                  child: Container(
                      margin: const EdgeInsets.fromLTRB(0.0, 10, 10, 10),
                      padding: const EdgeInsets.all(0.0),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(
                                  5.0) //                 <--- border radius here
                              ),
                          border: Border.all(color: MyAppColor.black)),
                      child: Image.asset('assets/forward_arrow.png')),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //
  pendingRequestWidget({flag}) {
    return Responsive.isDesktop(context)
        ? Padding(
            padding: EdgeInsets.only(
                left: Responsive.isDesktop(context) ? 90.0 : 10,
                right: Responsive.isDesktop(context) ? 90 : 10),
            child: Container(
                child: Column(
              children: [
                SizedBox(height: Responsive.isDesktop(context) ? 30 : 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    container(text: 'S.NO.', flex: 1),
                    flag == 'completed'
                        ? const SizedBox()
                        : container(text: LabelString.dateRequestedOn, flex: 2),
                    container(text: LabelString.client, flex: 3),
                    container(text: LabelString.serviceRequested, flex: 4),
                    container(text: LabelString.status, flex: 3),
                    flag == 'completed'
                        ? container(text: 'DATE COMPLETED ON', flex: 2)
                        : const SizedBox(),
                    container(text: LabelString.action, flex: 1),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            )),
          )
        : mobileViewPendingRequest(flag);
  }

  mobileViewPendingRequest(flag) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 74,
                  child: BuildDropdown(
                    itemsList: yearArray,
                    dropdownHint: 'Year',
                    onChanged: (value) {
                      selectedYear = value;
                      ref.read(serviceProviderData).getdataserviceRequest(
                          serviceStatus: ServiceStatus.pending,
                          sortBy: selectedSortBy,
                          year: selectedYear,
                          month: selectedMonth,
                          branchId: selectedBranchId);
                    },
                    height: 47,
                    selectedValue: selectedYear,
                    defaultValue: 'Year',
                  ),
                ),
                SizedBox(
                  width: 165,
                  child: BuildDropdown(
                    itemsList: const ['Ascending', 'Descending'],
                    dropdownHint: LabelString.sortByRelevance,
                    onChanged: (value) {
                      selectedSortBy = value;
                      ref.read(serviceProviderData).getdataserviceRequest(
                          serviceStatus: ServiceStatus.pending,
                          sortBy: selectedSortBy,
                          year: selectedYear,
                          month: selectedMonth,
                          branchId: selectedBranchId);
                    },
                    height: 47,
                    selectedValue: selectedYear,
                    defaultValue: LabelString.sortByRelevance,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 130,
                  child: BuildDropdown(
                    itemsList: const [],
                    dropdownHint: 'All Branches',
                    onChanged: (value) {
                      selectedBranchId = value;
                      ref.read(serviceProviderData).getdataserviceRequest(
                          serviceStatus: ServiceStatus.pending,
                          sortBy: selectedSortBy,
                          year: selectedYear,
                          month: selectedMonth,
                          branchId: selectedBranchId);
                    },
                    height: 47,
                    selectedValue: null,
                    defaultValue: 'All Branches',
                  ),
                ),
                SizedBox(
                  width: 93,
                  child: BuildDropdown(
                    itemsList: monthArray,
                    dropdownHint: 'Months',
                    onChanged: (value) {
                      selectedMonth = value;
                      ref.read(serviceProviderData).getdataserviceRequest(
                          serviceStatus: ServiceStatus.pending,
                          sortBy: selectedSortBy,
                          year: selectedYear,
                          month: selectedMonth,
                          branchId: selectedBranchId);
                    },
                    height: 47,
                    selectedValue: selectedMonth,
                    defaultValue: 'Months',
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget itemsOfList(index, Services? service) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      color: MyAppColor.greynormal,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: (Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('#${index + 1}', style: greylightMediumGalano14),
            const SizedBox(
              height: 5,
            ),
            Text('${service!.serviceName}', style: blackDarkSemiBold16),
            const SizedBox(
              height: 10,
            ),
            Container(
              color: MyAppColor.grayplane,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Wrap(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child:
                              Text('Status: ', style: greylightMediumGalano14),
                        ),
                        service.serviceProviderStatus == 'upcoming'
                            ? Text('Accepted & Upcoming',
                                style: blackDarkSemibold14)
                            : service.serviceProviderStatus == 'completed'
                                ? Text('Completed', style: blackDarkSemibold14)
                                : Text('Waiting for Approval',
                                    style: blackDarkSemibold14)
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text('${service.user!.name}', style: blackdarkM16),
            const SizedBox(
              height: 5,
            ),
            Wrap(
              children: [
                Image.asset('assets/location_icon.png'),
                Text(
                  '${locationShow(state: service.user!.state, city: service.user!.city)}',
                  style: black14,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            viewRequestButton(service.serviceProviderStatus, service)
          ],
        )),
      ),
    );
  }

  onPressedViewRequest(flag, services) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewServiceRequestDetailsScreen(
                  flag: flag,
                  servicereques: services,
                )));
  }

  Widget viewRequestButton(flag, services) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
            onPressed: () {
              onPressedViewRequest(flag, services);
            },
            style: ElevatedButton.styleFrom(
                primary: MyAppColor.greynormal,
                side: BorderSide(width: 1.0, color: MyAppColor.black)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    'VIEW REQUEST',
                    style: black14,
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: MyAppColor.black,
                  )
                ],
              ),
            )),
      ],
    );
  }

  container({text, flex}) {
    return Expanded(
      flex: flex,
      child: Container(
          margin: const EdgeInsets.only(left: 8),
          color: MyAppColor.grayplane,
          alignment: Alignment.centerLeft,
          height: Responsive.isDesktop(context) ? 36 : 46,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              text,
              style: blackdarkM12,
              textAlign: TextAlign.center,
            ),
          )),
    );
  }

  container2({text, flex}) {
    return Expanded(
      flex: flex,
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        color: MyAppColor.grayplane,
        alignment: Alignment.centerLeft,
        height: Responsive.isDesktop(context) ? 56 : 46,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            text,
            style: blackDarkM14(),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  container3({text, state, city, flex}) {
    return Expanded(
      flex: flex,
      child: Container(
          margin: const EdgeInsets.only(left: 8),
          color: MyAppColor.grayplane,
          alignment: Alignment.centerLeft,
          height: Responsive.isDesktop(context) ? 56 : 46,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: blackMedium14,
                  // textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 2,
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Image.asset('assets/location_icon.png'),
                    Text(
                      '${locationShow(city: city, state: state)}',
                      style: black12,
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }

  bottomGreyContainer() {
    return Column(
      children: [
        Container(
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
        ),
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
                  Image.asset('assets/heart.png', height: 20, width: 20)
                ],
              ),
            ],
          ),
        ),
      ],
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
}
