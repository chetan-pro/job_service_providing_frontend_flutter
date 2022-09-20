import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hindustan_job/candidate/pages/landing_page/search_job_here.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/mystring_text.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/widget/buttons/outline_buttons.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:hindustan_job/widget/landing_page_widget/search_field.dart';
import 'package:hindustan_job/widget/landing_page_widget/slider/latestjob.dart';

class PrivateSectorViewAll extends StatefulWidget {
  const PrivateSectorViewAll({Key? key}) : super(key: key);

  @override
  _PrivateSectorViewAllState createState() => _PrivateSectorViewAllState();
}

class _PrivateSectorViewAllState extends State<PrivateSectorViewAll> {
  int _groupValue = -1;
  int _radioSelected = 1;
  late String _radioVal;

  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme.headline1!;
    final styleses = Mytheme.lightTheme(context).textTheme;
    Sizeconfig().init(context);
    return Scaffold(
      backgroundColor: MyAppColor.backgroundColor,
      appBar: _appbar(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                SizedBox(
                  height: Sizeconfig.screenHeight! / 30,
                ),
                if (!Responsive.isDesktop(context)) Search(),
                //  if (Responsive.isDesktop(context)) SerchJobHere(),
                SizedBox(
                  height: Sizeconfig.screenHeight! / 25,
                ),
                _privatesector(context, styles),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Container(
                    // height: Sizeconfig.screenHeight! / 5,
                    width: Sizeconfig.screenWidth,
                    color: MyAppColor.greynormal,
                    child: Column(
                      children: [
                        ListTile(
                          title: applyWith(),
                          leading: Radio(
                            activeColor: MyAppColor.orangelight,
                            value: 1,
                            groupValue: _radioSelected,
                            onChanged: (value) {},
                          ),
                        ),
                        ListTile(
                            title: separateResume(), leading: radiobutton()),
                        jobButton(),
                        SizedBox(
                          height: Sizeconfig.screenHeight! / 40,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  // height: Sizeconfig.screenHeight! / 5,
                  // width: Sizeconfig.screenWidth,
                  color: MyAppColor.greynormal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          iconLocation(),
                          jobLocation(styles),
                        ],
                      ),
                      bhopalMadhyaPradesh(styles),

                      // SizedBox(
                      //   height: Sizeconfig.screenHeight! / 40,
                      // ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  // height: Sizeconfig.screenHeight! / 5,
                  // width: Sizeconfig.screenWidth,
                  color: MyAppColor.greylight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          companyText(styles),
                          lakshyaCorporations(styles),
                        ],
                      ),
                      arrowButton()

                      // SizedBox(
                      //   height: Sizeconfig.screenHeight! / 40,
                      // ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  height: Sizeconfig.screenHeight! / 3,
                  // width: Sizeconfig.screenWidth,
                  color: MyAppColor.greynormal,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        jobDescription(styles),
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              description(styles),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Container(
                    height: Sizeconfig.screenHeight! / 4.5,
                    width: double.infinity,
                    color: MyAppColor.greynormal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                          ),
                          child: skillsetsRequired(),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 22, top: 15),
                              child: _skillsAdobe(styleses),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 7, top: 15),
                              child: _skillsAdobe(styleses),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 22, top: 10),
                              child: _bender(styleses),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10, left: 5),
                              child: _skillsAdobe(styleses),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 22, top: 10),
                              child: _skillsAdobe(styleses),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5, top: 10),
                              child: _bender(styleses),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                _applyjob(styles, 'EXPERIENCED REQUIRED', '2 - 4 Years'),
                _applyjob(styles, 'EDUCATION REQUIRED',
                    'Graduation from Design School'),
                _applyjob(styles, 'EMPLOYMENT TYPE', 'Full-Time'),
                _applyjob(styles, 'CONTRACT TYPE', 'Contracted: 18 Months'),
                _applyjob(
                    styles, 'WORK FROM HOME', 'Temporarily due to Covid-19'),
                _applyjob(styles, 'WORK SCHEDULE', 'Weekdays | Day Shift'),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 0, right: 5),
                        child: imageInterest(),
                      ),
                      notInterest(styles)
                    ],
                  ),
                ),
                SizedBox(
                  height: Sizeconfig.screenHeight! / 18,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  child: simillarJobs(styles),
                ),
              ],
            ),
          ),
          LatestJObsSlider(listOfJobs: const [],cardState: CardState.latest,),
          Column(
            children: [
              SizedBox(
                height: 40,
                width: Sizeconfig.screenWidth! / 2.5,
                child: viewAlllButtons(context),
              ),
            ],
          ),
          SizedBox(
            height: Sizeconfig.screenHeight! / 13,
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

  Text bhopalMadhyaPradesh(TextStyle styles) => Text('Bhopal, Madhya Pradesh, India', style: styles);

  Text jobLocation(TextStyle styles) {
    return Text(
                          'JOB LOCATION',
                          style: styles,
                        );
  }

  Icon iconLocation() {
    return Icon(
                          Icons.location_on,
                          size: 15,
                        );
  }

  OutlinedButton viewAlllButtons(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PrivateSectorViewAll()));
      },
      child: Text(
        Mystring.viewAll,
        style: Mytheme.lightTheme(context).textTheme.headline1,
      ),
      style:
          OutlinedButton.styleFrom(side: const BorderSide(color: Colors.black)),
    );
  }

  Text simillarJobs(TextStyle styles) {
    return Text(
      'SIMILAR JOBS',
      style: styles,
    );
  }

  Text notInterest(TextStyle styles) {
    return Text('not interested in this job',
        style: styles.copyWith(color: MyAppColor.orangelight));
  }

  Image imageInterest() {
    return Image.asset(
      'assets/interestJob.png',
      height: 18,
    );
  }

  Text skillsetsRequired() => Text('SKILLSETS REQUIRED');

  Text description(TextStyle styles) {
    return Text(
      'The quick, brown fox jumps over a lazy dog. DJs flock by when MTV ax quiz prog. Junk MTV quiz graced by fox whelps. Bawds jog, flick quartz, vex nymphs. Waltz, bad nymph, for quick jigs vex! Fox nymphs grab quick-jived waltz. Brick quiz whangs jumpy veldt fox. Bright vixens jump; dozy fowl quack. Quick wafting zephyrs vex bold Jim. Quick zephyrs blow, vexing daft Jim. Sex-charged fop blew my junk TV quiz. How quickly daft jumping zebras vex. Two driven jocks help fax my big quiz. Quick, Baz, get my woven flax jodhpurs! "Now fax quiz Jack!" my brave ghost pled. Five quacking zephyrs jolt my wax bed. Flummoxed by job, kvetching W. zaps Iraq. Cozy sphinx waves quart jug of bad milk. A very bad quack might jinx zippy fowls. Few quips galvanized the mock jury box. Quick brown dogs jump over the lazy fox. The jay, pig, fox, zebra, and my wolves quack! Blowzy red vixens fight for a quick jump. Joaquin Phoenix was gazed by MTV for luck. A wizard’s job is to vex chumps quickly in fog. Watch "Jeopardy!", Alex Trebek"s fun TV quiz game. The quick, brown fox jumps over a lazy dog. DJs flock by when MTV ax quiz prog. Junk MTV quiz graced by fox whelps. Bawds jog, flick quartz, vex nymphs. Waltz, bad nymph, for quick jigs vex! Fox nymphs grab quick-jived waltz. Brick quiz whangs jumpy veldt fox. Bright vixens jump; dozy fowl quack. Quick wafting zephyrs vex bold Jim. Quick zephyrs blow, vexing daft Jim. Sex-charged fop blew my junk TV quiz. How quickly daft jumping zebras vex. Two driven jocks help fax.',
      textAlign: TextAlign.justify,
      style: styles.copyWith(fontSize: 13, fontWeight: FontWeight.w400),
    );
  }

  Text jobDescription(TextStyle styles) {
    return Text(
      'JOB DESCRIPTIONS',
      style: styles.copyWith(fontSize: 15, fontWeight: FontWeight.w600),
    );
  }

  OutlinedButton arrowButton() {
    return OutlinedButton(
        style:
            OutlinedButton.styleFrom(side: BorderSide(color: MyAppColor.white)),
        onPressed: () {},
        child: Icon(
          Icons.arrow_forward,
          color: MyAppColor.white,
          size: 25,
        ));
  }

  Text lakshyaCorporations(TextStyle styles) {
    return Text(
      'Lakshya Corporations',
      style: styles.copyWith(color: MyAppColor.backgroundColor),
    );
  }

  Text companyText(TextStyle styles) {
    return Text(
      'COMPANY',
      style: styles.copyWith(
          color: MyAppColor.backgroundColor,
          fontSize: 13,
          fontWeight: FontWeight.w400),
    );
  }

  Radio<int> radiobutton() {
    return Radio(
        value: 2,
        activeColor: MyAppColor.orangelight,
        groupValue: _radioSelected,
        onChanged: (value) {});
  }

  ElevatedButton jobButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: MyAppColor.orangelight,
        ),
        onPressed: () {},
        child: Text('APPLY FOR THIS JOB',
            style: TextStyle(color: MyAppColor.backgroundColor)));
  }

  Text separateResume() => Text('Apply with a separate Resume');

  Text applyWith() {
    return Text('Apply with your Profile Resume (Recommended)');
  }

  Padding _applyjob(TextStyle styles, String text, String number) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Container(
        padding: EdgeInsets.all(15),
        // height: Sizeconfig.screenHeight!,
        width: Sizeconfig.screenWidth,
        color: MyAppColor.greynormal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: styles.copyWith(fontSize: 13, fontWeight: FontWeight.w400),
            ),
            Text(
              number,
              style: styles,
            ),

            // SizedBox(
            //   height: Sizeconfig.screenHeight! / 40,
            // ),
          ],
        ),
      ),
    );
  }

  Container _privatesector(BuildContext context, TextStyle styles) {
    return Container(
        margin: EdgeInsets.only(
          left: Responsive.isDesktop(context) ? 12 : 00,
        ),
        width: Responsive.isDesktop(context)
            ? MediaQuery.of(context).size.width / 4.7
            : 500,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: MyAppColor.greynormal,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 20,
                  color: MyAppColor.pink,
                  child: Image.asset(
                    'assets/heart.png',
                    height: 20,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Responsive.isMobile(context) ? 10 : 6,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Responsive.isMobile(context) ? 20 : 10,
                right: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/bag_icn.png',
                          width: 15,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'PRIVATE  SECCTOR JOB',
                          style: styles.copyWith(color: MyAppColor.applecolor),
                        ),
                      ],
                    ),

                    /*Icon(
                      Icons.wallet_travel,
                      color: Colors.black,
                      size: 15,
                    ),*/

                    Text('Chief Motion Designer & Animation \nEngineer ',
                        style: styles.copyWith(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                    SizedBox(
                      height: Responsive.isMobile(context) ? 12 : 7,
                    ),
                    Wrap(
                      children: [
                        Container(
                          height: Responsive.isMobile(context) ? 25 : 18,
                          width: Responsive.isMobile(context) ? 80 : 40,
                          color: MyAppColor.greylight,
                          child: Center(
                            child: Text(
                              "# Design",
                              style: styles.copyWith(
                                  fontSize: 13,
                                  color: MyAppColor.backgroundColor),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 3),
                          height: Responsive.isMobile(context) ? 25 : 18,
                          width: Responsive.isMobile(context) ? 80 : 70,
                          color: MyAppColor.greylight,
                          child: Center(
                            child: Text(
                              "# Animation",
                              style: styles.copyWith(
                                  fontSize: 13,
                                  color: MyAppColor.backgroundColor),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 3),
                          height: Responsive.isMobile(context) ? 25 : 18,
                          width: Responsive.isMobile(context) ? 80 : 60,
                          color: MyAppColor.greylight,
                          child: Center(
                            child: Text(
                              "# Graphics",
                              style: styles.copyWith(
                                  fontSize: 13,
                                  color: MyAppColor.backgroundColor),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 0),
                          height: Responsive.isMobile(context) ? 25 : 18,
                          width: Responsive.isMobile(context) ? 50 : 22,
                          color: MyAppColor.greylight,
                          child: Center(
                            child: Text(
                              "# IT",
                              style: styles.copyWith(
                                  fontSize: 13,
                                  color: MyAppColor.backgroundColor),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 0, top: 3),
                          height: Responsive.isMobile(context) ? 25 : 18,
                          width: Responsive.isMobile(context) ? 50 : 22,
                          color: MyAppColor.greylight,
                          child: Center(
                            child: Text(
                              "# 3D",
                              style: styles.copyWith(
                                  fontSize: 13,
                                  color: MyAppColor.backgroundColor),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 2, top: 3),
                          height: Responsive.isMobile(context) ? 25 : 18,
                          width: Responsive.isMobile(context) ? 70 : 22,
                          color: MyAppColor.greylight,
                          child: Center(
                            child: Text(
                              "# Motion",
                              style: styles.copyWith(
                                  fontSize: 13,
                                  color: MyAppColor.backgroundColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Responsive.isMobile(context) ? 14 : 13,
                    ),
                    Text(
                      '₹ 3.84 - 5.80 Lakh per Anum',
                      style: styles.copyWith(
                          fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'Base Salary',
                      style: styles.copyWith(
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
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
              onTap: () {},
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

  // Widget _myRadioButton({String title, int value, Function? onChanged}) {
  //   return RadioListTile(
  //     value: value,
  //     groupValue: _groupValue,
  //     onChanged: onChanged,
  //     title: Text(title),
  //   );
  // }
  Container _bender(TextTheme styles) {
    return Container(
      height: Sizeconfig.screenHeight! / 24,

      // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      width: Sizeconfig.screenWidth! / 3.5,
      decoration: BoxDecoration(
        color: MyAppColor.applecolor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 4,
          ),
          Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: MyAppColor.white,
              ),
              child: Image.asset(
                'assets/adobe-image.png',
                height: 15,
              )),
          SizedBox(
            width: 10,
          ),
          Text(
            'Adobe ',
            style: styles.headline1!
                .copyWith(fontSize: 13, color: MyAppColor.white),
          ),
        ],
      ),
    );
  }

  Container _skillsAdobe(TextTheme styles) {
    return Container(
      height: Sizeconfig.screenHeight! / 24,

      // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      width: Sizeconfig.screenWidth! / 2.4,
      decoration: BoxDecoration(
        color: MyAppColor.applecolor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 4,
          ),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: MyAppColor.white,
            ),
            child: Image.asset(
              'assets/adobe-image.png',
              height: 15,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'Adobe Photoshop',
            style: styles.headline1!
                .copyWith(fontSize: 13, color: MyAppColor.white),
          ),
        ],
      ),
    );
  }
}
