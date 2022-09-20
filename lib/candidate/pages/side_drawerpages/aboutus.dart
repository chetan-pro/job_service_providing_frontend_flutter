import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hindustan_job/candidate/theme_modeule/specing.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/widget/headers.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';

import '../../../services/api_services/landing_page_services.dart';

class AboutUs extends StatefulWidget {
  String passkey;
  AboutUs({Key? key, required this.passkey}) : super(key: key);

  static const String route = '/about';
  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  String aboutUsHtml = '';
  @override
  void initState() {
    super.initState();
    fetchAboutUsHtmlData();
  }

  fetchAboutUsHtmlData() async {
    ApiResponse response = await getLandingPageStaticData(widget.passkey);
    if (response.status == 200) {
      aboutUsHtml = response.body!.data['html_data'];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    return CustomHeader(
      text: 'HOME / ${(widget.passkey).replaceAll("_", " ").toUpperCase()}',
      body: ListView(
        children: [
          Padding(
            padding: paddingAll10,
            child: Column(
              children: [
                SizedBox(
                  height: Sizeconfig.screenHeight! / 30,
                ),
                Container(
                  padding: paddingAll25,
                  color: MyAppColor.greynormal,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          widget.passkey.replaceAll("_", " ").toUpperCase(),
                          style: blackDarkR12(),
                        ),
                        SizedBox(
                          height: Sizeconfig.screenHeight! / 30,
                        ),
                        Html(data: aboutUsHtml),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: Sizeconfig.screenHeight! / 30,
          ),
          // !Responsive.isDesktop(context)
          //     ? Center(
          //         child: Wrap(
          //           runSpacing: 11,
          //           spacing: 11,
          //           children: [
          //             cardAbout(),
          //             cardAbout(),
          //             cardAbout(),
          //             cardAbout(),
          //           ],
          //         ),
          //       )
          //     : Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           cardAbout(),
          //           SizedBox(
          //             width: Sizeconfig.screenWidth! / 75,
          //           ),
          //           cardAbout(),
          //           SizedBox(
          //             width: Sizeconfig.screenWidth! / 75,
          //           ),
          //           cardAbout(),
          //           SizedBox(
          //             width: Sizeconfig.screenWidth! / 75,
          //           ),
          //           cardAbout(),
          //         ],
          //       ),
          
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: Sizeconfig.screenHeight! / 22,
          ),
          Footer(),
        ],
      ),
    );
  }

  Widget cardAbout() {
    return Container(
      width:
          Responsive.isDesktop(context) ? Sizeconfig.screenWidth! / 12 : null,
      //    constraints: BoxConstraints(maxWidth: Sizeconfig.screenWidth! / 2.2),
      child: Column(
        children: [
          SizedBox(
            width: !Responsive.isDesktop(context)
                ? Sizeconfig.screenWidth! / 2.2
                : null,
            child: Image.asset(
              'assets/male-slider.png',
            ),
          ),
          Container(
            color: MyAppColor.greynormal,
            padding: paddingAll10,
            width: !Responsive.isDesktop(context)
                ? Sizeconfig.screenWidth! / 2.2
                : Sizeconfig.screenWidth! / 2.2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Doe',
                  style: blackDarkSb14(),
                ),
                Text(
                  'Founder',
                  style: blackDarkR12(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _back() {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: Container(
        height: 50,
        color: MyAppColor.greynormal,
        child: Row(
          children: [
            SizedBox(
              width: 5,
            ),
            Container(
              height: 30,
              child: CircleAvatar(
                  backgroundColor: MyAppColor.backgray,
                  child: Icon(
                    Icons.arrow_back,
                    size: 20,
                    color: Colors.black,
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
            Text("HOME / ABOUT US",
                style: GoogleFonts.darkerGrotesque(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
