import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hindustan_job/candidate/theme_modeule/specing.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/widget/headers.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';

import '../../../services/api_services/landing_page_services.dart';
import '../../../services/services_constant/response_model.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  static const String route = '/privacy-policy';

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  var htmlData;
  @override
  void initState() {
    super.initState();
    fetchLandingPageStaticData();
  }

  fetchLandingPageStaticData() async {
    ApiResponse response = await getLandingPageStaticData('privacy_policy');
    if (response.status == 200) {
      htmlData = response.body!.data['html_data'];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    return CustomHeader(
      text: 'HOME / PRIVACY POLICY',
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
                  padding: EdgeInsets.all(25),
                  color: MyAppColor.greynormal,
                  child: Column(
                    children: [
                      Text(
                        "PRIVACY POLICY",
                        style: blackDarkR12(),
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      Html(data: htmlData ?? "")
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
