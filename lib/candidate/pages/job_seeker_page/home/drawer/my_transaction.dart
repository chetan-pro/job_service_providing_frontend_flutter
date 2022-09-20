import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hindustan_job/candidate/model/transactions_historires_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/drawer/drawer_jobseeker.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/company/home/homepage.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/mystring_text.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';

import '../../../../../widget/common_app_bar_widget.dart';
import '../../../../../widget/drop_down_widget/text_drop_down_widget.dart';
import '../../../../header/app_bar.dart';

class MyTransaction extends ConsumerStatefulWidget {
  const MyTransaction({Key? key}) : super(key: key);
  static const String route = '/my-transaction';

  @override
  ConsumerState<MyTransaction> createState() => _MyTransactionState();
}

class _MyTransactionState extends ConsumerState<MyTransaction> {
  String sortBy = "All";

  @override
  void initState() {
    super.initState();
    ref.read(companyProfile).getTransactionHistories(context);
  }

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme;
    Sizeconfig().init(context);
    return Consumer(builder: (context, ref, child) {
      List<TransactionHistories> transactionHisotries =
          ref.watch(companyProfile).transactionHisotries;
      return Scaffold(
        key: _drawerKey,
        drawer: const Drawer(
          child: DrawerJobSeeker(),
        ),
        appBar: CustomAppBar(
          drawerKey: _drawerKey,
          context: context,
          back: "MY TRANSACTIONS",
        ),
        //  PreferredSize(
        //     preferredSize:
        //         Size.fromHeight(Responsive.isDesktop(context) ? 150 : 150),
        //     child: CommomAppBar(
        //       drawerKey: _drawerKey,
        //       back: "MY TRANSACTIONS",
        //     ),
        //   ),
        body: Responsive.isDesktop(context)
            ? _table(transactionHisotries)
            : ListView(
                children: [
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 35),
                        child: Text(
                          'MY TRANSACTION',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AppDropdownInput(
                              hintText: 'All',
                              options: [
                                'Success',
                                'Failed',
                              ],
                              value: sortBy,
                              changed: (String value) async {
                                sortBy = value;
                                var carryData;
                                if (value != 'All') {
                                  carryData = {
                                    'payment_status': value.toLowerCase()
                                  };
                                }
                                ref
                                    .read(companyProfile)
                                    .getTransactionHistories(context,
                                        filterData: carryData);
                                setState(() {});
                              },
                              getLabel: (String value) => value,
                            ),
                          ],
                        ),
                      ),
                      for (var i = 0; i < transactionHisotries.length; i++)
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            height: Sizeconfig.screenHeight! / 3,
                            width: Sizeconfig.screenWidth,
                            color: MyAppColor.greynormal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/01.png',
                                          height: Sizeconfig.screenHeight! / 55,
                                        ),
                                        const SizedBox(
                                          width: 7,
                                        ),
                                        Text('#0${i + 1}')
                                      ],
                                    ),
                                    SizedBox(
                                      height: Sizeconfig.screenHeight! / 40,
                                    ),
                                    Text(
                                      'Credit',
                                      style: styles.headline3!.copyWith(
                                          color: MyAppColor.applecolor,
                                          fontSize: 12),
                                    ),
                                    Text(
                                      '₹ ${transactionHisotries[i].totalAmount}',
                                      style: styles.headline3!.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    Text(
                                      'AMOUNT',
                                      style: styles.headline3!.copyWith(
                                        fontSize: 10,
                                      ),
                                    ),
                                    SizedBox(
                                      height: Sizeconfig.screenHeight! / 40,
                                    ),
                                    Text(
                                      'Credit Card',
                                      style: styles.headline3!
                                          .copyWith(fontSize: 14),
                                    ),
                                    Text('MODE OF TRANSACTION',
                                        style: styles.headline3),
                                    SizedBox(
                                      height: Sizeconfig.screenHeight! / 40,
                                    ),
                                    Text(
                                      transactionHisotries[i].tnxId ?? '',
                                      style: styles.headline3!
                                          .copyWith(fontSize: 13),
                                    ),
                                    Text('TRANSACTION ID',
                                        style: styles.headline3!
                                            .copyWith(fontSize: 10)),
                                    // SizedBox(
                                    //   height: 30,
                                    // ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          formatDate(transactionHisotries[i]
                                              .createdAt),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Image.asset(
                                          'assets/dates.png',
                                          height: Sizeconfig.screenHeight! / 55,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: Sizeconfig.screenHeight! / 30,
                                    ),
                                    Text(
                                      'Subscription Purchased',
                                      style: styles.headline3!
                                          .copyWith(fontSize: 14),
                                    ),
                                    Text(
                                      'REASON',
                                      style: styles.headline3!
                                          .copyWith(fontSize: 10),
                                    ),
                                    SizedBox(
                                      height: Sizeconfig.screenHeight! / 10,
                                    ),
                                    Text(
                                      getCapitalizeString(
                                          transactionHisotries[i].status ??
                                              'Failed'),
                                      style: styles.headline3!.copyWith(
                                          fontSize: 15,
                                          color:
                                              transactionHisotries[i].status !=
                                                          null &&
                                                      transactionHisotries[i]
                                                              .status ==
                                                          'done'
                                                  ? Colors.green
                                                  : Colors.red),
                                    ),
                                    Text(
                                      'STATUS',
                                      style: styles.headline3!.copyWith(
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(
                    height: Sizeconfig.screenHeight! / 15,
                  ),
                  Footer(),
                  Container(
                    alignment: Alignment.center,
                    color: MyAppColor.normalblack,
                    height: 30,
                    width: double.infinity,
                    child: Text(Mystring.hackerkernel,
                        style: Mytheme.lightTheme(context)
                            .textTheme
                            .headline1!
                            .copyWith(color: MyAppColor.white)),
                  ),
                ],
              ),
      );
    });
  }

  _table(transactionHisotries) {
    return Container(
      //color: Colors.white,
      padding: const EdgeInsets.all(20.0),
      child: Table(
        border: TableBorder.all(color: Colors.white, width: 1.0),
        children: [
          TableRow(
              decoration: new BoxDecoration(color: MyAppColor.greynormal),
              children: [
                const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    'S.No',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    'Date',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    'Order Id',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    'Mode of Transcation',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    'Transcation Id',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    'Amount',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    'Credit/Debit',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    'Status',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ]),
          for (var i = 0; i < transactionHisotries.length; i++)
            TableRow(
                decoration: new BoxDecoration(color: MyAppColor.greynormal),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text('${i + 1}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                        '${formatDate(transactionHisotries[i].createdAt)}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text('${transactionHisotries[i].orderId ?? ''}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text('${transactionHisotries[i].paymentType ?? ''}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text('${transactionHisotries[i].tnxId ?? ''}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text('₹ ${transactionHisotries[i].totalAmount}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text('${transactionHisotries[i].totalAmount}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      getCapitalizeString(
                          transactionHisotries[i].status ?? 'Failed'),
                      style: TextStyle(
                          color: transactionHisotries[i].status != null &&
                                  transactionHisotries[i].status == 'done'
                              ? Colors.green
                              : Colors.red),
                    ),
                  ),
                ]),
        ],
      ),
    );
  }
}
