// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/model/registree_model.dart';
import 'package:hindustan_job/candidate/model/transactions_historires_model.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/clusterManager/registree_details_screen.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/label_string.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';

import '../candidate/dropdown/dropdown_list.dart';
import '../candidate/model/addbank/getbank.dart';
import '../candidate/model/addbank/wallet_transactions.dart';
import '../candidate/pages/job_seeker_page/home/drawer/wallet/bankaccount_edit.dart';
import '../candidate/pages/job_seeker_page/home/homeappbar.dart';
import '../candidate/theme_modeule/desktop_style.dart';
import '../candidate/theme_modeule/theme.dart';
import '../services/api_services/user_services.dart';
import '../services/auth/auth.dart';
import '../services/services_constant/constant.dart';
import '../widget/drop_down_widget/text_drop_down_widget.dart';

class MyCommisssionScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyCommisssionScreen> createState() =>
      _MyCommisssionScreenState();
}

class _MyCommisssionScreenState extends ConsumerState<MyCommisssionScreen>
    with TickerProviderStateMixin {
  List roleList = ['New Commission', 'Transaction History', 'Bank Details'];

  String sortValue = "Month";
  String sortYear = "Year";
  String sortBy = "Sort by Relevance";
  var filterData = {};

  TabController? _tabController;
  int _tabIndex = 0;
  dynamic walletAmount = 0;
  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  List<Widget> myTabs = [];
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController!.addListener(_handleTabSelection);
    super.initState();
    getAmount();
    ref.read(editProfileData).getBankDetails(context);
    ref.read(editProfileData).getWalletTransactions(context, filterData: {});
    ref.read(editProfileData).getTransactionHistories(context, filterData: {});
    myTabs = [
      Container(child: Tab(text: roleList[0])),
      Container(child: Tab(text: roleList[1])),
    ];
  }

  getAmount() async {
    ApiResponse response = await getWalletAmount();
    if (response.status == 200) {
      walletAmount = response.body!.walletMoney!;
    }
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
  int group = 1;

  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme.headline1!;
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
                                  labelPadding: const EdgeInsets.all(0),
                                  tabs: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Tab(
                                        text: roleList[0],
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Tab(
                                        text: roleList[1],
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Tab(
                                        text: roleList[2],
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
                const SizedBox(
                  height: 20,
                ),
                // if (Responsive.isDesktop(context)) menuRow(),
                Consumer(builder: (context, ref, child) {
                  List<Transactions> walletTransactions =
                      ref.watch(editProfileData).walletTransactions;
                  List<TransactionHistories> transactionHistories =
                      ref.watch(editProfileData).transactionHisotries;

                  return Center(
                    child: [
                      tab1Widget(walletTransactions, [], tabName: roleList[0]),
                      tab1Widget([], transactionHistories,
                          tabName: roleList[1]),
                      Consumer(
                        builder: (context, ref, child) {
                          Data? getaAdd = ref.watch(editProfileData).addBank;
                          return getaAdd != null
                              ? _myWalletBank(
                                  styles,
                                  getaAdd,
                                )
                              : Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 50.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BankAccountEdit(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Add Bank Account',
                                          style: whiteSb14(),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: MyAppColor.orangelight,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                        },
                      ),
                    ][_tabIndex],
                  );
                }),
              ],
            ),
    );
  }

  Widget _myWalletBank(TextStyle styles, getAdd) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              alignment: Alignment.center,
              color: MyAppColor.greylight,
              height: Sizeconfig.screenHeight! / 10,
              width: !Responsive.isDesktop(context)
                  ? double.infinity
                  : Sizeconfig.screenWidth! / 1.9,
              child: Text(
                'My Bank Details',
                style: whiteSb14(),
              ),
            ),
            Positioned(
              top: 00,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/contact-image.png', height: 18),
                  Image.asset(
                    'assets/contact-image-down.png',
                    height: 18,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 00,
              right: 00,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/contact-image-down.png',
                    height: 18,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 00,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/contact-page-downs.png', height: 18),
                ],
              ),
            ),
            Positioned(
              bottom: 00,
              right: 00,
              child: Image.asset('assets/contact-image-left.png', height: 18),
            ),
          ],
        ),
        Container(
          width: Responsive.isDesktop(context)
              ? Sizeconfig.screenWidth! / 1.9
              : Sizeconfig.screenWidth!,
          color: MyAppColor.greynormal,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              // if (getAdd != null)
              InkWell(
                onTap: () async {
                  bool check = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BankAccountEdit(
                        getAdd: getAdd != null
                            ? ref.watch(editProfileData).addBank!
                            : null,
                      ),
                    ),
                  );
                  if (check) {
                    ref.watch(editProfileData).getBankDetails(context);
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(
                      right: !Responsive.isDesktop(context) ? 10 : 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        "assets/editdetail.png",
                        height: 14,
                        width: 14,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        "edit bank details",
                        style: orangeDarkSb12(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                "assets/bankdetailimg.png",
                height: 90,
                width: 90,
              ),
              !Responsive.isDesktop(context)
                  ? Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 8),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          _fullNameRegistered(text: getAdd.fullRegisteredName),
                          const SizedBox(
                            height: 10,
                          ),
                          _bankAccountType(text: getAdd.bankAccountType),
                          const SizedBox(
                            height: 10,
                          ),
                          _bankAccount(text: getAdd.bankAccountNumber),
                          const SizedBox(
                            height: 10,
                          ),
                          _ifscCode(text: getAdd.ifscCode),
                          const SizedBox(
                            height: 10,
                          ),
                          _bankName(text: getAdd.bankName),
                          const SizedBox(
                            height: 10,
                          ),
                          _branchName(text: getAdd.branchName),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _fullNameRegistered(
                                  text: getAdd.fullRegisteredName),
                              _bankAccountType(text: getAdd.bankAccountType),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _bankAccount(text: getAdd.bankAccountNumber),
                              _ifscCode(text: getAdd.ifscCode),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _bankName(text: getAdd.bankName),
                              _branchName(text: getAdd.branchName),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _branchName({String? text}) {
    return Container(
      width: !Responsive.isDesktop(context)
          ? Sizeconfig.screenWidth!
          : Sizeconfig.screenWidth! / 4.6,
      padding: const EdgeInsets.all(10),
      color: MyAppColor.grayplane,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Bank Branch",
                style: appleColorsb10,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                text!,
                style: blackdarkM12,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _bankName({String? text}) {
    return Container(
      width: !Responsive.isDesktop(context)
          ? Sizeconfig.screenWidth!
          : Sizeconfig.screenWidth! / 4.6,
      padding: const EdgeInsets.all(10),
      color: MyAppColor.grayplane,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Bank Name",
                style: appleColorsb10,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(text!, style: blackdarkM12)
            ],
          ),
        ],
      ),
    );
  }

  Widget _ifscCode({String? text}) {
    return Container(
      width: !Responsive.isDesktop(context)
          ? Sizeconfig.screenWidth!
          : Sizeconfig.screenWidth! / 4.6,
      padding: const EdgeInsets.all(10),
      color: MyAppColor.grayplane,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "IFSC Code",
                style: appleColorsb10,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(text!, style: blackdarkM12)
            ],
          ),
        ],
      ),
    );
  }

  Widget _bankAccount({String? text}) {
    return Container(
      width: !Responsive.isDesktop(context)
          ? Sizeconfig.screenWidth!
          : Sizeconfig.screenWidth! / 4.6,
      padding: const EdgeInsets.all(10),
      color: MyAppColor.grayplane,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Bank Account Number",
                style: appleColorsb10,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(text!, style: blackdarkM12)
            ],
          ),
        ],
      ),
    );
  }

  Widget _bankAccountType({String? text}) {
    return Container(
      width: !Responsive.isDesktop(context)
          ? Sizeconfig.screenWidth!
          : Sizeconfig.screenWidth! / 4.6,
      padding: const EdgeInsets.all(10),
      color: MyAppColor.grayplane,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Bank Account Type",
                style: appleColorsb10,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(text!, style: blackdarkM12)
            ],
          ),
        ],
      ),
    );
  }

  Widget _fullNameRegistered({String? text}) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: MyAppColor.grayplane,
      width: !Responsive.isDesktop(context)
          ? Sizeconfig.screenWidth!
          : Sizeconfig.screenWidth! / 4.6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Full Name registered with Bank",
                style: appleColorsb10,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(text!, style: blackdarkM12)
            ],
          ),
        ],
      ),
    );
  }

  tabWidgetMobile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: List.generate(
          20,
          (index) => Container(),
        ).toList(),
      ),
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
                Responsive.isDesktop(context) ? 0.95 : 0.78,
                0.3,
                0.3,
                0.7,
              ]),
        ),
        child: Padding(
            padding: EdgeInsets.all(Responsive.isDesktop(context) ? 4.0 : 8.0),
            child: Row(
                crossAxisAlignment: Responsive.isDesktop(context)
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                mainAxisAlignment: Responsive.isDesktop(context)
                    ? MainAxisAlignment.spaceAround
                    : MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: Responsive.isDesktop(context) ? 8.0 : 14.0,
                      left: Responsive.isDesktop(context) ? 6.0 : 22.0,
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
                        top: Responsive.isDesktop(context) ? 8.0 : 12.0,
                        left: Responsive.isDesktop(context) ? 36.0 : 36.0,
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
                          ),
                          if (!Responsive.isDesktop(context))
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: InkWell(
                                onTap: () async {
                                  await showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(.3),
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
                                            MyAppColor.backgroundColor,
                                        elevation: 10,
                                        title: Text(
                                          "Do You want added money?",
                                          style: TextStyle(
                                              color: MyAppColor.blackdark,
                                              fontSize: 18),
                                        ),
                                        content: Text("Added",
                                            style: TextStyle(
                                                color: MyAppColor.blackdark)),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, 'Cancel'),
                                            child: Text(
                                              'No',
                                              style: TextStyle(
                                                  color: MyAppColor.blackdark),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              await settlebank(walletAmount);
                                              Navigator.pop(context);
                                            },
                                            child: Text('Yes',
                                                style: TextStyle(
                                                    color:
                                                        MyAppColor.blackdark)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                child: orangeButton(text: 'Claim the amount'),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (Responsive.isDesktop(context))
                    orangeButton(text: 'Claim the amount')
                ])));
  }

  Widget orangeButton({text}) {
    return Padding(
      padding: EdgeInsets.only(right: Responsive.isDesktop(context) ? 28.0 : 0),
      child: Row(
        crossAxisAlignment: !Responsive.isDesktop(context)
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        mainAxisAlignment: !Responsive.isDesktop(context)
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: !Responsive.isDesktop(context)
                    ? MyAppColor.orange
                    : MyAppColor.orangedark,
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
      ),
    );
  }

  tab1Widget(List<Transactions> transactions,
      List<TransactionHistories> transactionHistories,
      {tabName}) {
    return Column(
      children: [
        if (_tabIndex == 0)
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Responsive.isDesktop(context) ? 250.0 : 10),
            child: Padding(
                padding: EdgeInsets.fromLTRB(
                    Responsive.isDesktop(context) ? 0.0 : 0,
                    Responsive.isDesktop(context) ? 8.0 : 0,
                    Responsive.isDesktop(context) ? 8.0 : 5,
                    Responsive.isDesktop(context) ? 8.0 : 0),
                child: cards(
                    icon: 'assets/videos_icon.png',
                    count: '₹ $walletAmount',
                    text: Responsive.isDesktop(context)
                        ? 'My Total New Commission'
                        : 'My Total New Commission ')),
          ),
        if (!Responsive.isDesktop(context))
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: menuRow(),
          ),
        transactions.isNotEmpty
            ? Column(
                children: List.generate(transactions.length,
                    (index) => mobileView(context, transactions[index], index)))
            : Column(
                children: List.generate(
                    transactionHistories.length,
                    (index) => mobileTransactionsHistoriesView(
                        context, transactionHistories[index], index))),
        Footer()
      ],
    );
  }

  settlebank(amount) async {
    var settleData = {
      "amount": amount.toString(),
    };
    ApiResponse response = await banksettled(settleData);
    if (response.status == 200) {
      showSnack(context: context, msg: 'Success');
      getWalletAmount();
      // Navigator.pop(context);
    } else {
      showSnack(context: context, msg: response.body!.message, type: 'error');
    }
  }

  tabsRowWindow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 90),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: Responsive.isDesktop(context)
                  ? Sizeconfig.screenWidth! / 3.5
                  : MediaQuery.of(context).size.width - 100,
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                isScrollable: false,
                tabs: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      roleList[0],
                      textAlign: TextAlign.center,
                      style: Responsive.isDesktop(context)
                          ? blackDark12
                          : blackDarkSb10(),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      roleList[1],
                      textAlign: TextAlign.center,
                      style: Responsive.isDesktop(context)
                          ? blackDark12
                          : blackDarkSb10(),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      roleList[2],
                      textAlign: TextAlign.center,
                      style: Responsive.isDesktop(context)
                          ? blackDark12
                          : blackDarkSb10(),
                    ),
                  ),
                ],
                indicatorWeight: 2,
                indicatorColor: MyAppColor.orangelight,
                labelStyle: blackBold12,
                labelPadding: const EdgeInsets.symmetric(horizontal: 0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  menuRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AppDropdownInput(
          hintText: "Month",
          options: monthArray,
          value: sortValue,
          changed: (String value) async {
            sortValue = value;

            filterData['month'] =
                value != 'Month' ? monthArray.indexOf(value) + 1 : null;
            ref.read(editProfileData).filterListingOfWallet(context,
                status: WalletStatus.wallet, filterData: filterData);
            setState(() {});
          },
          getLabel: (String value) => value,
        ),
        AppDropdownInput(
          hintText: 'Year',
          options: yearArray,
          value: sortYear,
          changed: (String value) async {
            sortYear = value;
            filterData['year'] = value != 'Year' ? value : null;
            ref.read(editProfileData).filterListingOfWallet(context,
                status: WalletStatus.wallet, filterData: filterData);
            setState(() {});
          },
          getLabel: (String value) => value,
        ),
        AppDropdownInput(
          hintText: 'Sort by Relevance',
          options: [
            'Ascending',
            'Descending',
          ],
          value: sortBy,
          changed: (String value) async {
            sortBy = value;
            filterData['sortBy'] = value != 'Sort by Relevance' ? value : null;
            ref.read(editProfileData).filterListingOfWallet(context,
                status: WalletStatus.wallet, filterData: filterData);
            setState(() {});
          },
          getLabel: (String value) => value,
        ),
      ],
    );
  }

  mobileView(context, Transactions transactions, index) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        color: MyAppColor.greynormal,
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
                    Text("${index + 1}", style: grey12),
                    Wrap(
                      children: [
                        Text("${formatDate(transactions.updatedAt)}",
                            style: blackDarkSb10()),
                        const Icon(Icons.calendar_today_rounded, size: 11)
                      ],
                    ),
                  ]),
              const SizedBox(
                height: 15,
              ),
              Text("${transactions.amount}", style: blackDarkSemiBold16),
              Text('My Commission Amount', style: blackMedium12),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
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
                        Text("${transactions.details}",
                            style: blackDarkSemibold14)
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  mobileTransactionsHistoriesView(
      context, TransactionHistories transactions, index) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        color: MyAppColor.greynormal,
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
                    Text("${index + 1}", style: grey12),
                    Wrap(
                      children: [
                        Text("${formatDate(transactions.updatedAt)}",
                            style: blackDarkSb10()),
                        const Icon(Icons.calendar_today_rounded, size: 11)
                      ],
                    ),
                  ]),
              const SizedBox(
                height: 15,
              ),
              Text("${transactions.totalAmount}", style: blackDarkSemiBold16),
              Text('Commission Transaction Amount', style: blackMedium12),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  color: MyAppColor.grayplane,
                  width: Sizeconfig.screenWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("${transactions.tnxId}",
                            style: blackDarkSemibold14),
                        Text('Transaction ID', style: blackDarkR10()),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
