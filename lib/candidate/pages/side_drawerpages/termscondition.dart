import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hindustan_job/candidate/theme_modeule/specing.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/widget/headers.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';

import '../../../services/api_services/landing_page_services.dart';

class TermsCondition extends StatefulWidget {
  const TermsCondition({Key? key}) : super(key: key);

  static String route = "/term";

  @override
  _TermsConditionState createState() => _TermsConditionState();
}

class _TermsConditionState extends State<TermsCondition> {
  @override
  void initState() {
    super.initState();
    fetchLandingPageStaticData();
  }

  var htmlData;
  fetchLandingPageStaticData() async {
    ApiResponse response =
        await getLandingPageStaticData('terms_and_condition');
    if (response.status == 200) {
      htmlData = response.body!.data['html_data'];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    return CustomHeader(
      text: 'HOME / TERMS & CONDITIONS',
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
                  padding: EdgeInsets.all(35),
                  color: MyAppColor.greynormal,
                  child: Column(
                    children: [
                      Text(
                        "TERMS & CONDITIONS",
                        style: blackDarkR12(),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Html(data: htmlData ?? ''),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Footer(),
        ],
      ),
    );
  }
}
