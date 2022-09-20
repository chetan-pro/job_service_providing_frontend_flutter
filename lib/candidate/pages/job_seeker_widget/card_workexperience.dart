// ignore_for_file: unused_import, prefer_const_literals_to_create_immutables, must_be_immutable, prefer_const_constructors

import 'Package:flutter/material.dart';
import 'package:hindustan_job/candidate/model/work_experience_model.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';

class CardWorkexperience extends StatelessWidget {
  String? data;
  String? companyName;
  CardWorkexperience({Key? key, this.data, this.companyName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme.headline1!;
    Sizeconfig().init(context);
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: !Responsive.isDesktop(context) ? 8 : 00, vertical: 2),
      child: Container(
         
          padding: !Responsive.isDesktop(context)
              ? EdgeInsets.only(left: 20,bottom: 6)
              : EdgeInsets.only(top: 12, bottom: 12, left: 12, right: 12),
          width: Responsive.isDesktop(context)
              ? MediaQuery.of(context).size.width / 5
              : double.infinity,
          decoration: BoxDecoration(
            color: MyAppColor.greynormal,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Responsive.isMobile(context) ? 10 : 00,
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Responsive.isMobile(context) ? 10 : 0,
                    ),
                    if (!Responsive.isDesktop(context))
                      Text(
                          data != null
                              ? "${data}"
                              : 'Chief Motion Designer & Animation \nEngineer ',
                          style: styles.copyWith(
                              fontSize: 18, fontWeight: FontWeight.w700)),
                    if (Responsive.isDesktop(context))
                      Text(
                          data != null
                              ? "${data}"
                              : 'Chief Motion Designer &\nAnimation Engineer ',
                          style: blackDarkSb12()),
                    SizedBox(
                      height: !Responsive.isDesktop(context) ? 2 : 00,
                    ),
                    // !Responsive.isMobile(context)
                    Text(
                      companyName != null
                          ? "${companyName}"
                          : 'Lakshaya Corparation',
                      style: companyNameM11(),
                    )
                    // : Row(
                    //     children: [
                    //       // Icon(
                    //       //   Icons.lock,
                    //       //   color: MyAppColor.orangedark,
                    //       //   size: 13,
                    //       // ),
                    //       // SizedBox(
                    //       //   width: 3,
                    //       // ),
                    //       // Text(
                    //       //   'Subscribe to Unlock Company info',
                    //       //   style: TextStyle(
                    //       //       fontSize: 10,
                    //       //       color: MyAppColor.orangedark),
                    //       // )
                    //     ],
                    //   ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
