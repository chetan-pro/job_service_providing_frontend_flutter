import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/model/services_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/label_string.dart';
import 'package:hindustan_job/services/api_services/seeker_service_search.dart';
import 'package:hindustan_job/services/services_constant/constant.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/buttons/radio_button_widget.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:vrouter/vrouter.dart';
import '../candidate/dropdown/dropdown_list.dart';
import '../candidate/dropdown/dropdown_string.dart';
import '../candidate/model/experience_filter_model.dart';
import '../candidate/model/serviceProviderModal/alldata_get_modal.dart';
import '../services/api_service_serviceProvider/category.dart';
import '../widget/drop_down_widget/drop_down_dynamic_widget.dart';
import '../widget/drop_down_widget/select_dropdown.dart';
import 'home_service_view_screen.dart';

class MyServiceRequest extends ConsumerStatefulWidget {
  const MyServiceRequest({Key? key}) : super(key: key);

  @override
  ConsumerState<MyServiceRequest> createState() => _MyServiceRequestState();
}

class _MyServiceRequestState extends ConsumerState<MyServiceRequest>
    with TickerProviderStateMixin {
  final List<Widget> myTabs = [
    const Tab(text: LabelString.pendingRequets),
    const Tab(text: LabelString.upcoming),
    const Tab(text: LabelString.completed),
    const Tab(text: LabelString.cancelled),
    const Tab(text: LabelString.rejected),
  ];
  String? selectedMonth;
  String? selectedYear;
  String? selectedSortBy;
  String? selectedBranchId;
  TabController? _tabController;
  int _tabIndex = 0;

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  TextEditingController searchController = TextEditingController();
  List<ExperienceFilter> serviceChargeList = [];
  ExperienceFilter? selectedServiceChargeList;
  List<ServiceCategories> catogaries = [];
  ServiceCategories? selectedCategory;

  @override
  void initState() {
    serviceChargeList =
        ExperienceFilterModel.fromJson(ListDropdown.serviceChargeList)
            .experienceFilter!;
    fetchcatogary();

    _tabController = TabController(length: 5, vsync: this);
    _tabController!.addListener(_handleTabSelection);
    fetchRequestService();
    super.initState();
  }

  fetchcatogary() async {
    catogaries = await categoryData(context);
    setState(() {});
  }

  fetchRequestService() async {
    selectedMonth = "Months";
    selectedYear = "Year";
    selectedSortBy = "Sort by Relevance";
    ref
        .read(serviceSeeker)
        .getServiceByStatus(status: ServiceStatus.pending, context: context);
    ref
        .read(serviceSeeker)
        .getServiceByStatus(status: ServiceStatus.accepted, context: context);
    ref
        .read(serviceSeeker)
        .getServiceByStatus(status: ServiceStatus.completed, context: context);
    ref
        .read(serviceSeeker)
        .getServiceByStatus(status: ServiceStatus.reject, context: context);
    ref
        .read(serviceSeeker)
        .getServiceByStatus(status: ServiceStatus.rejected, context: context);
    setState(() {});
  }

  _handleTabSelection() {
    if (_tabController!.indexIsChanging) {
      fetchRequestService();
      setState(() {
        _tabIndex = _tabController!.index;
      });
    }
  }

  fetchFilterData(status) {
    ref.read(serviceSeeker).getServiceByStatus(
        status: status,
        context: context,
        year: selectedYear,
        month: selectedMonth,
        sortBy: selectedSortBy);
  }

  bool _value = false;
  List<bool?>? _isChecked;
  int selectedTabIndex = 0;
  bool isSwitched = false;
  int group = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColor.backgroundColor,
      body: ListView(
        children: <Widget>[
          Container(
            height: Responsive.isDesktop(context) ? 20 : 10,
          ),
          Padding(
            padding: Responsive.isDesktop(context)
                ? const EdgeInsets.fromLTRB(90, 20, 90, 20)
                : const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Container(
                color: MyAppColor.greynormal,
                child: Padding(
                    padding: Responsive.isDesktop(context)
                        ? const EdgeInsets.fromLTRB(20, 20, 20, 20)
                        : const EdgeInsets.all(10),
                    child: Responsive.isDesktop(context)
                        ? radioButtonsWithSearch()
                        : SeekerSearch(
                            isUserSubscribed: true, isNavigater: true))),
          ),
          Responsive.isDesktop(context)
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 90),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: Responsive.isDesktop(context)
                                  ? null
                                  : MediaQuery.of(context).size.width - 100,
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
                          ],
                        ),
                      ),
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
                              width: 30,
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
                              width: 30,
                            ),
                            const SizedBox(
                              width: 30,
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
                            labelPadding: const EdgeInsets.all(0),
                            tabs: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: const Tab(
                                  text: LabelString.pendingRequets,
                                ),
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
                                  text: LabelString.cancelled,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: const Tab(
                                  text: LabelString.rejected,
                                ),
                              ),
                            ],
                            indicatorWeight: 2,
                            indicatorColor: MyAppColor.orangelight,
                            labelStyle: black12,
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
                    ref.watch(serviceSeeker).pendingServices;
                return Column(
                  children: [
                    pendingRequestWidget(
                        flag: 'pending', status: ServiceStatus.pending),
                    Responsive.isDesktop(context)
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 90),
                            child: Column(
                              children: List.generate(
                                pendingServices.length,
                                (index) => listItemofWIndoeView(
                                    'pending', index, pendingServices[index]),
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
                  ],
                );
              }),
              Consumer(builder: (context, ref, child) {
                List<Services> upcomingServices =
                    ref.watch(serviceSeeker).upcomingServices;
                return Column(
                  children: [
                    pendingRequestWidget(
                        flag: 'upcoming', status: ServiceStatus.accepted),
                    Responsive.isDesktop(context)
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 90),
                            child: Column(
                              children: List.generate(
                                upcomingServices.length,
                                (index) => listItemofWIndoeView(
                                    'upcoming', index, upcomingServices[index]),
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
                  ],
                );
              }),
              Consumer(builder: (context, ref, child) {
                List<Services> completedServices =
                    ref.watch(serviceSeeker).completedServices;
                return Column(
                  children: [
                    pendingRequestWidget(
                        flag: 'completed', status: ServiceStatus.completed),
                    Responsive.isDesktop(context)
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 90,
                            ),
                            child: Column(
                              children: List.generate(
                                completedServices.length,
                                (index) => listItemofWIndoeView('completed',
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
                  ],
                );
              }),
              Consumer(builder: (context, ref, child) {
                List<Services> cancelledServices =
                    ref.watch(serviceSeeker).cancelledServices;
                return Column(
                  children: [
                    pendingRequestWidget(
                        flag: 'completed', status: ServiceStatus.reject),
                    Responsive.isDesktop(context)
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 90,
                            ),
                            child: Column(
                              children: List.generate(
                                cancelledServices.length,
                                (index) => listItemofWIndoeView('completed',
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
                  ],
                );
              }),
              Consumer(builder: (context, ref, child) {
                List<Services> rejectedServices =
                    ref.watch(serviceSeeker).rejectedServices;
                return Column(
                  children: [
                    pendingRequestWidget(
                        flag: 'rejected', status: ServiceStatus.reject),
                    Responsive.isDesktop(context)
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 90,
                            ),
                            child: Column(
                              children: List.generate(
                                rejectedServices.length,
                                (index) => listItemofWIndoeView(
                                    'rejected', index, rejectedServices[index]),
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
                  ],
                );
              })
            ][_tabIndex],
          ),
          Footer()
        ],
      ),
    );
  }

  radioButtonsWithSearch() {
    return Container(
      color: MyAppColor.greynormal,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Row(
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
            GestureDetector(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => SearchHomeServicesListScreen()));
              },
              child: SizedBox(
                height: 30,
                width: Sizeconfig.screenWidth! / 7,
                child: TextFormField(
                    // text: 'Search Services here..',
                    ),
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
            Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                    color: MyAppColor.orangelight),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Icon(
                    Icons.search,
                    size: 17,
                    color: MyAppColor.white,
                  ),
                )),
          ],
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#0${index + 1}',
                  style: greylightMediumGalano14,
                ),
                Wrap(
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('${formatDate(service!.updatedAt)}',
                        style: blackDarkSemibold11),
                    const Padding(
                      padding: EdgeInsets.only(left: 3.0),
                      child: Icon(
                        Icons.calendar_today,
                        size: 11,
                      ),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text('${service.serviceName}', style: blackDarkSemiBold16),
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
                        service.serviceProviderStatus == ServiceStatus.pending
                            ? Text('Waiting for Approval',
                                style: blackDarkSemibold14)
                            : service.serviceProviderStatus ==
                                    ServiceStatus.completed
                                ? Text('Completed', style: blackDarkSemibold14)
                                : Text('Accepted & Upcoming',
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
              crossAxisAlignment: WrapCrossAlignment.center,
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
            viewRequestButton(service.serviceProviderStatus, service.id,
                service.serviceRequestId)
          ],
        )),
      ),
    );
  }

  onPressedViewRequest(flag, id, serviceRequestId) async {
    if (kIsWeb) {
      context.vRouter.to(
          "/home-service-seeker/request-service/$id/$flag/$serviceRequestId");
    } else {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeServiceViewScreen(
                    flag: flag,
                    serviceId: id.toString(),
                    serviceRequestId: serviceRequestId.toString(),
                  )));
    }
    await fetchRequestService();
  }

  Widget viewRequestButton(flag, id, serviceRequestId) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
            onPressed: () {
              onPressedViewRequest(flag, id, serviceRequestId);
            },
            style: ElevatedButton.styleFrom(
                elevation: 0,
                primary: MyAppColor.greynormal,
                side: BorderSide(width: 1.0, color: MyAppColor.black)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    'VIEW REQUEST',
                    style: blackRegular14,
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

  //
  pendingRequestWidget({flag, status}) {
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
                    containersss(text: 'S.NO.', flex: 1),
                    flag == 'completed'
                        ? container(text: LabelString.serviceRequested, flex: 4)
                        : container(text: LabelString.dateRequestedOn, flex: 2),
                    if (flag != 'completed')
                      container(text: LabelString.serviceRequested, flex: 4),
                    container(text: 'SERVICE PROVIDER BRANCH', flex: 3),
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
        : mobileViewPendingRequest(status);
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

  //
  containersss({text, flex}) {
    return Expanded(
      flex: flex,
      child: Container(
          margin: const EdgeInsets.only(left: 8),
          color: MyAppColor.grayplane,
          alignment: Alignment.center,
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

  Widget listItemofWIndoeView(flag, index, Services service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          containerSNO2(text: '${index + 1}', flex: 1),
          flag == 'completed'
              ? const SizedBox()
              : container2(text: '${service.requestDate}', flex: 2),
          container2(text: '${service.serviceName}', flex: 4),
          container3(
              text: '${service.user!.name}',
              flex: 3,
              state: service.user!.state,
              city: service.user!.city),
          container2(
              text: flag == 'pending'
                  ? 'Waiting for Approval'
                  : flag == 'upcoming'
                      ? 'Accepted & Upcoming'
                      : 'Completed',
              flex: 3),
          flag != 'completed'
              ? const SizedBox()
              : container2(text: '${formatDate(service.updatedAt)}', flex: 2),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                onPressedViewRequest(
                    flag, service.id, service.serviceRequestId);
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
        ],
      ),
    );
  }

  containerSNO2({text, flex}) {
    return Expanded(
      flex: flex,
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        color: MyAppColor.grayplane,
        alignment: Alignment.center,
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

  container3({text, flex, state, city}) {
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
                      '${locationShow(state: state, city: city)}',
                      style: black12,
                    ),
                  ],
                )
              ],
            ),
          )),
    );
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
                  width: 77,
                  child: BuildDropdown(
                    itemsList: yearArray,
                    dropdownHint: 'Year',
                    onChanged: (value) async {
                      await fetchFilterData(flag);
                      setState(() {
                        selectedYear = value;
                      });
                    },
                    height: 47,
                    selectedValue: selectedYear,
                    defaultValue: 'Year',
                  ),
                ),
                SizedBox(
                  width: 176,
                  child: BuildDropdown(
                    itemsList: const ['Ascending', 'Descending'],
                    dropdownHint: LabelString.sortByRelevance,
                    onChanged: (value) {
                      setState(() {
                        selectedSortBy = value;
                        fetchFilterData(flag);
                      });
                    },
                    height: 47,
                    selectedValue: selectedSortBy,
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
                  width: 97,
                  child: BuildDropdown(
                    itemsList: monthArray,
                    dropdownHint: 'Months',
                    onChanged: (value) {
                      setState(() {
                        selectedMonth = value;
                        fetchFilterData(flag);
                      });
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
}
