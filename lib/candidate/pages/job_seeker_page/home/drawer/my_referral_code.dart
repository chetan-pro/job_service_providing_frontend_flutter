import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hindustan_job/candidate/header/app_bar.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/drawer/drawer_jobseeker.dart';
import 'package:hindustan_job/candidate/routes/routes.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/mystring_text.dart';
import 'package:hindustan_job/services/api_services/user_services.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/buttons/elevated_button.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class MyReferralCode extends StatefulWidget {
  const MyReferralCode({Key? key}) : super(key: key);

  static const String route = '/my-refferal-code';

  @override
  State<MyReferralCode> createState() => _MyReferralCodeState();
}

class _MyReferralCodeState extends State<MyReferralCode> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  String? link;
  @override
  void initState() {
    super.initState();
  }

  getShareLink() async {
    ApiResponse response = await getDynamicLink();
    if (response.status == 200) {
      link = response.body!.data['share_link'];
      kIsWeb ? shares() : share();
    }
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: "Hindustaan Jobs",
        text:
            "Hey Download the Hindustan Jobs for getting all india jobs. Sign up with this link $link or use this Referal Code ${userData!.referrerCode}",
        chooserTitle: "Where you want to share",
        linkUrl: link);
  }

  Future<void> shares() async {
    await Share.share(
      "Hey Download the Hindustan Jobs for getting all india jobs. Sign up with this link ${"www.google.com"} or use this Referal Code ${userData!.referrerCode}",
      subject: 'hindustan job ',
    );
  }

  @override
  Widget build(BuildContext context) {
    return !Responsive.isDesktop(context)
        ? Scaffold(
            key: _drawerKey,
            drawer: Drawer(
              child: DrawerJobSeeker(),
            ),
            backgroundColor: MyAppColor.backgroundColor,
            appBar: CustomAppBar(
              context: context,
              drawerKey: _drawerKey,
              back: "HOME (JOB-SEEKER) / MY TRANSACTIONS",
            ),
            body: referelCode(context),
          )
        : Scaffold(
            body: referelCode(context),
          );
  }

  ListView referelCode(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              'MY REFERRAL CODE',
              style: blackDarkR16,
            ),
            SizedBox(
              height: 50,
            ),
            Image.asset(
              'assets/referral.png',
              height: Sizeconfig.screenHeight! / 8,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Refer your code to friends and family ",
              textAlign: TextAlign.justify,
              style: blackDark12,
            ),
            Text(
              "and get a cashback upto Rs 100",
              textAlign: TextAlign.justify,
              style: blackDark12,
          ),
            SizedBox(
              height: 50,
            ),
            if (userData!.referrerCode == null)
              Text(
                'Not Approved By Admin',
                style: blackDarkR12(),
                textAlign: TextAlign.center,
              ),
            Container(
              height: Sizeconfig.screenHeight! / 12,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              width: !Responsive.isDesktop(context)
                  ? Sizeconfig.screenWidth!
                  : Sizeconfig.screenWidth! / 5,
              // margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: MyAppColor.greynormal,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (!Responsive.isDesktop(context))
                      SizedBox(
                        width: Sizeconfig.screenWidth! / 12,
                      ),
                    if (userData!.referrerCode != null)
                      Text(
                        userData!.referrerCode ?? '',
                        style: Responsive.isDesktop(context)
                            ? blackDarkR16
                            : blackDarkR24,
                      ),
                    if (userData!.referrerCode != null)
                      InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(
                                  text: "${userData!.referrerCode}"))
                              .then((value) => showSnack(
                                  context: context,
                                  msg: "Referral code copied"));
                        },
                        child: Image.asset(
                          'assets/copy.png',
                          height: 25,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 80,
            ),
            if (userData!.referrerCode != null)
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: MyAppColor.orangelight,
                    padding: EdgeInsets.symmetric(
                        horizontal: Responsive.isDesktop(context) ? 26 : 25,
                        vertical: Responsive.isDesktop(context) ? 15 : 10),
                  ),
                  onPressed: () => getShareLink(),
                  child: Text("SHARE REFERRAL CODE", style: whiteRegular14))
          ],
        ),
        SizedBox(
          height: Sizeconfig.screenHeight! / 25,
        ),
        if (!Responsive.isDesktop(context)) Footer(),
        if (!Responsive.isDesktop(context))
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
                height: 18,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              height: 40,
              width: 40,
              child: Image.asset(
                'assets/logosmall.png',
                fit: BoxFit.cover,
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
              Image.asset(
                'assets/walleticon.png',
                width: 20,
                height: 20,
              ),
              SizedBox(
                width: 10,
              ),
              Image.asset(
                'assets/notificationiocn.png',
                width: 20,
                height: 20,
              ),
              SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: CircleAvatar(
                  child: ClipOval(
                    child: Image.asset(
                      'assets/male.png',
                      height: 36,
                      width: 36,
                      fit: BoxFit.cover,
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ],
      bottom: PreferredSize(
        child: Column(
          children: [
            _menu(),
            SizedBox(
              height: 10,
            ),
            _back(),
          ],
        ),
        preferredSize: Size.fromHeight(Sizeconfig.screenHeight! / 10),
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

  _back() {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: Container(
        height: 30,
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
            Text("HOME / CONTACT US",
                style: GoogleFonts.darkerGrotesque(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
