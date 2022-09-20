// ignore_for_file: must_be_immutable

import 'package:clippy_flutter/paralellogram.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/label_string.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';

import '../candidate/header/app_bar.dart';
import '../candidate/model/registree_details_model.dart';
import '../candidate/model/registree_model.dart';
import '../candidate/pages/job_seeker_page/home/drawer/drawer_jobseeker.dart';
import '../services/api_services/business_correspondance_services.dart';
import '../widget/common_app_bar_widget.dart';

class DetailsScreen extends StatefulWidget {
  final flag;
  Registree registree;
  int? registredUserId;

  DetailsScreen(
      {Key? key,
      required this.registree,
      required this.flag,
      this.registredUserId})
      : super(key: key);
  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  RegistreeDetailsModel? registreeDetails;
  @override
  void initState() {
    super.initState();
    print(widget.registree.registeredUser?.id);
    getRegistreeDetails();
  }

  getRegistreeDetails() async {
    registreeDetails = await getMiscellaneousUserRegistreeDetails(
        userId: widget.registredUserId ?? widget.registree.registeredUser!.id);
    setState(() {});
  }

  double sumOfMyCommission = 0;
  double sumOfMyLastMonthCommission = 0;
  double sumOfMyLastYearCommission = 0;
  calculateCommission(List<WalletTransactions> walletTransactions) {
    sumOfMyCommission = 0;
    for (var e in walletTransactions) {
      sumOfMyCommission += double.parse(e.myCommission.toString());
    }
    calculateLastYearCommission(walletTransactions);
    return sumOfMyCommission;
  }

  calculateLastMonthCommission(List<WalletTransactions> walletTransactions) {
    sumOfMyLastMonthCommission = 0;
    for (var e in walletTransactions) {
      if ((DateTime.now().month - 1) ==
          (DateTime.parse(e.subscribedUsers!.first.date.toString()).month)) {
        sumOfMyLastMonthCommission += double.parse(e.myCommission.toString());
      }
    }
    return sumOfMyLastMonthCommission;
  }

  calculateLastYearCommission(List<WalletTransactions> walletTransactions) {
    sumOfMyLastYearCommission = 0;
    for (var e in walletTransactions) {
      if ((DateTime.now().year - 1) ==
          DateTime.parse(e.subscribedUsers!.first.date.toString()).year) {
        sumOfMyLastYearCommission += double.parse(e.myCommission.toString());
      }
    }
    return sumOfMyLastYearCommission;
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {}
    return Scaffold(
      backgroundColor: MyAppColor.backgroundColor,
      key: _drawerKey,
      drawer: Drawer(
        child: DrawerJobSeeker(),
      ),
      appBar: CustomAppBar(
        drawerKey: _drawerKey,
        context: context,
        back: "registree-details",
      ),
      body: Responsive.isDesktop(context)
          ? Column(
              children: [
                SizedBox(
                  height: Sizeconfig.screenHeight! - 120,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [detailsPart(flag: widget.flag), part2()],
                        ),
                      ),
                      Footer()
                    ],
                  ),
                ),
              ],
            )
          : SizedBox(
              child: ListView(
                children: [detailsPart(flag: widget.flag), Footer()],
              ),
            ),
    );
  }

  part2() {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: headerTitle(flag: widget.flag)),
        if (registreeDetails != null)
          Wrap(
            children: [CommissionHistory(registreeDetails: registreeDetails!)],
          ),
      ],
    );
  }

  Widget menu({flag}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        flag == 'bussiness-correspondence'
            ? Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Icon(Icons.arrow_drop_down),
                    Text('Monthly Report', style: blackdarkM12)
                  ],
                ),
              )
            : const SizedBox(),
        // Wrap(
        //   crossAxisAlignment: WrapCrossAlignment.center,
        //   children: [
        //     const Icon(Icons.arrow_drop_down),
        //     Text(LabelString.sortByRelevance, style: blackdarkM12)
        //   ],
        // ),
      ],
    );
  }

  Widget headerTitle({flag}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        flag == 'job-seeker'
            ? Text(
                'SUBSCRIPTION & COMMISSION HISTORY',
                style: Responsive.isDesktop(context)
                    ? blackRegular16
                    : blackRegular14,
              )
            : flag == 'bussiness-correspondence'
                ? Text(
                    'COMMISSION HISTORY',
                    style: Responsive.isDesktop(context)
                        ? blackRegular16
                        : blackRegular14,
                  )
                : Text(
                    'EMPTY',
                    style: Responsive.isDesktop(context)
                        ? blackRegular16
                        : blackRegular14,
                  ),
      ],
    );
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

  detailsPart({flag}) {
    return registreeDetails == null
        ? loaderIndicator(context)
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                SizedBox(
                  height: Responsive.isDesktop(context) ? 10 : 20,
                ),
                Container(
                  color: MyAppColor.greyDark,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(flag != 'bussiness-correspondence'
                            ? 'REGISTREE DETAILS'
                            : 'BUSINESS CORRESPONDENCE'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Responsive.isDesktop(context) ? 10 : 5,
                ),
                Container(
                    color: MyAppColor.greynormal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Container(
                            clipBehavior: Clip.hardEdge,
                            decoration:
                                const BoxDecoration(shape: BoxShape.circle),
                            child: Image.network(
                              '${currentUrl(registreeDetails?.registeredUser?.image)}',
                              height: 100,
                              width: 100,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return Image.asset(
                                  'assets/profileIcon.png',
                                  height: 36,
                                  width: 36,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                        Text(
                          '${registreeDetails?.registeredUser?.name}',
                          style: blackdarkM16,
                        ),
                        Text(
                          '${registreeDetails?.registeredUser?.mobile}',
                          style: blackdarkM16,
                        ),
                        //
                        containerTitleText(
                            title: flag == 'bussiness-correspondence'
                                ? 'Date Registered'
                                : 'Role Registered for',
                            text: flag == 'bussiness-correspondence'
                                ? '${formatDate(registreeDetails?.registeredUser?.dateRegistered)}'
                                : '${registreeDetails?.registeredUser?.roleRegisteredFor}'),
                        containerTitleText(
                            title: flag == 'bussiness-correspondence'
                                ? 'Total Commission Generated for Me (All Time)'
                                : 'Date Registered',
                            text: flag == 'bussiness-correspondence'
                                ? '${calculateCommission(registreeDetails?.registeredBy?.walletTransactions ?? [])}'
                                : '${formatDate(registreeDetails?.registeredUser?.dateRegistered)}'),
                        containerTitleText(
                            title: flag == 'bussiness-correspondence'
                                ? 'Commission Generated for Me Last Month'
                                : 'No. of Subscription Purchased',
                            text: flag == 'bussiness-correspondence'
                                ? '${calculateLastMonthCommission(registreeDetails?.registeredBy?.walletTransactions ?? [])}'
                                : '${registreeDetails?.registeredUser?.noSubscriptionPurchased}'),
                        containerTitleText(
                            title: flag == 'bussiness-correspondence'
                                ? 'Commission Generated for Me Last Year'
                                : 'Last Subscription Purchase Date',
                            text: flag == 'bussiness-correspondence'
                                ? '${calculateLastYearCommission(registreeDetails?.registeredBy?.walletTransactions ?? [])}'
                                : '${formatDate(registreeDetails?.registeredUser?.lastSubscriptionPurchaseDate)}'),
                      ],
                    )),
                const SizedBox(
                  height: 20,
                ),
                if (!Responsive.isDesktop(context))
                  serviceprovidedByProviderMobileview(widget.flag)
              ],
            ),
          );
  }

//
  containerTitleText({title, text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        color: MyAppColor.greyDark,
        width: Responsive.isDesktop(context)
            ? MediaQuery.of(context).size.width / 3
            : MediaQuery.of(context).size.width / 1,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: appleColorR10,
              ),
              Text(
                text,
                style: blackMedium14,
              )
            ],
          ),
        ),
      ),
    );
  }

  subscribeToCall() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
      child: Container(
        color: MyAppColor.greylight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/orange_lock_small.png'),
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Text(
                  'Subscribe to Call\nService Provider',
                  style: orangDarMedium14,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  serviceprovidedByProviderMobileview(flag) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            headerTitle(flag: flag),
          ],
        ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        //   child: Row(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     // ignore: prefer_const_literals_to_create_immutables
        //     children: [
        //       const Icon(Icons.arrow_drop_down),
        //       Text(LabelString.sortByRelevance, style: black12)
        //     ],
        //   ),
        // ),
        const SizedBox(
          height: 10,
        ),
        Column(
            children: List.generate(
          registreeDetails?.registeredBy?.walletTransactions?.length ?? 0,
          (index) =>
              // flag == 'bussiness-correspondence'
              //     ? listItem(
              //         srNO: '#01',
              //         date: '20.12.2022',
              //         commissionOnSubscriptionCharge: '₹ 149.70',
              //         commissionGeneratedForSelf: '₹ 149.70')
              //     :
              listItem(
                  srNO: '#${index + 1}',
                  date:
                      '${formatDate(registreeDetails!.registeredBy!.walletTransactions![index].subscribedUsers!.first.date)}',
                  commissionOnSubscriptionCharge:
                      '₹ ${registreeDetails!.registeredBy!.walletTransactions![index].myCommission}',
                  planName:
                      '${registreeDetails?.registeredBy?.walletTransactions?[index].subscribedUsers?.first.subscriptionPlan?.subscriptionPurchased}',
                  subscriptionCharge:
                      '₹ ${registreeDetails?.registeredBy?.walletTransactions?[index].subscribedUsers?.first.subscriptionPlan?.subscriptionCharge}'),
        ))
      ],
    );
  }

//need to change
  listItem(
      {srNO,
      date,
      commissionOnSubscriptionCharge,
      planName,
      subscriptionCharge,
      commissionGeneratedForSelf}) {
    return widget.flag != 'bussiness-correspondence'
        ? SizedBox(
            ////   color: MyAppColor.greyDark,
            width: Responsive.isDesktop(context)
                ? Sizeconfig.screenWidth! / 5
                : Sizeconfig.screenWidth,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                            Text(srNO, style: grey12),
                            Wrap(
                              children: [
                                Text(date, style: blackDarkSb10()),
                                const Icon(Icons.calendar_today_rounded,
                                    size: 11)
                              ],
                            ),
                          ]),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(commissionOnSubscriptionCharge,
                          style: blackDarkSemiBold16),
                      Text('My Commission (on Subscription Charge)',
                          style: blackMedium12),
                      const SizedBox(
                        height: 10,
                      ),
                      containerForCharge(
                          title: 'Subscription Purchased', value: planName),
                      const SizedBox(
                        height: 5,
                      ),
                      containerForCharge(
                          title: 'Subscription Charge',
                          value: subscriptionCharge),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ))
        : SizedBox(
            ////   color: MyAppColor.greyDark,
            width: Responsive.isDesktop(context)
                ? Sizeconfig.screenWidth! / 5
                : Sizeconfig.screenWidth,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                            Text(srNO, style: grey12),
                            Wrap(
                              children: [
                                Text(date, style: blackDarkSb10()),
                                const Icon(Icons.calendar_today_rounded,
                                    size: 11)
                              ],
                            ),
                          ]),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(commissionOnSubscriptionCharge,
                          style: blackDarkSemiBold16),
                      Text('Commission Generated for Me (5%)',
                          style: blackMedium12),
                      const SizedBox(
                        height: 10,
                      ),
                      containerForCharge(
                          title: 'Commission Generated from Subscription ',
                          value: subscriptionCharge),
                    ],
                  ),
                ),
              ),
            ));
  }

  Widget containerForCharge({title, value}) {
    return Container(
      color: MyAppColor.grey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(value, style: blackDarkSemibold14),
                  Text(title, style: blackDarkR10())
                ],
              ),
            ),
          ),
        ],
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

  ratingBar() {
    return RatingBar.builder(
      initialRating: 3,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      unratedColor: MyAppColor.white,
      itemCount: 5,
      itemSize: 18.0,
      //itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
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
}

//
class CommissionHistory extends StatelessWidget {
  RegistreeDetailsModel registreeDetails;
  CommissionHistory({
    Key? key,
    required this.registreeDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive.isDesktop(context)
        ? Container(
            height: Responsive.isDesktop(context) ? Sizeconfig.screenHeight : 0,

            /// color: MyAppColor.lightGrey,
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: Responsive.isDesktop(context) ? 20 : 0,
                ),
                // Expanded(
                //   child:
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    itemWIndow(context,
                        text: 'S.NO',
                        flex: 1,
                        alignment: Alignment.center,
                        style: black10),
                    itemWIndow(
                      context,
                      text: 'SUBSCRIPTION PURCHASED',
                      flex: 3,
                      style: black10,
                    ),
                    itemWIndow(
                      context,
                      flex: 2,
                      text: 'SUBSCRIPTION CHARGE',
                      style: black10,
                    ),
                    itemWIndow(
                      context,
                      text: 'DATE',
                      flex: 2,
                      style: black10,
                    ),
                    itemWIndow(context,
                        text: 'MY COMMISSION (SUBSCRIPTION CHARGE)',
                        flex: 4,
                        style: black10),
                  ],
                ),
                // ),
                SizedBox(
                  height: Responsive.isDesktop(context) ? 0 : 0,
                ),

                // Expanded(child:
                listViewWindow(registreeDetails, context),
                //  ),

                SizedBox(
                  height: Responsive.isDesktop(context) ? 20 : 0,
                ),
                //   viewAllButtonWindow()
              ],
            ))
        : Container();
  }

  //
  Widget listViewWindow(RegistreeDetailsModel registreeDetails, context) {
    print(registreeDetails);
    print(registreeDetails.registeredBy!.walletTransactions!);
    print(registreeDetails.registeredBy!.walletTransactions!.length);
    return Column(
        children: List.generate(
            registreeDetails.registeredBy!.walletTransactions!.length,
            (index) => Row(
                  children: [
                    itemWIndow(
                      context,
                      flex: 1,
                      text: "${index + 1}",
                      alignment: Alignment.center,
                    ),
                    itemWIndow(context,
                        flex: 3,
                        text:
                            "${registreeDetails.registeredBy?.walletTransactions?[index].subscribedUsers?.first.subscriptionPlan?.subscriptionPurchased}",
                        alignment: Alignment.centerLeft),
                    itemWIndow(context,
                        flex: 2,
                        text:
                            "${registreeDetails.registeredBy?.walletTransactions?[index].subscribedUsers?.first.subscriptionPlan?.subscriptionCharge}",
                        alignment: Alignment.centerLeft),
                    itemWIndow(context,
                        flex: 2,
                        text:
                            "${formatDate(registreeDetails.registeredBy?.walletTransactions?[index].subscribedUsers?.first.date)}",
                        alignment: Alignment.centerLeft),
                    itemWIndow(context,
                        flex: 4,
                        text:
                            "${registreeDetails.registeredBy?.walletTransactions?[index].myCommission}",
                        alignment: Alignment.centerLeft),
                  ],
                )));
  }

  arrowButton(context) {
    return Expanded(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: GestureDetector(
            onTap: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //        builder: (context) => const DetailsScreen()));
            },
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
          ),
        ));
  }

  //

  itemWIndow(context, {flex, text, alignment, style}) {
    return Container(
      width: MediaQuery.of(context).size.width / flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 2),
        child: Container(
          alignment: alignment,
          color: MyAppColor.grayplane,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              text != 'null' ? text : '',
              style: style ?? black12,
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
