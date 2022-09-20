import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/mystring_text.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';

class CompanyTranction extends StatefulWidget {
  const CompanyTranction({Key? key}) : super(key: key);

  @override
  State<CompanyTranction> createState() => _CompanyTranctionState();
}

class _CompanyTranctionState extends State<CompanyTranction> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme;
    Sizeconfig().init(context);
    return Scaffold(
      appBar: _appbar(),
      body: ListView(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 35),
                child: Text(
                  'MY TRANSACTION',
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.expand_more),
                        Text(
                          'March',
                          style: styles.headline1!.copyWith(
                              fontSize: 17, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: Sizeconfig.screenWidth! / 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.expand_more),
                        Text(
                          '2021',
                          style: styles.headline1!.copyWith(
                              fontSize: 17, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: Sizeconfig.screenWidth! / 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.expand_more),
                        Text(
                          'Sort by Relevance',
                          style: styles.headline1!.copyWith(
                              fontSize: 17, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            
              for (var i = 0; i < 4; i++)
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    padding: EdgeInsets.all(20),
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
                                SizedBox(
                                  width: 7,
                                ),
                                Text('#01')
                              ],
                            ),
                            SizedBox(
                              height: Sizeconfig.screenHeight! / 40,
                            ),
                            Text(
                              'Credit',
                              style: styles.headline3!.copyWith(
                                  color: MyAppColor.applecolor, fontSize: 12),
                            ),
                            Text(
                              '₹ 25.50',
                              style: styles.headline3!.copyWith(
                                  fontSize: 16, fontWeight: FontWeight.w800),
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
                              style: styles.headline3!.copyWith(fontSize: 14),
                            ),
                            Text('MODE OF TRANSACTION',
                                style: styles.headline3),
                            SizedBox(
                              height: Sizeconfig.screenHeight! / 40,
                            ),
                            Text(
                              '11245GHY78459011485',
                              style: styles.headline3!.copyWith(fontSize: 13),
                            ),
                            Text('TRANSACTION ID',
                                style:
                                    styles.headline3!.copyWith(fontSize: 10)),
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
                                  '26.04.2021',
                                  style: TextStyle(fontSize: 12),
                                ),
                                SizedBox(
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
                              style: styles.headline3!.copyWith(fontSize: 14),
                            ),
                            Text(
                              'REASON',
                              style: styles.headline3!.copyWith(fontSize: 10),
                            ),
                            SizedBox(
                              height: Sizeconfig.screenHeight! / 10,
                            ),
                            Text(
                              'Successful',
                              style: styles.headline3!
                                  .copyWith(fontSize: 15, color: Colors.green),
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
  }

  _appbar() {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 110,
      iconTheme: IconThemeData(color: MyAppColor.blackdark),
      backgroundColor: MyAppColor.backgroundColor,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 18),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                _drawerKey.currentState!.openDrawer();
              },
              child: Image.asset(
                'assets/drawers.png',
                height: 22,
              ),
            ),
            SizedBox(
              width: 8,
            ),
            SizedBox(
              child: Row(
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: Image.asset(
                      'assets/logosmall.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Company Profile',
                        style: Mytheme.lightTheme(context)
                            .textTheme
                            .headline1!
                            .copyWith(fontSize: 12),
                      ),
                      
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 18),
          child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {},
                child: Image.asset(
                  'assets/notificationiocn.png',
                  width: 20,
                  height: 20,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: CircleAvatar(
                  child: ClipOval(),
                  backgroundColor: MyAppColor.white,
                ),
              ),
            ],
          ),
        ),
      ],
      bottom: PreferredSize(
        child: Column(
          children: [
            Container(
              color: MyAppColor.greynormal,
              child: _back(),
            ),
          ],
        ),
        preferredSize: Size.fromHeight(40),
      ),
    );
  }

  _back() {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: Container(
        height: Sizeconfig.screenHeight! / 20,
        color: MyAppColor.greynormal,
        child: Row(
          children: [
            SizedBox(
              width: 5,
            ),
            Container(
              height: 30,
              child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: MyAppColor.backgray,
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 17,
                      color: Colors.black,
                    ),
                  )),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Back",
              style: TextStyle(
                color: MyAppColor.blackdark,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Text("HOME (JOB-SEEKER) / MY TRANSACTIONS",
                style: GoogleFonts.darkerGrotesque(fontSize: 11)),
          ],
        ),
      ),
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
