import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/company/home/openjob_box.dart';
import 'package:hindustan_job/company/resume_result_box.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/widget/landing_page_widget/latest_goverment_job.dart';
import 'package:hindustan_job/widget/landing_page_widget/search_field.dart';

class ResumeResult extends StatefulWidget {
  const ResumeResult({Key? key}) : super(key: key);

  @override
  _ResumeResultState createState() => _ResumeResultState();
}

class _ResumeResultState extends State<ResumeResult> {
  @override
  Widget build(BuildContext context) {
    final styles1 = Mytheme.lightTheme(context).textTheme;

    final styles = Mytheme.lightTheme(context).textTheme.headline1!;
    return Scaffold(
      backgroundColor: MyAppColor.backgroundColor,
      appBar: _appbar(),
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15,right: 15),
          child: Column(
            children: [
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Search(),
              ),
              SizedBox(height: 15,),
              Container(
                width: Sizeconfig.screenWidth,
                child: Text("Search Result for Designer ",textAlign: TextAlign.left,),
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.filter_list_alt),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.expand_more),
                      ),
                      Text(
                        'Sort by Relevance',
                        style: styles1.headline1!
                            .copyWith(fontSize: 17, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 15,),
              ResumeResultBox(),
              SizedBox(height: 10,),
              ResumeResultBox(),
              SizedBox(height: 10,),
              ResumeResultBox(),
              SizedBox(height: 10,),
              ResumeResultBox(),
              SizedBox(height: 10,),
              ResumeResultBox(),
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
}
