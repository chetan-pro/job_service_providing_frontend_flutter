// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:clippy_flutter/paralellogram.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/model/registree_model.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/homeserviceSeeker/home_tab.dart';
import 'package:hindustan_job/provider/business_correspondance_provider.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:vrouter/vrouter.dart';

import '../candidate/model/business_correspondance_count_model.dart';
import '../candidate/model/commision_model.dart';
import '../candidate/model/manager_business_details_model.dart';
import '../candidate/model/manager_personal_details_model.dart';
import '../services/auth/auth.dart';
import '../services/auth/auth_services.dart';
import '../services/services_constant/response_model.dart';
import '../utility/function_utility.dart';
import 'cluster_manager_dashboard.dart';
import 'edit_cluster_manager.dart';

class HomeTabClusterManager extends ConsumerStatefulWidget {
  Function onChangeTab;
  HomeTabClusterManager({Key? key, required this.onChangeTab})
      : super(key: key);

  @override
  ConsumerState<HomeTabClusterManager> createState() =>
      _HomeTabClusterManagerState();
}

class _HomeTabClusterManagerState extends ConsumerState<HomeTabClusterManager> {
  int profileComplete = 50;
  ManagerPersonalDetails? managerPersonalDetails;
  getResidentDetails() async {
    ApiResponse response = await getMiscellaneousUserPersonalDetails();
    if (response.status == 200 && response.body!.data != null) {
      profileComplete += 25;
      setState(() {});
    }
  }

  ManagerBusinessDetailsModel? managerBusinessDetails;

  getBusinessDetails() async {
    ApiResponse response = await getMiscellaneousUserBussinessDetails();
    if (response.status == 200 && response.body!.data != null) {
      profileComplete += 25;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getResidentDetails();
    getBusinessDetails();
  }

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    final styles = blackRegular12;
    return mainBody(styles);
  }

  List roleList = [
    'Job-Seeker',
    'Company/Recruiters',
    'Home-Service Provider',
    'Home-Service Seeker',
    'Local Hunar'
  ];
  Widget mainBody(styles) {
    return Container(
      color: MyAppColor.backgroundColor,
      child: userData!.referrerCode == null
          ? Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    if (profileComplete > 90) return;
                    if (!kIsWeb) {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditClusterManager()));
                    } else {
                      context.vRouter.to("/BC/edit-profile");
                    }
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Image.asset(
                                'assets/cut_staff.png',
                                color: Colors.blue,
                              ),
                            ),
                            Text(
                                profileComplete > 90
                                    ? Responsive.isDesktop(context)
                                        ? 'Wait until admin can approve your profile.'
                                        : 'Wait until admin  can approve your profile.'
                                    : Responsive.isDesktop(context)
                                        ? 'Complete your profile so that admin can approve your profile.'
                                        : 'Complete your profile so that admin can\napprove your profile.',
                                style: whiteM12()),
                            if (Responsive.isDesktop(context))
                              Padding(
                                padding: EdgeInsets.only(
                                    top: Responsive.isDesktop(context)
                                        ? 48.0
                                        : 75),
                                child: Image.asset('assets/mask.png'),
                              ),
                            if (!(profileComplete > 90))
                              Icon(
                                Icons.arrow_forward,
                                color: MyAppColor.white,
                              )
                          ],
                        )),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    'Not Approved By Admin',
                    style: blackDarkR12(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          'Unique Code',
                          style: blackDarkR12(),
                          textAlign: TextAlign.center,
                        ),
                        Text(userData!.referrerCode!,
                            style: blackDarkR16, textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                  // tableRoleData(),
                  Padding(
                    padding: EdgeInsets.only(
                        right: !Responsive.isDesktop(context) ? 10 : 100.0,
                        left: !Responsive.isDesktop(context) ? 10 : 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: Responsive.isDesktop(context) ? 20.0 : 10),
                        cardsRow(),
                        SizedBox(
                          height: Responsive.isDesktop(context) ? 20 : 20,
                        ),
                        MyRegistreeSummery(onChangeTab: widget.onChangeTab),
                        SizedBox(
                          height: Responsive.isDesktop(context) ? 20 : 20,
                        ),
                        if (userData!.userRoleType !=
                            RoleTypeConstant.fieldSalesExecutive)
                          Responsive.isDesktop(context)
                              ? Row(
                                  children: [
                                    RecentlyEarned(
                                      onChangeTab: widget.onChangeTab,
                                    ),
                                    // RecentTransactions()
                                  ],
                                )
                              : Column(
                                  children: [
                                    RecentlyEarned(
                                        onChangeTab: widget.onChangeTab),
                                    const SizedBox(height: 30),
                                    // RecentTransactions(),
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
  }

  tableRoleData() {
    return Table(
      columnWidths: {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(6),
        2: FlexColumnWidth(4),
        3: FlexColumnWidth(4),
      },
      border: TableBorder.all(
          color: Colors.black, style: BorderStyle.solid, width: 1),
      children: [
        TableRow(children: [
          Column(children: [
            tableHeadText('S no.'),
          ]),
          Column(
              children: [Text('Role Type', style: TextStyle(fontSize: 16.0))]),
          Column(children: [Text('Login', style: TextStyle(fontSize: 16.0))]),
          Column(
              children: [Text('Subscribed', style: TextStyle(fontSize: 16.0))]),
        ]),
        TableRow(children: [
          Column(children: [Text('1')]),
          Column(children: [Text('Job-Seeker')]),
          Column(children: [Text('8')]),
          Column(children: [Text('7')]),
        ]),
        TableRow(children: [
          Column(children: [Text('2')]),
          Column(children: [Text('Recruiter')]),
          Column(children: [Text('10')]),
          Column(children: [Text('5')]),
        ]),
        TableRow(children: [
          Column(children: [Text('3')]),
          Column(children: [Text('Home Service Provider')]),
          Column(children: [Text('23')]),
          Column(children: [Text('21')]),
        ]),
        TableRow(children: [
          Column(children: [Text('4')]),
          Column(children: [Text('Home Service Seeker')]),
          Column(children: [Text('28')]),
          Column(children: [Text('24')]),
        ]),
        TableRow(children: [
          Column(children: [Text('5')]),
          Column(children: [Text('Local Hunar')]),
          Column(children: [Text('23')]),
          Column(children: [Text('21')]),
        ]),
      ],
    );
  }

  tableHeadText(text) {
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: Text('$text', style: TextStyle(fontSize: 16.0)),
    );
  }

  tableDataText(text) {
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: Text(
        '$text',
      ),
    );
  }

  viewAllOutLinedButton(context, {styles, required VoidCallback onTap}) {
    return OutlinedButton(
      onPressed: onTap,
      child: Container(
        alignment: Alignment.center,
        width: Responsive.isDesktop(context)
            ? null
            : Sizeconfig.screenWidth! / 3.5,
        child: Padding(
          padding: Responsive.isDesktop(context)
              ? const EdgeInsets.symmetric(horizontal: 20)
              : const EdgeInsets.symmetric(vertical: 10),
          child: Text("VIEW ALL", style: styles.copyWith()),
        ),
      ),
      style:
          OutlinedButton.styleFrom(side: const BorderSide(color: Colors.black)),
    );
  }

  Widget cardsRow() {
    return Consumer(builder: (context, ref, child) {
      String totalBussinessCorrespondence =
              ref.watch(businessCorrespondance).totalBussinessCorrespondence,
          totalNumberRegistrees =
              ref.watch(businessCorrespondance).totalNumberRegistrees,
          totalComission = ref.watch(businessCorrespondance).totalComission,
          newCommission = ref.watch(businessCorrespondance).newCommission;
      return Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: [
          if (userData!.userRoleType != RoleTypeConstant.fieldSalesExecutive)
            labelWithBox(
                count: newCommission,
                label: Responsive.isDesktop(context)
                    ? 'Today Commission\n'
                    : 'Today Commission',
                value: 3),
          if (userData!.userRoleType != RoleTypeConstant.fieldSalesExecutive)
            labelWithBox(
                count: totalComission,
                label: Responsive.isDesktop(context)
                    ? 'Total Commission\n'
                    : 'Total Commission',
                value: 3),
          labelWithBox(
              count: totalNumberRegistrees,
              label: Responsive.isDesktop(context)
                  ? 'Total Registerees\n'
                  : 'Total Registerees',
              value: 1),
          if (userData!.userRoleType != RoleTypeConstant.advisor &&
              userData!.userRoleType != RoleTypeConstant.fieldSalesExecutive)
            labelWithBox(
                count: totalBussinessCorrespondence,
                label: Responsive.isDesktop(context)
                    ? 'Total Sub BC\n'
                    : 'Total Sub BC',
                value: 2),
        ],
      );
    });
  }

  labelWithBox({count, label, value}) {
    return InkWell(
      onTap: () {
        widget.onChangeTab(value);
      },
      child: SizedBox(
          width: Responsive.isDesktop(context)
              ? MediaQuery.of(context).size.width * 0.21
              : MediaQuery.of(context).size.width * 0.45,
          child: Padding(
              padding: EdgeInsets.fromLTRB(
                  Responsive.isDesktop(context) ? 0.0 : 0,
                  Responsive.isDesktop(context) ? 8.0 : 0,
                  Responsive.isDesktop(context) ? 8.0 : 5,
                  Responsive.isDesktop(context) ? 8.0 : 0),
              child: cards(
                  icon: 'assets/videos_icon.png', count: count, text: label))),
    );
  }

  Widget cards({icon, text, count}) {
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
              Responsive.isDesktop(context) ? 0.80 : 0.78,
              0.3,
              0.3,
              0.7,
            ]),
      ),
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
                    left: Responsive.isDesktop(context) ? 6.0 : 0.0,
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
                              ? whiteDarkR22
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
                  Padding(
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
              ],
            ),
            if (!Responsive.isDesktop(context))
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
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
                ],
              ),
          ],
        ),
      ),
    );
  }
}

//recently earned
class RecentlyEarned extends StatelessWidget {
  Function onChangeTab;
  RecentlyEarned({Key? key, required this.onChangeTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return recentlyEarnedWidget(context);
  }

  recentlyEarnedWidget(context) {
    return Consumer(builder: (context, ref, child) {
      List<Commision> commisionData =
          ref.watch(businessCorrespondance).commisionList;
      return Responsive.isDesktop(context)
          ? Expanded(
              child: Padding(
              padding: EdgeInsets.only(
                  right: Responsive.isDesktop(context) ? 16.0 : 0),
              child: Container(
                  height: Responsive.isDesktop(context) ? 450 : 0,
                  color: MyAppColor.lightGrey,
                  child: Padding(
                    padding: EdgeInsets.all(
                        Responsive.isDesktop(context) ? 20.0 : 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('RECENTLY EARNED COMMISSIONS',
                            style: blackRegular14),
                        SizedBox(
                            height: Responsive.isDesktop(context) ? 20 : 0),
                        headerRowWindow(),
                        listViewWindow(commisionData),
                        SizedBox(
                            height: Responsive.isDesktop(context) ? 20 : 0),
                        viewAllButtonWindow()
                      ],
                    ),
                  )),
            ))
          : Container(
              color: MyAppColor.grayplane,
              child: Padding(
                padding:
                    EdgeInsets.all(Responsive.isDesktop(context) ? 30.0 : 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('RECENTLY EARNED COMMISSIONS', style: blackRegular14),
                    SizedBox(height: Responsive.isDesktop(context) ? 20 : 10),
                    MySlider(
                        onChangeTab: () => {},
                        flag: 'earned-commission',
                        listBusinessCorrespondanceCount: commisionData),
                    viewAllButton()
                  ],
                ),
              ));
    });
  }

  //windows views

  itemWIndow({flex, text, alignment}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          alignment: alignment,
          color: MyAppColor.grayplane,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              "$text",
              style: black12,
            ),
          ),
        ),
      ),
    );
  }

  itemReasonWIndow({flex, text, alignment, style}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
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

  headerRowWindow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        itemReasonWIndow(
            flex: 1,
            text: 'S.NO.',
            alignment: Alignment.center,
            style: black10),
        itemReasonWIndow(
            flex: 3,
            text: 'REASON',
            alignment: Alignment.center,
            style: black10),
        itemReasonWIndow(
            flex: 2, text: 'DATE', alignment: Alignment.center, style: black10),
        itemReasonWIndow(
            flex: 2,
            text: 'MY COMMISION',
            alignment: Alignment.center,
            style: black10),
      ],
    );
  }

  listViewWindow(List<Commision> commisionData) {
    return Expanded(
      child: ListView.builder(
          itemCount: commisionData.length > 4 ? 4 : commisionData.length,
          itemBuilder: (BuildContext context, int index) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                itemWIndow(
                    flex: 1, text: index + 1, alignment: Alignment.center),
                itemReasonWIndow(
                    flex: 3,
                    text: commisionData[index].reason,
                    alignment: Alignment.center),
                itemWIndow(
                    flex: 2,
                    text: formatDate(commisionData[index].date),
                    alignment: Alignment.center),
                itemWIndow(
                    flex: 2,
                    text: commisionData[index].myCommissionAmount,
                    alignment: Alignment.centerRight)
              ],
            );
          }),
    );
  }

  viewAllButtonWindow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                primary: MyAppColor.greynormal,
                side: BorderSide(width: 1.0, color: MyAppColor.black)),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
              child: Text(
                'VIEW ALL',
                style: black14,
              ),
            )),
      ],
    );
  }

//mobile views
  slider() {
    return Expanded(
      child: ListView.builder(
          itemCount: 5,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return mobileView(context);
          }),
    );
  }

  mobileView(context) {
    return Container(
      color: MyAppColor.grey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('#01', style: grey12),
                  Wrap(
                    children: [
                      Text("date", style: blackDarkSb10()),
                      const Icon(Icons.calendar_today_rounded, size: 11)
                    ],
                  ),
                ]),
            const SizedBox(
              height: 15,
            ),
            Text('₹ 499.00', style: blackDarkSemiBold16),
            Text('My Commission', style: blackMedium12),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                color: MyAppColor.grayplane,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Reason', style: blackDarkR10()),
                      Text("reason", style: blackDarkSemibold14)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  viewAllButton() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            onChangeTab(3);
          },
          style: ElevatedButton.styleFrom(
              primary: MyAppColor.greynormal,
              elevation: 0,
              side: BorderSide(width: 1.0, color: MyAppColor.black)),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 28, right: 28, top: 10, bottom: 10),
            child: Text(
              'VIEW ALL',
              style: blackRegular14,
            ),
          ),
        )
      ],
    );
  }
}

//recent ttransacions
class RecentTransactions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return recentTransactionsWidget(context);
  }

  recentTransactionsWidget(context) {
    return Consumer(builder: (context, ref, child) {
      List<Registree> registreeList =
          ref.watch(businessCorrespondance).registreeList;
      return Responsive.isDesktop(context)
          ? Expanded(
              child: Container(
                  height: Responsive.isDesktop(context) ? 450 : 0,
                  color: MyAppColor.lightGrey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'RECENT TRANSACTIONS',
                          style: blackRegular14,
                        ),
                        SizedBox(
                          height: Responsive.isDesktop(context) ? 20 : 0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            itemWIndow(text: 'DATE', flex: 2, style: black10),
                            itemWIndow(
                                text: 'TRANSACTION ID',
                                style: black10,
                                flex: 4),
                            itemWIndow(
                                style: black10,
                                flex: 4,
                                text: 'COMMISSION TRANSACTION AMOUNT')
                          ],
                        ),
                        SizedBox(
                          height: Responsive.isDesktop(context) ? 0 : 0,
                        ),
                        Expanded(child: listViewWindow(registreeList)),
                        SizedBox(
                          height: Responsive.isDesktop(context) ? 20 : 0,
                        ),
                        viewAllButtonWindow()
                      ],
                    ),
                  )))
          : Container(
              color: MyAppColor.lightGrey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RECENT TRANSACTIONS',
                    style: blackRegular14,
                  ),
                  SizedBox(
                    height: Responsive.isDesktop(context) ? 20 : 10,
                  ),
                  MySlider(
                      onChangeTab: () => {},
                      flag: 'transaction',
                      listBusinessCorrespondanceCount: registreeList),
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
              ));
    });
  }

  viewAllButtonWindow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                primary: MyAppColor.greynormal,
                side: BorderSide(width: 1.0, color: MyAppColor.black)),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
              child: Text(
                'VIEW ALL',
                style: black14,
              ),
            )),
      ],
    );
  }

  itemWIndow({flex, text, alignment, style}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
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

  Widget listViewWindow(List<Registree> registreeList) {
    return ListView.builder(
        itemCount: registreeList.length,
        itemBuilder: (BuildContext context, int index) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              itemWIndow(
                  flex: 2,
                  text: formatDate(registreeList[index].dateRegistered),
                  alignment: Alignment.center),
              itemWIndow(
                  flex: 4,
                  text: registreeList[index].registeredUser!.name,
                  alignment: Alignment.centerLeft),
              itemWIndow(
                  flex: 4, text: "amount", alignment: Alignment.centerRight),
            ],
          );
        });
  }
}

//MY REGISTREE SUMMARY
class MyRegistreeSummery extends StatefulWidget {
  Function onChangeTab;
  MyRegistreeSummery({required this.onChangeTab});
  @override
  State<MyRegistreeSummery> createState() => _MyRegistreeSummeryState();
}

class _MyRegistreeSummeryState extends State<MyRegistreeSummery> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      List<BusinessCorrespondanceCount> listBusinessCorrespondanceCount =
          ref.watch(businessCorrespondance).listBusinessCorrespondanceCount;
      return Responsive.isDesktop(context)
          ? Container(
              height: Responsive.isDesktop(context) ? 380 : 0,
              color: MyAppColor.lightGrey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MY REGISTREE SUMMARY',
                      style: blackRegular14,
                    ),
                    SizedBox(
                      height: Responsive.isDesktop(context) ? 20 : 0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        itemWIndow(
                            text: 'S.NO',
                            flex: 1,
                            alignment: Alignment.center,
                            style: black10),
                        itemWIndow(
                            text: "REGISTREE'S ROLE", flex: 3, style: black10),
                        itemWIndow(
                            flex: 3,
                            text: 'TOTAL NO. OF REGISTREES',
                            style: black10),
                        itemWIndow(
                            text: 'NO. OF REGISTREES CURRENTLY ON SUBSCRIPTION',
                            flex: 4,
                            style: black10),
                        itemWIndow(
                            text:
                                "NO. OF REGISTREES CURRENTLY NOT ON SUBSCRIPTION",
                            flex: 4,
                            style: black10),
                      ],
                    ),
                    Expanded(
                        child: listViewWindow(listBusinessCorrespondanceCount)),
                    SizedBox(
                      height: Responsive.isDesktop(context) ? 20 : 0,
                    ),
                  ],
                ),
              ))
          : Container(
              color: MyAppColor.lightGrey,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MY REGISTREE SUMMARY',
                      style: blackRegular14,
                    ),
                    SizedBox(
                      height: Responsive.isDesktop(context) ? 20 : 10,
                    ),
                    MySlider(
                      onChangeTab: widget.onChangeTab,
                      listBusinessCorrespondanceCount:
                          listBusinessCorrespondanceCount,
                    )
                  ],
                ),
              ));
    });
  }

  //
  Widget listViewWindow(
      List<BusinessCorrespondanceCount> listBusinessCorrespondanceCount) {
    return ListView.builder(
        itemCount: listBusinessCorrespondanceCount.length,
        itemBuilder: (BuildContext context, int index) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              itemWIndow(
                flex: 1,
                text: index + 1,
                alignment: Alignment.center,
              ),
              itemWIndow(
                  flex: 3,
                  text: listBusinessCorrespondanceCount[index].userRoleType,
                  alignment: Alignment.centerLeft),
              itemWIndow(
                  flex: 3,
                  text: listBusinessCorrespondanceCount[index].count,
                  alignment: Alignment.centerLeft),
              itemWIndow(
                  flex: 4,
                  onTap: () {
                    widget.onChangeTab(1,
                        registerRole:
                            listBusinessCorrespondanceCount[index].userRoleType,
                        registerStatus: 'active');
                  },
                  text: listBusinessCorrespondanceCount[index]
                      .registreesCurrentlyOnSubscription,
                  alignment: Alignment.centerLeft),
              itemWIndow(
                  flex: 4,
                  onTap: () {
                    widget.onChangeTab(1,
                        registerRole:
                            listBusinessCorrespondanceCount[index].userRoleType,
                        registerStatus: 'inactive');
                  },
                  text: listBusinessCorrespondanceCount[index]
                      .registreesCurrentlyNotOnSubscription,
                  alignment: Alignment.centerLeft),
            ],
          );
        });
  }

  arrowButton(context) {
    return Expanded(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            color: MyAppColor.grayplane,
            alignment: Alignment.center,
            height: Responsive.isDesktop(context) ? 37 : 55,
            child: Container(
                margin: const EdgeInsets.all(7),
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(
                            4.0) //                 <--- border radius here
                        ),
                    border: Border.all(color: MyAppColor.black)),
                child: Image.asset(
                  'assets/forward_arrow.png',
                  color: MyAppColor.black,
                )),
          ),
        ));
  }

  //
  itemWIndow({flex, text, alignment, style, onTap}) {
    return Expanded(
      flex: flex,
      child: InkWell(
        onTap: () {
          if (onTap != null) {
            onTap();
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 2),
          child: Container(
            alignment: alignment,
            color: MyAppColor.grayplane,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "$text",
                style: style ?? black12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  //
  viewAllButtonWindow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                primary: MyAppColor.greynormal,
                side: BorderSide(width: 1.0, color: MyAppColor.black)),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
              child: Text(
                'VIEW ALL',
                style: black14,
              ),
            )),
      ],
    );
  }
}

class MySlider extends StatefulWidget {
  String? cardState;
  final flag;
  List listBusinessCorrespondanceCount;
  Function onChangeTab;

  bool isShortListed;
  MySlider(
      {Key? key,
      this.cardState,
      required this.onChangeTab,
      required this.listBusinessCorrespondanceCount,
      this.isShortListed = false,
      this.flag})
      : super(key: key);

  @override
  State<MySlider> createState() => _MySliderState();
}

class _MySliderState extends State<MySlider> {
  int currentLate = 0;
  List cardList = [];
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    cardList = [
      for (var i = 0; i < widget.listBusinessCorrespondanceCount.length; i++)
        LatestJob(),
    ];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.listBusinessCorrespondanceCount.length > 4
              ? 4
              : widget.listBusinessCorrespondanceCount.length,
          itemBuilder: (context, index, _) {
            return widget.flag == 'earned-commission'
                ? earnedCommissionMobileView(context,
                    widget.listBusinessCorrespondanceCount[index], index)
                : widget.flag == 'transaction'
                    ? transactionMobileView(
                        widget.listBusinessCorrespondanceCount[index], index)
                    : registreeSummery(
                        widget.listBusinessCorrespondanceCount[index]);
          },
          options: CarouselOptions(
            viewportFraction: 1.0,
            enableInfiniteScroll: false,
            height: widget.flag == 'earned-commission'
                ? Sizeconfig.screenHeight! / 3
                : widget.flag == 'transaction'
                    ? Sizeconfig.screenHeight! / 3.5
                    : Sizeconfig.screenHeight! / 4,
            aspectRatio: 3,
            autoPlay: false,
            onPageChanged: (index, _) {
              setState(
                () {
                  currentLate = index;
                },
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: map<Widget>([
            ...widget.listBusinessCorrespondanceCount.length > 4
                ? widget.listBusinessCorrespondanceCount.take(4)
                : widget.listBusinessCorrespondanceCount
          ], (index, url) {
            return Container(
              width: 4.0,
              height: 4.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    currentLate == index ? MyAppColor.orangedark : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }

  registreeSummery(BusinessCorrespondanceCount businessCorrespondanceCount) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        color: MyAppColor.grayplane,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${businessCorrespondanceCount.userRoleType}',
                      style: blackDarkSemiBold16),
                  Text(
                      "TOTAL REGISTREE'S = ${businessCorrespondanceCount.count}",
                      style: blackMedium12),
                ],
              ),
              Text("REGISTREE'S ROLE", style: blackMedium12),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        widget.onChangeTab(1,
                            registerRole:
                                businessCorrespondanceCount.userRoleType,
                            registerStatus: 'inactive');
                      },
                      child: Container(
                        color: MyAppColor.lightNormalGray,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                    '${businessCorrespondanceCount.registreesCurrentlyNotOnSubscription}',
                                    style: blackDarkSemibold14),
                                Text('Logined\nRegistrees',
                                    style: blackDarkR10())
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(color: MyAppColor.white, width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        widget.onChangeTab(1,
                            registerRole:
                                businessCorrespondanceCount.userRoleType,
                            registerStatus: 'active');
                      },
                      child: Container(
                        color: MyAppColor.lightNormalGray,
                        // width: Sizeconfig.screenWidth,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                    '${businessCorrespondanceCount.registreesCurrentlyOnSubscription}',
                                    style: blackDarkSemibold14),
                                Text('Subscribed\nRegistrees',
                                    style: blackDarkR10())
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  transactionMobileView(Registree registree, index) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        color: MyAppColor.grey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('#${01}', style: grey12),
                    Wrap(
                      children: [
                        Text('22.12.2022', style: blackDarkSb10()),
                        const Icon(Icons.calendar_today_rounded, size: 11)
                      ],
                    ),
                  ]),
              const SizedBox(
                height: 15,
              ),
              Text('₹ 499.00', style: blackDarkSemiBold16),
              Text('COMMISSION TRANSACTION AMOUNT', style: blackMedium12),
              const SizedBox(
                height: 10,
              ),
              Container(
                color: MyAppColor.grayplane,
                width: Sizeconfig.screenWidth,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Transaction ID', style: blackDarkR10()),
                      Text('ABG123456BGH112345', style: blackDarkSemibold14)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  earnedCommissionMobileView(context, Commision commision, index) {
    return Container(
      color: MyAppColor.grey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('#${index + 1}', style: grey12),
                  Wrap(
                    children: [
                      Text('${formatDate(commision.date)}',
                          style: blackDarkSb10()),
                      const Icon(Icons.calendar_today_rounded, size: 11)
                    ],
                  ),
                ]),
            const SizedBox(
              height: 15,
            ),
            Text('₹ ${commision.myCommissionAmount}',
                style: blackDarkSemiBold16),
            Text('My Commission', style: blackMedium12),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                color: MyAppColor.grayplane,
                width: Sizeconfig.screenWidth,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Reason', style: blackDarkR10()),
                      Text('${commision.reason}', style: blackDarkSemibold14)
                    ],
                  ),
                ),
              ),
            )
          ],
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
                : const SizedBox(),
            Center(child: Text(text, style: whiteBoldGalano12)),
          ],
        ),
      ),
    );
  }
}
