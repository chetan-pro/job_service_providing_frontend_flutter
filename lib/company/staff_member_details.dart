import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/company/home/homepage.dart';
import 'package:hindustan_job/constants/colors.dart';

class StaffMemberDetails extends ConsumerStatefulWidget {
  const StaffMemberDetails({Key? key}) : super(key: key);

  @override
  _StaffMemberDetailsState createState() => _StaffMemberDetailsState();
}

class _StaffMemberDetailsState extends ConsumerState<StaffMemberDetails> {
  @override
  void initState() {
    super.initState();
    ref.read(companyProfile).getStaffResponse(context);
  }

  bool isSwitch = true;
  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme.headline2;

    return Scaffold(
      backgroundColor: MyAppColor.backgroundColor,
      appBar: _appbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "STAFF MEMBER DETAILS",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(left: 15),
                //width: double.infinity,
                height: 40,
                color: MyAppColor.greynormal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Staff Member Status : Enabled',
                      style: styles!.copyWith(fontSize: 19),
                    ),
                    Switch(
                      value: isSwitch,
                      onChanged: (value) {
                        setState(() {
                          isSwitch = value;
                        });
                      },
                      activeColor: Colors.green,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(".  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . "),
              SizedBox(
                height: 20,
              ),
              _name(styles),
              SizedBox(
                height: 20,
              ),
              _mobilenumber(styles),
              SizedBox(
                height: 20,
              ),
              _gender(styles),
              SizedBox(
                height: 20,
              ),
              _date(styles),
              SizedBox(
                height: 20,
              ),
              Text(".  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . "),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(left: 15),
                //width: double.infinity,
                height: 40,
                color: MyAppColor.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'This Staff Member can Post a Job',
                      style: styles.copyWith(fontSize: 19),
                    ),
                    Switch(
                      value: isSwitch,
                      onChanged: (value) {
                        setState(() {
                          isSwitch = value;
                        });
                      },
                      activeColor: Colors.green,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.only(left: 15),
                //width: double.infinity,
                height: 40,
                color: MyAppColor.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'This Staff Member can View an Applicant',
                      style: styles.copyWith(fontSize: 19),
                    ),
                    Switch(
                      value: isSwitch,
                      onChanged: (value) {
                        setState(() {
                          isSwitch = value;
                        });
                      },
                      activeColor: Colors.green,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.only(left: 15),
                //width: double.infinity,
                height: 40,
                color: MyAppColor.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'This Staff Member can Hire an Applicant',
                      style: styles.copyWith(fontSize: 19),
                    ),
                    Switch(
                      value: isSwitch,
                      onChanged: (value) {
                        setState(() {
                          isSwitch = value;
                        });
                      },
                      activeColor: Colors.green,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
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
              /*Image.asset(
                'assets/walleticon.png',
                width: 20,
                height: 20,
              ),*/
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
            _back(),
          ],
        ),
        preferredSize: Size.fromHeight(10),
      ),
    );
  }

  _back() {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: Container(
        height: 32,
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

  Padding _date(TextStyle? styles) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
        width: double.infinity,
        //height: Sizeconfig.screenHeight! / 10,
        color: MyAppColor.greynormal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '15.08.1947',
              style: styles,
            ),
            SizedBox(
              height: 5,
            ),
            Text('15.08.1947'),
          ],
        ),
      ),
    );
  }

  Padding _gender(TextStyle? styles) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
        width: double.infinity,
        //height: Sizeconfig.screenHeight! / 10,
        color: MyAppColor.greynormal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gender',
              style: styles,
            ),
            SizedBox(
              height: 5,
            ),
            Text('Male'),
          ],
        ),
      ),
    );
  }

  Padding _name(TextStyle? styles) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
        width: double.infinity,
        // height: 40,
        color: MyAppColor.greynormal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Full Name',
              style: styles,
            ),
            SizedBox(
              height: 5,
            ),
            Text('John Kumar Cena'),
          ],
        ),
      ),
    );
  }

  Padding _mobilenumber(TextStyle? styles) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
        width: double.infinity,
        //height: Sizeconfig.screenHeight! / 10,
        color: MyAppColor.greynormal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mobile Number',
              style: styles,
            ),
            SizedBox(
              height: 5,
            ),
            Text('+91 987 654 3210'),
          ],
        ),
      ),
    );
  }
}
