// import 'dart:js';
// import 'dart:js' as js;

// ignore_for_file: unused_import
import 'package:vrouter/vrouter.dart';
import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/model/subscription_list.dart';
import 'package:hindustan_job/candidate/pages/side_drawerpages/aboutus.dart';
import 'package:hindustan_job/candidate/pages/side_drawerpages/privacypolicy.dart';
import 'package:hindustan_job/candidate/pages/side_drawerpages/termscondition.dart';
import 'package:hindustan_job/candidate/theme_modeule/specing.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../candidate/pages/job_seeker_page/home/drawer/url_laucher.dart';
import '../../candidate/pages/side_drawerpages/contactus.dart';

class Footer extends StatefulWidget {
  Function? loginPop;

  Footer({Key? key, this.loginPop}) : super(key: key);

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme.headline1!;
    Sizeconfig().init(context);
    return !Responsive.isDesktop(context)
        ? Container(
            margin: EdgeInsets.only(top: 30),
            padding: paddingHorizontal25ver35,
            color: MyAppColor.greylight,
            width: Sizeconfig.screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/Group.png',
                  height: 45,
                  // width: 60,
                ),
                SizedBox(
                  height: height10,
                ),
                reserverd(styles, context),
                SizedBox(
                  height: 45,
                ),
                role(styles, context),
                SizedBox(
                  height: 16,
                ),
                jobSeeker(styles, context, 'Job-Seekers'),
                SizedBox(
                  height: height8,
                ),
                jobSeeker(styles, context, 'Company'),
                const SizedBox(
                  height: 8,
                ),
                jobSeeker(styles, context, 'home-Service Provider'),
                SizedBox(
                  height: height8,
                ),
                jobSeeker(styles, context, 'Home-Service Seekers'),
                SizedBox(
                  height: height8,
                ),
                jobSeeker(styles, context, 'Local Hunar'),
                const SizedBox(
                  height: 45,
                ),
                workWithUs(styles, context),
                const SizedBox(
                  height: 18,
                ),
                jobSeeker(styles, context, 'Business Correspondence'),
                SizedBox(
                  height: height8,
                ),
                jobSeeker(styles, context, 'Cluster Manager'),
                SizedBox(
                  height: height8,
                ),
                jobSeeker(styles, context, 'Advisor'),
                SizedBox(
                  height: height8,
                ),
                jobSeeker(styles, context, 'Field Sales Executive'),
                const SizedBox(
                  height: 45,
                ),
                titleOfHeadFooter(styles, context, 'Services'),
                SizedBox(
                  height: 18,
                ),
                jobSeeker(styles, context, 'Job Posting'),
                SizedBox(
                  height: height8,
                ),
                jobSeeker(styles, context, 'Resume Access'),
                SizedBox(
                  height: height8,
                ),
                jobSeeker(styles, context, 'Custom Jobs Alert'),
                SizedBox(
                  height: height8,
                ),
                jobSeeker(styles, context, 'Search Jobs'),
                SizedBox(
                  height: height8,
                ),
                footerText(context, text: 'Contact Us', route: Contact()),
                SizedBox(
                  height: height8,
                ),
                jobSeeker(styles, context, 'Testimonials'),
                SizedBox(
                  height: height8,
                ),
                jobSeeker(styles, context, 'Subscription'),
                const SizedBox(
                  height: 45,
                ),
                titleOfHeadFooter(styles, context, 'Stay Connected'),
                SizedBox(
                  height: 18,
                ),
                jobSeeker(styles, context, 'Faceebok',
                    url: 'https://www.facebook.com/hindustaanjobs.hj/'),
                SizedBox(
                  height: height8,
                ),
                jobSeeker(styles, context, 'Instagram',
                    url: 'https://www.instagram.com/hindustaanjobs/?hl=en'),
                SizedBox(
                  height: height8,
                ),
                jobSeeker(styles, context, 'Twitter',
                    url: 'https://twitter.com/hindustaanjobs'),
                SizedBox(
                  height: height8,
                ),
                jobSeeker(styles, context, 'Linkedin',
                    url: 'https://www.linkedin.com/company/hindustaanjobs/'),
                SizedBox(
                  height: height8,
                ),
                jobSeeker(styles, context, 'Youtube',
                    url:
                        'https://www.youtube.com/channel/UCFFxMQRdO0njLzqdnFFqV7A'),
                SizedBox(
                  height: height8,
                ),
                Row(
                  children: [
                    Image.asset(
                      "assets/play_store_download.png",
                      height: Responsive.isDesktop(context) ? 30 : 45,
                    ),
                    Image.asset(
                      "assets/app_store_download.png",
                      height: Responsive.isDesktop(context) ? 20 : 30,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 45,
                ),
                titleOfHeadFooter(styles, context, 'Legal'),
                SizedBox(
                  height: 18,
                ),
                legalText(
                  text: 'Privacy Policy',
                  route: 'privacy_policy',
                ),
                SizedBox(
                  height: height8,
                ),
                legalText(
                  text: 'Security and Fraud',
                  route: 'security_and_fraud',
                ),
                SizedBox(
                  height: height8,
                ),
                legalText(text: 'Terms of use', route: "terms_and_condition"),
                SizedBox(
                  height: height8,
                ),
                legalText(
                    text: 'Beaware of Fraudsters',
                    route: "beaware_of_fraudsters"),
                SizedBox(
                  height: height8,
                ),
                legalText(text: 'Be Safe', route: "be_safe"),
                SizedBox(
                  height: height8,
                ),
              ],
            ),
          )
        : Container(
            padding: paddingHorizontal25ver35,
            color: MyAppColor.greylight,
            child: Padding(
              padding: paddingHorizontal25,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/Group.png',
                          height: 45,
                          // width: 60,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        reserverd(styles, context),
                        SizedBox(
                          height: Sizeconfig.screenHeight! / 8,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: Sizeconfig.screenWidth! / 4,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        role(styles, context),
                        SizedBox(
                          height: 16,
                        ),
                        jobSeeker(styles, context, 'Job-Seekers'),
                        SizedBox(
                          height: height8,
                        ),
                        jobSeeker(styles, context, 'Company'),
                        const SizedBox(
                          height: 8,
                        ),
                        jobSeeker(styles, context, 'home-Service Provider'),
                        SizedBox(
                          height: height8,
                        ),
                        jobSeeker(styles, context, 'Home-Service Seekers'),
                        SizedBox(
                          height: height8,
                        ),
                        jobSeeker(styles, context, 'Local Hunar'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        workWithUs(styles, context),
                        SizedBox(
                          height: 18,
                        ),
                        jobSeeker(styles, context, 'Business Correspondence'),
                        SizedBox(
                          height: height8,
                        ),
                        jobSeeker(styles, context, 'Cluster Manager'),
                        SizedBox(
                          height: height8,
                        ),
                        jobSeeker(styles, context, 'Advisor'),
                        SizedBox(
                          height: height8,
                        ),
                        jobSeeker(styles, context, 'Field Sales Executive'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titleOfHeadFooter(styles, context, 'Services'),
                        SizedBox(
                          height: 18,
                        ),
                        jobSeeker(styles, context, 'Job Posting'),
                        SizedBox(
                          height: height8,
                        ),
                        jobSeeker(styles, context, 'Resume Access'),
                        SizedBox(
                          height: height8,
                        ),
                        jobSeeker(styles, context, 'Custom Jobs Alert'),
                        SizedBox(
                          height: height8,
                        ),
                        jobSeeker(styles, context, 'Search Jobs'),
                        SizedBox(
                          height: height8,
                        ),
                        footerText(context,
                            text: 'Contact Us', route: Contact()),
                        SizedBox(
                          height: height8,
                        ),
                        jobSeeker(styles, context, 'Testimonials'),
                        SizedBox(
                          height: height8,
                        ),
                        jobSeeker(styles, context, 'Subscription'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titleOfHeadFooter(styles, context, 'Stay Connected'),
                        SizedBox(
                          height: 18,
                        ),
                        jobSeeker(styles, context, 'Faceebok',
                            url: 'https://www.facebook.com/hindustaanjobs.hj/'),
                        SizedBox(
                          height: height8,
                        ),
                        jobSeeker(styles, context, 'Instagram',
                            url:
                                'https://www.instagram.com/hindustaanjobs/?hl=en'),
                        SizedBox(
                          height: height8,
                        ),
                        jobSeeker(styles, context, 'Twitter',
                            url: 'https://twitter.com/hindustaanjobs'),
                        SizedBox(
                          height: height8,
                        ),
                        jobSeeker(styles, context, 'Linkedin',
                            url:
                                'https://www.linkedin.com/company/hindustaanjobs/'),
                        SizedBox(
                          height: height8,
                        ),
                        jobSeeker(styles, context, 'Youtube',
                            url:
                                'https://www.youtube.com/channel/UCFFxMQRdO0njLzqdnFFqV7A'),
                        SizedBox(
                          height: height8,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/play_store_download.png",
                              height: 30,
                            ),
                            Image.asset(
                              "assets/app_store_download.png",
                              height: 20,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titleOfHeadFooter(styles, context, 'Legal'),
                        SizedBox(
                          height: 18,
                        ),
                        legalText(
                          text: 'Privacy Policy',
                          route: 'privacy_policy',
                        ),
                        SizedBox(
                          height: height8,
                        ),
                        legalText(
                          text: 'Security and Fraud',
                          route: 'security_and_fraud',
                        ),
                        SizedBox(
                          height: height8,
                        ),
                        legalText(
                            text: 'Terms of use', route: "terms_and_condition"),
                        SizedBox(
                          height: height8,
                        ),
                        legalText(
                            text: 'Beaware of Fraudsters',
                            route: "beaware_of_fraudsters"),
                        SizedBox(
                          height: height8,
                        ),
                        legalText(text: 'Be Safe', route: "be_safe"),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height8,
                  ),
                ],
              ),
            ),
          );
  }

  InkWell footerText(context, {text, route}) {
    return InkWell(
      onTap: () {
        if (route == null) return;
        Navigator.push(context, MaterialPageRoute(builder: (context) => route));
      },
      child: Text(text,
          style: !Responsive.isDesktop(context)
              ? backgroundColorR14()
              : backgroundColorR10()),
    );
  }

  InkWell legalText({text, route}) {
    return InkWell(
      onTap: () {
        if (route == null) return;
        context.vRouter.to("/$route");
      },
      child: Text(text,
          style: !Responsive.isDesktop(context)
              ? backgroundColorR14()
              : backgroundColorR10()),
    );
  }

  Text gmail(TextStyle styles, context) {
    return Text('support@hindustaanjobs.com',
        style: !Responsive.isDesktop(context)
            ? backgroundColorR14()
            : backgroundColorR9());
  }

  Text mobileno2(TextStyle styles, context) {
    return Text('+91 987 654 3210',
        style: !Responsive.isDesktop(context)
            ? backgroundColorR14()
            : backgroundColorR10());
  }

  Text mobileno1(TextStyle styles, context) {
    return Text('+91 987 654 3210',
        style: !Responsive.isDesktop(context)
            ? backgroundColorR14()
            : backgroundColorR10());
  }

  Text contact(context) {
    return Text('Contact',
        style: Responsive.isDesktop(context) ? whiteSb12() : whiteSb16());
  }

  Text workWithUs(TextStyle styles, context) {
    return Text('Works with Us',
        style: Responsive.isDesktop(context) ? whiteSb12() : whiteSb16());
  }

  Text titleOfHeadFooter(TextStyle styles, context, text) {
    return Text(text,
        style: Responsive.isDesktop(context) ? whiteSb12() : whiteSb16());
  }

  jobSeeker(TextStyle styles, context, text, {url}) {
    return InkWell(
      onTap: () async {
        if (url != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UrlLauncherWidget(url: '$url')));
          // js.context.callMethod('open', [url]);
        }
        if (widget.loginPop != null) {
          widget.loginPop!();
        }
      },
      child: Text(text,
          style: !Responsive.isDesktop(context)
              ? backgroundColorR14()
              : backgroundColorR10()),
    );
  }

  Text role(TextStyle styles, context) {
    return Text('Roles',
        style: Responsive.isDesktop(context) ? whiteSb12() : whiteSb16());
  }

  Text privacy(TextStyle styles, context) {
    return Text('Privacy Policy',
        style: !Responsive.isDesktop(context)
            ? backgroundColorR14()
            : backgroundColorR10());
  }

  Text subscription(TextStyle styles, context) {
    return Text('Subscription',
        style: !Responsive.isDesktop(context)
            ? backgroundColorR14()
            : backgroundColorR10());
  }

  Text term(context) {
    return Text('T & C',
        style: !Responsive.isDesktop(context)
            ? backgroundColorR14()
            : backgroundColorR10());
  }

  Text link(TextStyle styles, context) {
    return Text('Links',
        style: Responsive.isDesktop(context) ? whiteSb12() : whiteSb16());
  }

  Text reserverd(TextStyle styles, context) {
    return Text(
      '@2022 All Rights Reserved',
      style: !Responsive.isDesktop(context)
          ? backgroundColorR12()
          : backgroundColorR9(),
      textAlign: TextAlign.center,
    );
  }
}
