// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new, unnecessary_null_comparison


import 'package:hindustan_job/candidate/dropdown/dropdown_list.dart';
import 'package:hindustan_job/candidate/model/addbank/wallet_transactions.dart';
import 'package:hindustan_job/candidate/model/transactions_historires_model.dart';
import 'package:hindustan_job/candidate/model/wallet_settlement_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/drawer/drawer_jobseeker.dart';
import 'package:hindustan_job/services/services_constant/constant.dart';
import 'package:hindustan_job/widget/body/tab_bar_body_widget.dart';
import 'package:hindustan_job/widget/drop_down_widget/text_drop_down_widget.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/header/app_bar.dart';
import 'package:hindustan_job/candidate/model/addbank/getbank.dart';
import 'package:hindustan_job/candidate/model/addbank/settle_bank.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/drawer/wallet/bankaccount_edit.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/services/api_services/user_services.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:hindustan_job/widget/register_page_widget/text_field.dart';

class MyWallet extends ConsumerStatefulWidget {
  const MyWallet({Key? key}) : super(key: key);

  static const String route = '/my-wallet-and-bank-details';

  @override
  ConsumerState createState() => _MyWalletState();
}

class _MyWalletState extends ConsumerState<MyWallet>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  TextEditingController control = TextEditingController();
  DateTime now = DateTime.now();
  TabController? _control;
  Map<String, dynamic> filterData = {};
  String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
  @override
  void initState() {
    super.initState();
    getBalance();
    _control = TabController(initialIndex: 0, length: 4, vsync: this);
    setData();
    tabListner();
  }

  String sortValue = "Month";
  String sortYear = "Year";
  String sortBy = "Sort by Relevance";

  tabListner() {
    _control!.addListener(() {
      setData();
    });
  }

  setData() {
    filterData = {};
    sortValue = "Month";
    sortYear = "Year";
    sortBy = "Sort by Relevance";
    ref
        .read(editProfileData)
        .getTransactionHistories(context, filterData: filterData);
    ref
        .read(editProfileData)
        .getWalletSettlements(context, filterData: filterData);
    ref
        .read(editProfileData)
        .getWalletTransactions(context, filterData: filterData);
    ref.read(editProfileData).getBankDetails(context);
    setState(() {});
  }

  dynamic walletBalance = 0;
  getBalance() async {
    ApiResponse response = await getWalletAmount();
    if (response.status == 200) {
      setState(() {
        walletBalance = response.body!.walletMoney!;
      });
    }
  }

  settlebank(amount) async {
    var settleData = {
      "amount": amount.toString(),
    };
    ApiResponse response = await banksettled(settleData);
    if (response.status == 200) {
      filterData = {
        "page": "1",
        "sortBy": "DESC",
        "month": "02",
        "year": "2022"
      };
      ref
          .read(editProfileData)
          .getWalletTransactions(context, filterData: filterData);
      showSnack(context: context, msg: 'Success');
      Navigator.pop(context);
    } else {
      showSnack(context: context, msg: response.body!.message, type: 'error');
    }
  }

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    final styles = Mytheme.lightTheme(context).textTheme.headline1!;
    return Scaffold(
      backgroundColor: MyAppColor.backgroundColor,
      appBar: CustomAppBar(
        context: context,
        drawerKey: _drawerKey,
        isDisable: true,
        back: "HOME (JOB-SEEKER) / MY WALLET",
      ),
      key: _drawerKey,
      drawer: Drawer(
        child: DrawerJobSeeker(),
      ),
      body: !Responsive.isDesktop(context)
          ? TabBarSliverAppbar(
              length: 4,
              control: _control!,
              tabs: _tab(),
              toolBarHeight: 460,
              headColumn: headList(),
              tabsWidgets: [
                Consumer(builder: (context, ref, child) {
                  List<Transactions> trnasactions =
                      ref.watch(editProfileData).walletTransactions;

                  return _myWalletTransaction(trnasactions);
                }),
                Consumer(builder: (context, ref, child) {
                  List<WalletSettleMent> walletSettleMent =
                      ref.watch(editProfileData).walletSettlements;

                  return _myWalletSettlement(walletSettleMent);
                }),
                Consumer(builder: (context, ref, child) {
                  List<TransactionHistories> transactionHistories =
                      ref.watch(editProfileData).transactionHisotries;
                  return _myTransactionHistories(transactionHistories);
                }),
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
                                        builder: (context) => BankAccountEdit(),
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
              ],
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 5,
                        child: Container(
                          padding: EdgeInsets.all(30),
                          width: Sizeconfig.screenWidth!,
                          child: Column(
                            children: [
                              _walletCard(),
                              SizedBox(
                                height: 7,
                              ),
                              _transferMoney(),
                              SizedBox(
                                height: 2,
                              ),
                              _enterAmount(),
                              SizedBox(
                                height: 2,
                              ),
                              _pleaseNote(),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 14,
                        child: Container(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      height: 40,
                                    ),
                                    Positioned(
                                      child: SizedBox(
                                        child: DefaultTabController(
                                          length: 4,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width:
                                                      Sizeconfig.screenWidth! /
                                                          2,
                                                  child: _tab(),
                                                ),
                                                SingleChildScrollView(
                                                  child: Container(
                                                    width: Sizeconfig
                                                            .screenWidth! /
                                                        1.4,
                                                    height:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    child: TabBarView(
                                                      controller: _control,
                                                      children: [
                                                        Consumer(builder:
                                                            (context, ref,
                                                                child) {
                                                          List<Transactions>
                                                              trnasactions = ref
                                                                  .watch(
                                                                      editProfileData)
                                                                  .walletTransactions;

                                                          return _myWalletTransaction(
                                                              trnasactions);
                                                        }),
                                                        Consumer(builder:
                                                            (context, ref,
                                                                child) {
                                                          List<WalletSettleMent>
                                                              walletSettleMent =
                                                              ref
                                                                  .watch(
                                                                      editProfileData)
                                                                  .walletSettlements;

                                                          return _myWalletSettlement(
                                                              walletSettleMent);
                                                        }),
                                                        Consumer(
                                                          builder: (context,
                                                              ref, child) {
                                                            List<TransactionHistories>
                                                                transactionHistories =
                                                                ref
                                                                    .watch(
                                                                        editProfileData)
                                                                    .transactionHisotries;
                                                            return _myTransactionHistories(
                                                                transactionHistories);
                                                          },
                                                        ),
                                                        Consumer(
                                                          builder: (context,
                                                              ref, child) {
                                                            Data? getaAdd = ref
                                                                .watch(
                                                                    editProfileData)
                                                                .addBank;
                                                            return getaAdd !=
                                                                    null
                                                                ? SizedBox(
                                                                    width: Sizeconfig
                                                                            .screenWidth! /
                                                                        2,
                                                                    child:
                                                                        _myWalletBank(
                                                                      styles,
                                                                      getaAdd,
                                                                    ),
                                                                  )
                                                                : Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(top: 50.0),
                                                                        child:
                                                                            ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                builder: (context) => BankAccountEdit(),
                                                                              ),
                                                                            );
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            'Add Bank Account',
                                                                            style:
                                                                                whiteSb14(),
                                                                          ),
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            primary:
                                                                                MyAppColor.orangelight,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                          },
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
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Footer()
                ],
              ),
            ),
    );
  }

  headList() {
    return Column(
      children: [
        _walletCard(),
        SizedBox(
          height: 8,
        ),
        _transferMoney(),
        SizedBox(
          height: 4,
        ),
        _enterAmount(),
        SizedBox(
          height: 2,
        ),
        _pleaseNote(),
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Text(
            ".  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . ",
            style: TextStyle(color: MyAppColor.backgray),
          ),
        ),
      ],
    );
  }


  
  Widget sortByrelevence(constant) {
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
                status: constant, filterData: filterData);
            setState(() {});
          },
          getLabel: (String value) => value,
        ),
        AppDropdownInput(
          hintText: 'Year',
          options:yearArray,
          value: sortYear,
          changed: (String value) async {
            sortYear = value;
            filterData['year'] = value != 'Year' ? value : null;
            ref.read(editProfileData).filterListingOfWallet(context,
                status: constant, filterData: filterData);
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
                status: constant, filterData: filterData);
            setState(() {});
          },
          getLabel: (String value) => value,
        ),
      ],
    );
  }

  Widget _myWalletBank(TextStyle styles, getAdd) {
    // Data getAdd = ref.watch(editProfileData).addBank!;

    return ListView(
      children: [
        SizedBox(
          height: 35,
        ),
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
              SizedBox(
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
                      SizedBox(
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
              SizedBox(
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
                          SizedBox(
                            height: 20,
                          ),
                          _fullNameRegistered(text: getAdd.fullRegisteredName),
                          SizedBox(
                            height: 10,
                          ),
                          _bankAccountType(text: getAdd.bankAccountType),
                          SizedBox(
                            height: 10,
                          ),
                          _bankAccount(text: getAdd.bankAccountNumber),
                          SizedBox(
                            height: 10,
                          ),
                          _ifscCode(text: getAdd.ifscCode),
                          SizedBox(
                            height: 10,
                          ),
                          _bankName(text: getAdd.bankName),
                          SizedBox(
                            height: 10,
                          ),
                          _branchName(text: getAdd.branchName),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        SizedBox(
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
                        SizedBox(
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
                        SizedBox(
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
                        SizedBox(
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
      padding: EdgeInsets.all(10),
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
              SizedBox(
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
      padding: EdgeInsets.all(10),
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
              SizedBox(
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
      padding: EdgeInsets.all(10),
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
              SizedBox(
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
      padding: EdgeInsets.all(10),
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
              SizedBox(
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
      padding: EdgeInsets.all(10),
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
              SizedBox(
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
      padding: EdgeInsets.all(10),
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
              SizedBox(
                height: 4,
              ),
              Text(text!, style: blackdarkM12)
            ],
          ),
        ],
      ),
    );
  }

  Widget _myWalletTransaction(List<Transactions> transactions) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 25,
                bottom: 5,
                left: 15,
              ),
              child: sortByrelevence(WalletStatus.wallet),
            ),
            Column(
                children: List.generate(
              transactions.length,
              (index) => Container(
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.only(top: 20),
                color: MyAppColor.greynormal,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/walletblack.png",
                              height: 15,
                              width: 15,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text((index + 1).toString())
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              formatDate(transactions[index].createdAt),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Image.asset(
                              "assets/calander.png",
                              height: 15,
                              width: 15,
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Credit",
                              style: companyNameM11(),
                            ),
                            Text(transactions[index].amount.toString(),
                                style: blackDarkSb14()),
                            Text(
                              "AMOUNT",
                              style: blackdarkM8,
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Text(
                            //   "Commission earned for a",
                            //   style: TextStyle(
                            //     color: Colors.black,
                            //     fontSize: 11,
                            //   ),
                            // ),
                            // Text(
                            //   "Reference Subscribed",
                            //   style: TextStyle(
                            //     color: Colors.black,
                            //     fontSize: 11,
                            //   ),
                            // ),
                            Text(
                              "${transactions[index].reason}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  Widget _myWalletSettlement(List<WalletSettleMent> walletSettleMents) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 25,
                bottom: 5,
                left: 15,
              ),
              child: sortByrelevence(WalletStatus.settlement),
            ),
            Column(
                children: List.generate(
              walletSettleMents.length,
              (index) => Container(
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.only(top: 20),
                color: MyAppColor.greynormal,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/walletblack.png",
                              height: 15,
                              width: 15,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text((index + 1).toString())
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              formatDate(walletSettleMents[index].createdAt),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Image.asset(
                              "assets/calander.png",
                              height: 15,
                              width: 15,
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Credit",
                              style: companyNameM11(),
                            ),
                            Text(walletSettleMents[index].amount.toString(),
                                style: blackDarkSb14()),
                            Text(
                              "AMOUNT",
                              style: blackdarkM8,
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Text(
                            //   "Commission earned for a",
                            //   style: TextStyle(
                            //     color: Colors.black,
                            //     fontSize: 11,
                            //   ),
                            // ),
                            // Text(
                            //   "Reference Subscribed",
                            //   style: TextStyle(
                            //     color: Colors.black,
                            //     fontSize: 11,
                            //   ),
                            // ),
                            Text(
                              "${walletSettleMents[index].status}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  Widget _myTransactionHistories(
      List<TransactionHistories> transactionHistories) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 25,
              bottom: 5,
              left: 15,
            ),
            child: sortByrelevence(WalletStatus.transaction),
          ),
          Column(
              children: List.generate(
            transactionHistories.length,
            (index) => Container(
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.only(top: 20),
              color: MyAppColor.greynormal,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            "assets/walletblack.png",
                            height: 15,
                            width: 15,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text((index + 1).toString())
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            formatDate(transactionHistories[index].createdAt),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Image.asset(
                            "assets/calander.png",
                            height: 15,
                            width: 15,
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Credit",
                            style: companyNameM11(),
                          ),
                          Text(
                              transactionHistories[index]
                                  .totalAmount
                                  .toString(),
                              style: blackDarkSb14()),
                          Text(
                            "AMOUNT",
                            style: blackdarkM8,
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Text(
                          //   "Commission earned for a",
                          //   style: TextStyle(
                          //     color: Colors.black,
                          //     fontSize: 11,
                          //   ),
                          // ),
                          // Text(
                          //   "Reference Subscribed",
                          //   style: TextStyle(
                          //     color: Colors.black,
                          //     fontSize: 11,
                          //   ),
                          // ),
                          Text(
                            transactionHistories[index].paymentStatus??"FAILED",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          )),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  TabBar _tab() {
    return TabBar(
        isScrollable: true,
        controller: _control,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: MyAppColor.orangelight,
        labelColor: Colors.black,
        labelStyle: TextStyle(
          fontSize: 12,
        ),
        tabs: [
          Text(
            "Wallet Transactions",
            style: blackDark12,
            textAlign: TextAlign.center,
          ),
          Text(
            "Wallet Settlements",
            style: blackDark12,
            textAlign: TextAlign.center,
          ),
          Text(
            "Transaction Histories",
            style: blackDark12,
            textAlign: TextAlign.center,
          ),
          Text(
            "My Bank Details",
            textAlign: TextAlign.center,
            style: blackDark12,
          ),
        ]);
  }

  _pleaseNote() {
    return Container(
      width: Sizeconfig.screenWidth,
      color: MyAppColor.greynormal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: RichText(
                    text: new TextSpan(
                      style: new TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        new TextSpan(
                            text: '* Please Note: ',
                            style: !Responsive.isDesktop(context)
                                ? blackDarkSb12()
                                : blackDarkSb10()),
                        new TextSpan(
                            text:
                                'The Wallet Amount will be transferred to \nyour registered Bank Account.',
                            style: Responsive.isDesktop(context)
                                ? blackDarkR9()
                                : blackDarkR12()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            InkWell(
              onTap: () {
                _control!.animateTo(3);
              },
              child: Text(
                "my bank details",
                textAlign: TextAlign.start,
                style: !Responsive.isDesktop(context)
                    ? orangeDarkSemibold12
                    : orangeDarkSb9(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _enterAmount() {
    return Container(
      width: Sizeconfig.screenWidth,
      color: MyAppColor.greynormal,
      padding: EdgeInsets.all(20),
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: !Responsive.isDesktop(context) ? 00 : 10,
            ),
            SizedBox(
              // height: 38,
              child: TextfieldWidget(
                text: "Enter Amount to Transfer (In ₹)",
                control: control,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text("Minimum amount to Transfer is ₹ 100",
                style: textSlightGreySemiBold10),
            SizedBox(
              height: !Responsive.isDesktop(context) ? 20 : 35,
            ),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: MyAppColor.orangelight,
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                ),
                onPressed: () async {
                  if (ref.read(editProfileData).addBank == null) {
                    return showSnack(
                        context: context,
                        msg: "Please add your bank details to proceed",
                        type: 'error');
                  } else if (int.parse(control.text) < 100) {
                    return showSnack(
                        context: context,
                        msg: "Amount should not be less than 100",
                        type: 'error');
                  } else if (int.parse(control.text) > walletBalance) {
                    return showSnack(
                        context: context,
                        msg: "Insufficient Wallet Balance",
                        type: 'error');
                  }
                  await showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => Container(
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
                        backgroundColor: MyAppColor.backgroundColor,
                        elevation: 10,
                        title: Text(
                          "Do You want added money?",
                          style: TextStyle(
                              color: MyAppColor.blackdark, fontSize: 18),
                        ),
                        content: Text("Added",
                            style: TextStyle(color: MyAppColor.blackdark)),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: Text(
                              'No',
                              style: TextStyle(color: MyAppColor.blackdark),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              await settlebank(control.text);
                              Navigator.pop(context);
                            },
                            child: Text('Yes',
                                style: TextStyle(color: MyAppColor.blackdark)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Text("TRANSFER TO MY BANK", style: whiteR12()))
          ],
        ),
      ),
    );
  }

  Container _transferMoney() {
    return Container(
      width: Sizeconfig.screenWidth,
      color: MyAppColor.simplegrey,
      padding: EdgeInsets.symmetric(vertical: 14),
      child: Center(
          child: Text(
        "Transfer Wallet Money to the Bank",
        style: blackMediumGalano12,
      )),
    );
  }

  Widget _walletCard() {
    return Stack(
      children: [
        Container(
          width: Sizeconfig.screenWidth,
          color: MyAppColor.greylight,
          padding: EdgeInsets.only(right: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                "assets/wallet_balance.png",
                height: 84,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\u{20B9}' + " $walletBalance",
                    style: whiteR16(),
                  ),
                  Text("MY WALLET BALANCE", style: lightGreyTextSemiBold12),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Container _menu() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 2, right: 2),
                child: Column(
                  children: [
                    Container(
                      height: 3,
                      color: MyAppColor.orangelight,
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      "Job-seeker Account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: MyAppColor.orangelight),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 2, right: 2),
                child: Column(
                  children: [
                    Container(
                      height: 3,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      "Home-service provider",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 2, right: 2),
                child: Column(
                  children: [
                    Container(
                      height: 3,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      "Home-service seeker",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 2, right: 2),
                child: Column(
                  children: [
                    Container(
                      height: 3,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      "Local Hunar Account",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
