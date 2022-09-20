// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, unused_element, avoid_web_libraries_in_flutter, unused_import, prefer_final_fields, unused_field, avoid_print, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hindustan_job/candidate/header/app_bar.dart';
import 'package:hindustan_job/candidate/model/subscription_list.dart';
import 'package:hindustan_job/candidate/model/subscription_order.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/candidate/pages/dialog/subscribedialog.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/drawer/drawer_jobseeker.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart'
    as candidate;
import 'package:hindustan_job/candidate/routes/routes.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/company/home/homepage.dart';
import 'package:hindustan_job/company/home/widget/company_custom_app_bar.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/enum_contants.dart';
import 'package:hindustan_job/constants/mystring_text.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/razorPayHtml.dart';
import 'package:hindustan_job/serviceprovider/screens/HomeServiceProviderTabs/my_profile.dart';
import 'package:hindustan_job/services/api_services/subscription_services.dart';
import 'package:hindustan_job/services/api_services/user_services.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/services_constant/constant.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/buttons/outline_buttons.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:hindustan_job/widget/landing_page_widget/search_field.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../../../widget/body/tab_bar_body_widget.dart';
import '../../../../../widget/common_app_bar_widget.dart';
import '../../../../header/back_text_widget.dart';
import '../homeappbar.dart';

class SubscriptionPlans extends ConsumerStatefulWidget {
  bool isLimitPlans;
  bool isResumePlans;
  bool isValidityPlan;
  bool isCompanyBranding;
  bool isFromConnectedRoutes;
  SubscriptionPlans(
      {Key? key,
      this.isLimitPlans = false,
      this.isResumePlans = false,
      this.isValidityPlan = false,
      this.isCompanyBranding = false,
      this.isFromConnectedRoutes = false})
      : super(key: key);

  static const String route = '/subscriptions-plan';

  @override
  _SubscriptionPlansState createState() => _SubscriptionPlansState();
}

class _SubscriptionPlansState extends ConsumerState<SubscriptionPlans>
    with SingleTickerProviderStateMixin {
  List<Subscription> subscriptionPlans = [];
  List<Subscription> jobBrandingSubscriptionPlans = [];
  List<Subscription> limitExtensionSubscriptionPlans = [];
  List<Subscription> resumeDataSubscriptionPlans = [];
  List<Subscription> validitySubscriptionPlans = [];
  SubscriptionOrder? orderData;
  Razorpay _razorpay = Razorpay();

  bool _isloadData = false;
  dynamic walletBalance = 0;
  getBalance() async {
    ApiResponse response = await getWalletAmount();
    if (response.status == 200) {
      setState(() {
        walletBalance = response.body!.walletMoney!;
        print('walletBalance');
        walletBalance = double.parse(walletBalance);
      });
    }
  }

  PaymentType paymentType = PaymentType.none;
  paymentTypeValueChange(change, {amount, id}) async {
    String payType = '';
    setState(() {
      paymentType = change;
      payType = paymentType == PaymentType.razorpay
          ? "E"
          : paymentType == PaymentType.walletRazorPay
              ? 'EW'
              : 'W';

      // if (!checkRoleType(userData!.userRoleType)) Navigator.pop(context);
    });
    switch (payType) {
      case 'E':
        await createOrder(
            amount: amount,
            planId: id,
            type: payType,
            walletAmount: 0,
            eAmount: amount);
        break;
      case 'EW':
        await createOrder(
            amount: int.parse(amount.toString()),
            planId: id,
            type: payType,
            walletAmount: walletBalance,
            eAmount: int.parse(amount.toString()) - walletBalance);
        break;
      case 'W':
        await verifyPayment(
            type: payType,
            planId: id,
            message: SuccessAlertString.paymentSuccess,
            paymentStatus: PaymentStatus.success,
            totalAmount: amount,
            walletAmount: amount,
            eAmount: 0);
        break;
      default:
    }
  }

  TabController? _control;

  @override
  void initState() {
    super.initState();
    if (userData!.userRoleType == RoleTypeConstant.company) {
      _control = TabController(
          initialIndex: 0,
          length: widget.isLimitPlans ||
                  widget.isResumePlans ||
                  widget.isCompanyBranding ||
                  widget.isValidityPlan
              ? 1
              : 4,
          vsync: this);
    } else {
      _control = TabController(initialIndex: 0, length: 1, vsync: this);
    }
    fetchSubscriptionPlans();
    getBalance();
    if (!kIsWeb) {
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    }
  }

  fetchSubscriptionPlans() async {
    subscriptionPlans = await fetchSubscriptionList(context);
    if (subscriptionPlans != null && subscriptionPlans.isNotEmpty) {
      jobBrandingSubscriptionPlans = subscriptionPlans
          .where(
              (element) => element.planType == SubscriptionType.jobBrandingPlan)
          .toList();
      limitExtensionSubscriptionPlans = subscriptionPlans
          .where((element) =>
              element.planType == SubscriptionType.limitExtensionPlan)
          .toList();
      resumeDataSubscriptionPlans = subscriptionPlans
          .where((element) =>
              element.planType == SubscriptionType.resumeDataAccessPlan)
          .toList();
      validitySubscriptionPlans = subscriptionPlans
          .where((element) => element.planType == SubscriptionType.validityPlan)
          .toList();
    }
    setState(() {});
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await verifyPayment(
        orderId: orderData!.orderId,
        planId: orderData!.planId,
        message: SuccessAlertString.paymentSuccess,
        signature: response.signature,
        totalAmount: orderData!.totalAmount,
        walletAmount: orderData!.walletAmount,
        type: orderData!.paymentType,
        eAmount: orderData!.eAmount,
        paymentId: response.paymentId,
        paymentStatus: PaymentStatus.success);
    // Do something when payment succeeds
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    await verifyPayment(
        orderId: orderData!.orderId,
        planId: orderData!.planId,
        message: response.message,
        paymentStatus: PaymentStatus.failed);
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  verifyPayment(
      {orderId,
      planId,
      paymentId,
      signature,
      paymentStatus,
      message,
      type,
      eAmount,
      totalAmount,
      walletAmount}) async {
    var verificationData = {
      "plan_id": planId.toString(),
      "payment_status": paymentStatus,
      "message": message.toString(),
      "total_amount": totalAmount,
      "type": type,
      "e_amount": eAmount,
      "wallet_amount": walletAmount,
    };
    if (type == 'E' || type == 'EW') {
      verificationData["payment_id"] = paymentId;
      verificationData["signature"] = signature;
      verificationData["order_id"] = orderId;
    }
    List<Subscription> descriptionDetails = subscriptionPlans.where((element) {
      return element.id == int.parse(planId.toString());
    }).toList();
    await verifySubscription(context, verificationData,
        planDescription: descriptionDetails.first.description);
    if (userData!.userRoleType == RoleTypeConstant.jobSeeker) {
      ref.read(candidate.editProfileData).checkSubscription();
    } else if (userData!.userRoleType == RoleTypeConstant.homeServiceProvider) {
      ref.read(serviceProviderData).checkSubscription();
    } else {
      ref.read(companyProfile).checkSubscription();
    }
  }

  createOrder(
      {amount,
      planId,
      receipt,
      type,
      totalAmount,
      walletAmount,
      eAmount}) async {
    var planData = {
      "receipt": "rec1",
      "plan_id": planId.toString(),
      "total_amount": amount.toString(),
      "type": type,
      "wallet_amount": walletAmount,
      "e_amount": eAmount
    };
    orderData = await createSubscriptionOrder(context, planData);
    if (orderData!.orderId != null) {
      razorPaySubscription(orderData!);
    }
  }

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyAppColor.backgroundColor,
        key: _drawerKey,
        appBar: !kIsWeb && widget.isFromConnectedRoutes
            ? PreferredSize(
                child: BackWithText(text: "SUBSCRIPTIONS PLANS"),
                preferredSize: Size.fromHeight(50))
            : PreferredSize(
                preferredSize:
                    Size.fromHeight(Responsive.isDesktop(context) ? 150 : 150),
                child: CommomAppBar(
                  drawerKey: _drawerKey,
                  back: "SUBSCRIPTIONS PLANS",
                )),
        drawer: Drawer(
          child: DrawerJobSeeker(),
        ),
        body: TabBarSliverAppbar(
          headColumn: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  'PREMIUM SUBSCRIPTION PLANS\n FOR ${userData?.userRoleType == RoleTypeConstant.jobSeeker ? "JOB-SEEKER" : userData!.userRoleType == RoleTypeConstant.homeServiceProvider ? 'HSP' : "COMPANY"}  ',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              //   child: Text(
              //       "Company The quick, brown fox jumps over a lazy dog. DJs flock by when MTV ax quiz prog.Junk MTV quiz graced \nby fox whelps. Bawds jog, flick quartz, vex nymphs. Waltz, bad,for quick jigs vex!\nFox nymphs grab quick-jived waltz. Brick quiz whangs jumpy veldt fox.",
              //       textAlign: TextAlign.center,
              //       style: TextStyle(color: Colors.black)),
              // ),
              SizedBox(height: 8),
            ],
          ),
          toolBarHeight: 80,
          length: 2,
          tabs: _tab(),
          tabsWidgets: widget.isCompanyBranding
              ? [
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: jobBrandingSubscriptionPlans.isEmpty
                        ? loaderIndicator(context)
                        : SingleChildScrollView(
                            child: Wrap(
                                children: List.generate(
                                    jobBrandingSubscriptionPlans.length,
                                    (index) => _saverPlan(
                                        jobBrandingSubscriptionPlans[index]))),
                          ),
                  ),
                ]
              : widget.isValidityPlan
                  ? [
                      SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: validitySubscriptionPlans.isEmpty
                              ? loaderIndicator(context)
                              : SingleChildScrollView(
                                  child: Wrap(
                                      children: List.generate(
                                          validitySubscriptionPlans.length,
                                          (index) => _saverPlan(
                                              validitySubscriptionPlans[
                                                  index]))),
                                ))
                    ]
                  : widget.isResumePlans
                      ? [
                          SizedBox(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: resumeDataSubscriptionPlans.isEmpty
                                  ? loaderIndicator(context)
                                  : SingleChildScrollView(
                                      child: Wrap(
                                          children: List.generate(
                                              resumeDataSubscriptionPlans
                                                  .length,
                                              (index) => _saverPlan(
                                                  resumeDataSubscriptionPlans[
                                                      index]))),
                                    )),
                        ]
                      : widget.isLimitPlans
                          ? [
                              SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child: limitExtensionSubscriptionPlans.isEmpty
                                      ? loaderIndicator(context)
                                      : SingleChildScrollView(
                                          child: Wrap(
                                              children: List.generate(
                                                  limitExtensionSubscriptionPlans
                                                      .length,
                                                  (index) => _saverPlan(
                                                      limitExtensionSubscriptionPlans[
                                                          index]))),
                                        )),
                            ]
                          : userData!.userRoleType == RoleTypeConstant.company
                              ? [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    child: jobBrandingSubscriptionPlans.isEmpty
                                        ? loaderIndicator(context)
                                        : SingleChildScrollView(
                                            child: Wrap(
                                                children: List.generate(
                                                    jobBrandingSubscriptionPlans
                                                        .length,
                                                    (index) => _saverPlan(
                                                        jobBrandingSubscriptionPlans[
                                                            index]))),
                                          ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                      child: limitExtensionSubscriptionPlans
                                              .isEmpty
                                          ? loaderIndicator(context)
                                          : SingleChildScrollView(
                                              child: Wrap(
                                                  children: List.generate(
                                                      limitExtensionSubscriptionPlans
                                                          .length,
                                                      (index) => _saverPlan(
                                                          limitExtensionSubscriptionPlans[
                                                              index]))),
                                            )),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                      child: resumeDataSubscriptionPlans.isEmpty
                                          ? loaderIndicator(context)
                                          : SingleChildScrollView(
                                              child: Wrap(
                                                  children: List.generate(
                                                      resumeDataSubscriptionPlans
                                                          .length,
                                                      (index) => _saverPlan(
                                                          resumeDataSubscriptionPlans[
                                                              index]))),
                                            )),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                      child: validitySubscriptionPlans.isEmpty
                                          ? loaderIndicator(context)
                                          : SingleChildScrollView(
                                              child: Wrap(
                                                  children: List.generate(
                                                      validitySubscriptionPlans
                                                          .length,
                                                      (index) => _saverPlan(
                                                          validitySubscriptionPlans[
                                                              index]))))),
                                ]
                              : [
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                      child: validitySubscriptionPlans.isEmpty
                                          ? loaderIndicator(context)
                                          : SingleChildScrollView(
                                              child: Wrap(
                                                  children: List.generate(
                                                      validitySubscriptionPlans
                                                          .length,
                                                      (index) => _saverPlan(
                                                          validitySubscriptionPlans[
                                                              index]))),
                                            ))
                                ],
          control: _control!,
        ));
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
        tabs: widget.isCompanyBranding
            ? [
                Text(
                  "Company Branding",
                  style: blackDarkSemibold14,
                  textAlign: TextAlign.center,
                ),
              ]
            : widget.isValidityPlan
                ? [
                    Text(
                      "Validity Plan",
                      style: blackDarkSemibold14,
                      textAlign: TextAlign.center,
                    ),
                  ]
                : widget.isResumePlans
                    ? [
                        Text(
                          SubscriptionType.resumeDataAccessPlan
                              .replaceAll('_', " "),
                          style: blackDarkSemibold14,
                          textAlign: TextAlign.center,
                        ),
                      ]
                    : widget.isLimitPlans
                        ? [
                            Text(
                              SubscriptionType.limitExtensionPlan
                                  .replaceAll('_', " "),
                              style: blackDarkSemibold14,
                              textAlign: TextAlign.center,
                            ),
                          ]
                        : userData!.userRoleType == RoleTypeConstant.company
                            ? [
                                Text(
                                  "Company Branding",
                                  style: blackDarkSemibold14,
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  SubscriptionType.limitExtensionPlan
                                      .replaceAll('_', " "),
                                  style: blackDarkSemibold14,
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  SubscriptionType.resumeDataAccessPlan
                                      .replaceAll('_', " "),
                                  style: blackDarkSemibold14,
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  "Validity Plan",
                                  style: blackDarkSemibold14,
                                  textAlign: TextAlign.center,
                                ),
                              ]
                            : [
                                Text(
                                  "Validity Plan",
                                  style: blackDarkSemibold14,
                                  textAlign: TextAlign.center,
                                ),
                              ]);
  }

  Widget _saverPlan(Subscription element) {
    return SizedBox(
      width: Responsive.isDesktop(context)
          ? Sizeconfig.screenWidth! / 3
          : Sizeconfig.screenWidth,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Container(
              height: Sizeconfig.screenHeight! / 1.4,
              width: Responsive.isDesktop(context)
                  ? Sizeconfig.screenWidth! / 3
                  : Sizeconfig.screenWidth,
              decoration: BoxDecoration(color: MyAppColor.blue),
            ),
            Positioned(
              top: 00,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/saver_plan.png',
                    height: Sizeconfig.screenHeight! / 8,
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
                    'assets/up_styles.png',
                    height: Sizeconfig.screenHeight! / 33,
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 00,
              right: 00,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/orange_design.png',
                    height: Sizeconfig.screenHeight! / 33,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 00,
              left: 00,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/down_left.png',
                    height: Sizeconfig.screenHeight! / 17,
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: Sizeconfig.screenHeight! / 10,
                  ),
                  Text(
                    '${element.title}',
                    style: TextStyle(
                      color: MyAppColor.backgroundColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 27),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: MyAppColor.white,
                      ),
                      height: Sizeconfig.screenHeight! / 17,
                      width: Sizeconfig.screenWidth! / 9,
                      padding: EdgeInsets.all(9),
                      child: Image.asset(
                        'assets/dark_blue_circle.png',
                        height: 10,
                      ),
                    ),
                  ),
                  Text(
                    '₹ ${element.discountedAmount}',
                    style: TextStyle(
                      fontSize: 30,
                      color: MyAppColor.backgroundColor,
                    ),
                  ),
                  SizedBox(
                    height: Sizeconfig.screenHeight! / 70,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      '${element.description}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: MyAppColor.backgroundColor,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Plan will expire in ${element.expiryDays} days',
                      style: TextStyle(
                        color: MyAppColor.backgroundColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 33),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: MyAppColor.white),
                      ),
                      onPressed: () async {
                        checkRoleType(userData!.userRoleType)
                            ? paymentTypeValueChange(PaymentType.razorpay,
                                amount: element.discountedAmount,
                                id: element.id)
                            : await showDialog(
                                context: context,
                                builder: (context) => selectPaymentType(
                                    amount: element.discountedAmount,
                                    id: element.id));
                      },
                      child: Text(
                        'SUBSCRIBE NOW',
                        style: TextStyle(color: MyAppColor.backgroundColor),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  selectPaymentType({amount, id}) {
    return AlertDialog(
      content: SizedBox(
        height: 240,
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Subscription"),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Select Payment",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 15,
              ),
              paymentRadioButton(
                  value: PaymentType.razorpay,
                  groupValue: paymentType,
                  onChanged: (value) =>
                      paymentTypeValueChange(value, amount: amount, id: id),
                  text: 'Pay with Razor-pay'),
              int.parse(amount.toString()) <= walletBalance
                  ? paymentRadioButton(
                      value: PaymentType.wallet,
                      groupValue: paymentType,
                      onChanged: (value) =>
                          paymentTypeValueChange(value, amount: amount, id: id),
                      text: 'Pay with wallet')
                  : paymentRadioButton(
                      value: PaymentType.walletRazorPay,
                      groupValue: paymentType,
                      onChanged: (value) =>
                          paymentTypeValueChange(value, amount: amount, id: id),
                      text: 'Pay with Wallet or \nRazor-pay'),
            ],
          ),
        ),
      ),
    );
  }

  paymentRadioButton({text, value, groupValue, onChanged}) {
    return InkWell(
      onTap: () {
        onChanged(value);
      },
      child: Row(
        children: [
          Radio<dynamic>(
            activeColor: MyAppColor.orangelight,
            value: value,
            groupValue: groupValue,
            onChanged: (value) => onChanged(value),
          ),
          Text("$text", style: blackDark13),
        ],
      ),
    );
  }

  Widget _recommend() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            height: Sizeconfig.screenHeight! / 1.7,
            width: Sizeconfig.screenWidth,
            decoration: BoxDecoration(color: MyAppColor.orangelight),
          ),
          Positioned(
            top: 00,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/white_recommend.png',
                  height: Sizeconfig.screenHeight! / 8,
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
                  'assets/down_style.png',
                  height: Sizeconfig.screenHeight! / 33,
                )
              ],
            ),
          ),
          Positioned(
            bottom: 00,
            right: 00,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/up_flower.png',
                  height: Sizeconfig.screenHeight! / 33,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 00,
            left: 00,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/circle_design.png',
                  height: Sizeconfig.screenHeight! / 17,
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: Sizeconfig.screenHeight! / 10,
                ),
                Text(
                  'JOB-SEEKER GOLD PLAN',
                  style: TextStyle(
                    color: MyAppColor.backgroundColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 27),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: MyAppColor.white,
                    ),
                    height: Sizeconfig.screenHeight! / 17,
                    width: Sizeconfig.screenWidth! / 9,
                    padding: EdgeInsets.all(9),
                    child: Image.asset(
                      'assets/orange_circle.png',
                      height: 10,
                    ),
                  ),
                ),
                Text(
                  '₹ 99.00',
                  style: TextStyle(
                    fontSize: 30,
                    color: MyAppColor.backgroundColor,
                  ),
                ),
                SizedBox(
                  height: Sizeconfig.screenHeight! / 70,
                ),
                Text(
                  'Apply for Un-limited Job ',
                  style: TextStyle(
                      color: MyAppColor.backgroundColor,
                      fontStyle: FontStyle.italic),
                ),
                Text(
                  '& Build Professional Resume',
                  style: TextStyle(
                      color: MyAppColor.backgroundColor,
                      fontStyle: FontStyle.italic),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'for 1 month',
                    style: TextStyle(
                      color: MyAppColor.backgroundColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 33),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: MyAppColor.white),
                    ),
                    onPressed: () async {},
                    child: Text(
                      'SUBSCRIBE NOW',
                      style: TextStyle(color: MyAppColor.backgroundColor),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  razorPaySubscription(SubscriptionOrder order) async {
    String razorPayKey = "rzp_test_805HsMwhHeEpIE";
    var options = {
      'key': razorPayKey,
      'order_id': '${order.orderId}',
      'amount': order.eAmount! * 100,
      'name': 'Hindustan Job',
      'description': 'Get subscription plan for update',
      'prefill': {
        'contact': '${userData!.mobile}',
        'email': '${userData!.email}'
      }
    };
    // if (kIsWeb) {
    // var data = await widgetPopDialog(
    //     Webpayment(
    //       name: 'Hindustan Jobs',
    //       price: int.parse(order.eAmount! * 100),
    //       contact: userData!.mobile,
    //       email: userData!.email,
    //       razorPayKey: razorPayKey,
    //       orderId: order.orderId,
    //     ),
    //     context,
    //     width: 200.0);

    // if (data != false && data['razorpay_payment_id'] != null) {
    //   print("check its working ");
    //   await verifyPayment(
    //       orderId: orderData!.orderId,
    //       planId: orderData!.planId,
    //       message: SuccessAlertString.paymentSuccess,
    //       signature: data['razorpay_signature'],
    //       totalAmount: orderData!.totalAmount,
    //       walletAmount: orderData!.walletAmount,
    //       type: orderData!.paymentType,
    //       eAmount: orderData!.eAmount,
    //       paymentId: data['razorpay_payment_id'],
    //       paymentStatus: PaymentStatus.success);
    // } else {
    //   print("check its working or not");

    //     await verifyPayment(
    //         orderId: orderData!.orderId,
    //         planId: orderData!.planId,
    //         message: "Subscription is failed",
    //         paymentStatus: PaymentStatus.failed);
    //   }
    // } else {
    _razorpay.open(options);
    // }
  }
}
