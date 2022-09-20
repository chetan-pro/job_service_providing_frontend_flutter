import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/model/job_model_two.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/specing.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';

import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/utility/function_utility.dart';

import '../../candidate/pages/login_page/login_page.dart';

class LatestJob extends StatefulWidget {
  JobsTwo job;
  LatestJob({Key? key, required this.job}) : super(key: key);

  @override
  State<LatestJob> createState() => _LatestJobState();
}

class _LatestJobState extends State<LatestJob> {
  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    return Container(
        margin: EdgeInsets.only(
          left: Responsive.isDesktop(context) ? 13 : 00,
        ),
        decoration: BoxDecoration(
          color: MyAppColor.greynormal,
        ),
        child: Column(
          crossAxisAlignment: !Responsive.isDesktop(context)
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 20,
                  color: MyAppColor.backgray,
                  child: new Image.asset(
                    'assets/heart.png',
                    height: 20,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Responsive.isMobile(context) ? 7 : 6,
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
                    Image.asset(
                      'assets/bag_icn.png',
                      width: 15,
                    ),
                    SizedBox(
                      height: !Responsive.isDesktop(context) ? 5 : 0,
                    ),
                    Text(
                      widget.job.jobTitle ?? '',
                      style: !Responsive.isDesktop(context)
                          ? blackDarkSb16()
                          : blackDarkSb14(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 6),
                      child: Text(widget.job.user!.name ?? '',
                          style: companyNameM14()),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: !Responsive.isDesktop(context)
                              ? EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10.5)
                              : EdgeInsets.all(3),
                          alignment: Alignment.center,
                          color: MyAppColor.greylight,
                          child: Center(
                              child: Text(
                            "# ${widget.job.industry!.name}",
                            style: !Responsive.isDesktop(context)
                                ? whiteM12()
                                : whiteM10(),
                          )),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(left: 3),
                          padding: !Responsive.isDesktop(context)
                              ? EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10.5)
                              : EdgeInsets.all(3),
                          color: MyAppColor.greylight,
                          child: Center(
                            child: Text(
                              "# ${widget.job.sector!.name}",
                              style: !Responsive.isDesktop(context)
                                  ? whiteM12()
                                  : whiteM10(),
                            ),
                          ),
                        ),
                        // Container(
                        //   margin: const EdgeInsets.only(left: 3),
                        //   padding: !Responsive.isDesktop(context)
                        //       ? EdgeInsets.symmetric(
                        //           vertical: 5, horizontal: 10)
                        //       : EdgeInsets.all(3),
                        //   color: MyAppColor.greylight,
                        //   child: Center(
                        //     child: Text(
                        //       "# ${widget.job.jobPostSkills!.first.skillSubCategories!.name}",
                        //       style: !Responsive.isDesktop(context)
                        //           ? whiteM12()
                        //           : whiteM10(),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          width: 3,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 0),
                          padding: !Responsive.isDesktop(context)
                              ? EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10.5)
                              : EdgeInsets.all(3),
                          color: MyAppColor.greylight,
                          child: Center(
                            child: Text(
                              "..",
                              style: !Responsive.isDesktop(context)
                                  ? whiteM12()
                                  : whiteM10(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical:
                              !Responsive.isDesktop(context) ? 10.5 : 10.5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 12,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                  locationShow(
                                      state: widget.job.state,
                                      city: widget.job.city),
                                  style: !Responsive.isDesktop(context)
                                      ? blackDarkSb12()
                                      : blackDarkSb9()),
                            ],
                          ),
                          if (Responsive.isDesktop(context))
                            SizedBox(
                              width: Sizeconfig.screenWidth! / 30,
                            ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  !Responsive.isDesktop(context)
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Login()))
                                      : showDialog(
                                          context: context,
                                          routeSettings: const RouteSettings(
                                              name: Login.route),
                                          builder: (_) => Container(
                                            constraints: BoxConstraints(
                                                maxWidth:
                                                    Sizeconfig.screenWidth! /
                                                        2.9),
                                            child: Dialog(
                                              elevation: 0,
                                              backgroundColor:
                                                  Colors.transparent,
                                              insetPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: Sizeconfig
                                                              .screenWidth! /
                                                          2.9,
                                                      vertical: 30),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(00),
                                              ),
                                              child: Container(
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      color: Colors.transparent,
                                                      margin: EdgeInsets.only(
                                                        right: 25,
                                                      ),
                                                      child: Login(),
                                                    ),
                                                    Positioned(
                                                      right: 0.0,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Container(
                                                          height: 25,
                                                          width: 25,
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          color: MyAppColor
                                                              .backgroundColor,
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: Image.asset(
                                                              'assets/back_buttons.png'),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                },
                                child: Row(
                                  children: [
                                    Text('explore', style: orangeDarkSb9()),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 0, left: 3),
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: MyAppColor.orangedark,
                                  size:
                                      !Responsive.isDesktop(context) ? 24 : 20,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
