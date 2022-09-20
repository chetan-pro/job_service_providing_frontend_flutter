import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/model/registree_model.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/clusterManager/cluster_manager_dashboard.dart';
import 'package:hindustan_job/clusterManager/registree_details_screen.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/label_string.dart';
import 'package:vrouter/vrouter.dart';

import '../constants/types_constant.dart';
import '../services/auth/auth.dart';
import '../utility/function_utility.dart';
import '../widget/drop_down_widget/text_drop_down_widget.dart';

class MyRegistreesScreen extends ConsumerStatefulWidget {
  int tabIndex;
  String status;
  MyRegistreesScreen({required this.tabIndex, required this.status});
  @override
  ConsumerState<MyRegistreesScreen> createState() => _MyRegistreesScreenState();
}

class _MyRegistreesScreenState extends ConsumerState<MyRegistreesScreen>
    with TickerProviderStateMixin {
  List roleList = [
    'Job-Seeker',
    'Company/Recruiters',
    'Home-Service Provider',
    'Home-Service Seeker',
    'Local Hunar'
  ];

  TabController? _tabController;

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  List<Widget> myTabs = [];
  @override
  void initState() {
    print(widget.status);
    statusValue = widget.status == '' ? 'Status' : widget.status;
    _tabController =
        TabController(length: 5, initialIndex: widget.tabIndex, vsync: this);
    _tabController!.addListener(_handleTabSelection);
    super.initState();
    myTabs = [
      SizedBox(width: 100, child: Tab(text: roleList[0])),
      SizedBox(child: Tab(text: roleList[1])),
      SizedBox(child: Tab(text: roleList[2])),
      SizedBox(child: Tab(text: roleList[3])),
      SizedBox(child: Tab(text: roleList[4])),
    ];
    ref.read(businessCorrespondance).getAllRoleData(status: widget.status);
  }

  String sortValue = "Sort by relevance";
  String statusValue = "Status";

  _handleTabSelection() {
    if (_tabController!.indexIsChanging) {
      setState(() {
        widget.tabIndex = _tabController!.index;
        sortValue = 'Sort by relevance';
        statusValue = 'Status';
      });
    }
  }

  bool? _value = false;
  List<bool?>? _isChecked;
  int selectedTabIndex = 0;
  bool isSwitched = false;
  int group = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyAppColor.backgroundColor,
      child: userData!.referrerCode == null
          ? Center(
              child: Text(
                'Not Approved By Admin',
                style: blackDarkR12(),
                textAlign: TextAlign.center,
              ),
            )
          : ListView(
              children: <Widget>[
                Container(
                  height: Responsive.isDesktop(context) ? 20 : 10,
                ),
                Responsive.isDesktop(context)
                    ? tabsRowWindow()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: Responsive.isDesktop(context)
                                  ? MediaQuery.of(context).size.width - 1000
                                  : MediaQuery.of(context).size.width - 16,
                              child: Center(
                                child: TabBar(
                                  controller: _tabController,
                                  labelColor: Colors.black,
                                  isScrollable: true,
                                  labelPadding: const EdgeInsets.all(0),
                                  tabs: [
                                    tabMobile(text: roleList[0]),
                                    tabMobile(text: roleList[1]),
                                    tabMobile(text: roleList[2]),
                                    tabMobile(text: roleList[3]),
                                    tabMobile(text: roleList[4]),
                                  ],
                                  onTap: (value) {
                                    setState(() {});
                                  },
                                  indicatorWeight: 2,
                                  indicatorColor: MyAppColor.orangelight,
                                  labelStyle: black12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                if (!Responsive.isDesktop(context)) const SizedBox(height: 20),
                // if (Responsive.isDesktop(context)) menuRow(),
                Consumer(builder: (context, ref, child) {
                  List<Registree> registreeJSList =
                      ref.watch(businessCorrespondance).registreeJSList;
                  List<Registree> registreeCOMPANYList =
                      ref.watch(businessCorrespondance).registreeCOMPANYList;
                  List<Registree> registreeHSSList =
                      ref.watch(businessCorrespondance).registreeHSSList;
                  List<Registree> registreeHSPList =
                      ref.watch(businessCorrespondance).registreeHSPList;
                  List<Registree> registreeLHList =
                      ref.watch(businessCorrespondance).registreeLHList;

                  return Wrap(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppDropdownInput(
                            hintText: "Status",
                            options: ['active', 'inactive'],
                            value: statusValue,
                            changed: (String value) async {
                              statusValue = value;
                              setState(() {});
                              if (value != 'Status') {
                                ref
                                    .read(businessCorrespondance)
                                    .getRegistreeByRoleType(
                                        widget.tabIndex == 0
                                            ? RoleTypeConstant.jobSeeker
                                            : widget.tabIndex == 1
                                                ? RoleTypeConstant.company
                                                : widget.tabIndex == 2
                                                    ? RoleTypeConstant
                                                        .homeServiceProvider
                                                    : widget.tabIndex == 3
                                                        ? RoleTypeConstant
                                                            .homeServiceSeeker
                                                        : RoleTypeConstant
                                                            .localHunar,
                                        sortBy: sortValue,
                                        status: value);
                              } else {
                                ref
                                    .read(businessCorrespondance)
                                    .getRegistreeByRoleType(
                                      widget.tabIndex == 0
                                          ? RoleTypeConstant.jobSeeker
                                          : widget.tabIndex == 1
                                              ? RoleTypeConstant.company
                                              : widget.tabIndex == 2
                                                  ? RoleTypeConstant
                                                      .homeServiceProvider
                                                  : widget.tabIndex == 3
                                                      ? RoleTypeConstant
                                                          .homeServiceSeeker
                                                      : RoleTypeConstant
                                                          .localHunar,
                                      sortBy: sortValue,
                                    );
                              }
                            },
                            getLabel: (String value) => value,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          AppDropdownInput(
                            hintText: "Sort by relevance",
                            options: ['Ascending', 'Descending'],
                            value: sortValue,
                            changed: (String value) async {
                              sortValue = value;
                              setState(() {});
                              if (value != 'Sort by relevance') {
                                ref
                                    .read(businessCorrespondance)
                                    .getRegistreeByRoleType(
                                        widget.tabIndex == 0
                                            ? RoleTypeConstant.jobSeeker
                                            : widget.tabIndex == 1
                                                ? RoleTypeConstant.company
                                                : widget.tabIndex == 2
                                                    ? RoleTypeConstant
                                                        .homeServiceProvider
                                                    : widget.tabIndex == 3
                                                        ? RoleTypeConstant
                                                            .homeServiceSeeker
                                                        : RoleTypeConstant
                                                            .localHunar,
                                        sortBy: value,
                                        status: statusValue);
                              }
                            },
                            getLabel: (String value) => value,
                          ),
                        ],
                      ),
                      ...List.generate(
                          (widget.tabIndex == 0
                                      ? registreeJSList
                                      : widget.tabIndex == 1
                                          ? registreeCOMPANYList
                                          : widget.tabIndex == 2
                                              ? registreeHSPList
                                              : widget.tabIndex == 3
                                                  ? registreeHSSList
                                                  : registreeLHList) !=
                                  null
                              ? (widget.tabIndex == 0
                                      ? registreeJSList
                                      : widget.tabIndex == 1
                                          ? registreeCOMPANYList
                                          : widget.tabIndex == 2
                                              ? registreeHSPList
                                              : widget.tabIndex == 3
                                                  ? registreeHSSList
                                                  : registreeLHList)
                                  .length
                              : 0,
                          (index) => listViewWindow(
                              context,
                              (widget.tabIndex == 0
                                  ? registreeJSList
                                  : widget.tabIndex == 1
                                      ? registreeCOMPANYList
                                      : widget.tabIndex == 2
                                          ? registreeHSPList
                                          : widget.tabIndex == 3
                                              ? registreeHSSList
                                              : registreeLHList)[index],
                              index))
                    ],
                  );
                }),
              ],
            ),
    );
  }

  tabMobile({text}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2.5,
      child: Tab(
        text: text,
      ),
    );
  }

  tabsRowWindow() {
    return Padding(
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
                      ? Sizeconfig.screenWidth! / 2
                      : MediaQuery.of(context).size.width - 100,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.black,
                    isScrollable: false,
                    tabs: myTabs,
                    indicatorWeight: 2,
                    indicatorColor: MyAppColor.orangelight,
                    labelStyle: blackDark12,
                    labelPadding: const EdgeInsets.all(0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //
  Widget listViewWindow(context, Registree registree, index) {
    return Responsive.isDesktop(context)
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              itemWIndow(
                flex: 1,
                text: "${index + 1}",
                alignment: Alignment.center,
              ),
              itemWIndow(
                  flex: 3,
                  text: "${registree.registeredUser!.name}",
                  alignment: Alignment.centerLeft),
              itemWIndow(
                  flex: 2,
                  text: "${registree.registeredUser!.userRoleType}",
                  alignment: Alignment.centerLeft),
              itemWIndow(
                  flex: 2,
                  text: "${formatDate(registree.dateRegistered)}",
                  alignment: Alignment.centerLeft),
              itemWIndow(
                  flex: 3,
                  text: "${registree.noSubscriptionPurchased}",
                  alignment: Alignment.centerLeft),
              itemWIndow(
                  flex: 3,
                  text: "${formatDate(registree.lastSubscriptionPurchaseDate)}",
                  alignment: Alignment.centerLeft),
              arrowButton(registree)
            ],
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Container(
              color: MyAppColor.greynormal,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${index + 1}", style: grey12),
                          Wrap(
                            children: [
                              Text("${registree.dateRegistered}",
                                  style: blackDarkSb10()),
                              const Icon(Icons.calendar_today_rounded, size: 11)
                            ],
                          ),
                        ]),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("${registree.registeredUser!.name}",
                        style: blackDarkSemiBold16),
                    Row(
                      children: [
                        Text('Role Registered for: ', style: blackMedium12),
                        Text("${registree.registeredUser!.userRoleType}",
                            style: blackMedium12)
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: MyAppColor.grey,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("${registree.noSubscriptionPurchased}",
                                      style: blackDarkSemibold14),
                                  Text('No. of Subscription Purchased',
                                      style: blackDarkR10())
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Wrap(
                          children: [
                            Text('Last Subscribed:', style: black10),
                            Text(
                                "${formatDate(registree.lastSubscriptionPurchaseDate)}",
                                style: black10)
                          ],
                        ),
                        viewAllButtonMobile(context, registree)
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
  }

  arrowButton(Registree registree) {
    return Expanded(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: GestureDetector(
            onTap: () {
              String js = 'job-seeker';
              if (kIsWeb) {
                context.vRouter.to(
                    "/BC/registree-user-profile/$js/${registree.registeredUser!.id}");
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailsScreen(
                              flag: 'job-seeker',
                              registree: registree,
                            )));
              }
            },
            child: Container(
              color: MyAppColor.grayplane,
              alignment: Alignment.center,
              height: Responsive.isDesktop(context) ? 37 : 55,
              child: Container(
                  margin: const EdgeInsets.all(7),
                  padding: const EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0) //
                              ),
                      border: Border.all(color: MyAppColor.black)),
                  child: Image.asset(
                    'assets/forward_arrow.png',
                    color: MyAppColor.black,
                  )),
            ),
          ),
        ));
  }

  viewAllButtonMobile(context, Registree registree) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {
              if (kIsWeb) {
                context.vRouter.to(
                    "/BC/registree-user-profile/job-seeker/${registree.registeredUser!.id}");
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailsScreen(
                              flag: 'job-seeker',
                              registree: registree,
                            )));
              }
            },
            style: ElevatedButton.styleFrom(
                elevation: 0,
                primary: MyAppColor.greynormal,
                side: BorderSide(width: 1.0, color: MyAppColor.black)),
            child: Row(
              children: [
                Text(
                  'VIEW ',
                  style: blackRegular12,
                ),
                Image.asset(
                  'assets/forward_arrow.png',
                  color: MyAppColor.black,
                )
              ],
            )),
      ],
    );
  }

  //
  itemWIndow({flex, text, alignment, style}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 2),
        child: Container(
          alignment: alignment,
          color: MyAppColor.grayplane,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              text,
              style: style ?? black12,
            ),
          ),
        ),
      ),
    );
  }

  menuRow() {
    return Padding(
      padding: const EdgeInsets.only(right: 110.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
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
    );
  }
}
