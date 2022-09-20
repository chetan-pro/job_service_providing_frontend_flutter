import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/specing.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';

import 'package:hindustan_job/constants/colors.dart';

class SearchCard extends StatefulWidget {
  SearchCard({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchCard> createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard> {
  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme.headline1!;
    Sizeconfig().init(context);
    return Container(
        // width: !Responsive.isDesktop(context)
        //     ? null
        //     : Sizeconfig.screenWidth! / 4.7,
        margin: EdgeInsets.only(
          left: Responsive.isDesktop(context) ? 00 : 00,
        ),
        // width: Responsive.isDesktop(context)
        //     ? MediaQuery.of(context).size.width / 4.7
        //     : 500,
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

                    /*Icon(
                      Icons.wallet_travel,s
                      color: Colors.black,
                      size: 15,
                    ),*/
                    SizedBox(
                      height: !Responsive.isDesktop(context) ? 5 : 0,
                    ),
                    Text(
                      'Chief Motion Designer & Animation \nEngineer ',
                      style: !Responsive.isDesktop(context)
                          ? blackDarkSb16()
                          : blackDarkSb14(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 6),
                      child:
                          Text('Lakshaya Corparation', style: companyNameM14()),
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
                            "# Design",
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
                              "# Animation",
                              style: !Responsive.isDesktop(context)
                                  ? whiteM12()
                                  : whiteM10(),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 3),
                          padding: !Responsive.isDesktop(context)
                              ? EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10)
                              : EdgeInsets.all(3),
                          color: MyAppColor.greylight,
                          child: Center(
                            child: Text(
                              "# Graphics",
                              style: !Responsive.isDesktop(context)
                                  ? whiteM12()
                                  : whiteM10(),
                            ),
                          ),
                        ),
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
                              Text('Bhopal Madhaya Pradesh',
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
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            // verticalDirection: VerticalDirection.down,
                            children: [
                              Row(
                                children: [
                                  Text('explore', style: orangeDarkSb9()),
                                ],
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
