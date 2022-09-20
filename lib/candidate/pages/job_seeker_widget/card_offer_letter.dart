import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';

class OfferLetterCard extends StatelessWidget {
  const OfferLetterCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme.headline1!;
    Sizeconfig().init(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Container(
          margin: EdgeInsets.only(
            left: Responsive.isDesktop(context) ? 00 : 00,
          ),
          width: Responsive.isDesktop(context)
              ? MediaQuery.of(context).size.width / 4.7
              : 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey[300],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: Responsive.isMobile(context)
                        ? Sizeconfig.screenWidth! / 2.5
                        : null,
                    height: 20,
                    color: MyAppColor.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/offer-letter-image.png',
                          height: 20,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          'You Received Offer Letter',
                          style: styles.copyWith(
                              fontSize: 10, color: MyAppColor.backgroundColor),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Container(
                    height: 20,
                    color: MyAppColor.backgray,
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
                      Image.asset(
                        'assets/bag_icn.png',
                        width: 15,
                      ),

                      /*Icon(
                        Icons.wallet_travel,
                        color: Colors.black,
                        size: 15,
                      ),*/
                      SizedBox(
                        height: Responsive.isMobile(context) ? 10 : 8,
                      ),
                      Text('Chief Motion Designer & Animation \nEngineer ',
                          style: styles.copyWith(
                              fontSize: 18, fontWeight: FontWeight.w700)),
                      SizedBox(
                        height: Responsive.isMobile(context) ? 2 : 7,
                      ),
                      Responsive.isMobile(context)
                          ? Text('Lakshaya Corparation',
                              style: styles.copyWith(
                                  color: MyAppColor.backgray, fontSize: 14))
                          : Row(
                              children: [
                                Icon(
                                  Icons.lock,
                                  color: MyAppColor.orangedark,
                                  size: 13,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  'Subscribe to Unlock Company info',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: MyAppColor.orangedark),
                                )
                              ],
                            ),
                      SizedBox(
                        height: Responsive.isMobile(context) ? 12 : 7,
                      ),
                      Row(
                        children: [
                          Container(
                            height: Responsive.isMobile(context) ? 25 : 18,
                            width: Responsive.isMobile(context) ? 80 : 60,
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
                            width: Responsive.isMobile(context) ? 25 : 22,
                            color: MyAppColor.greylight,
                            child: Center(
                              child: Text(
                                "..",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: MyAppColor.white,
                                    fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Responsive.isMobile(context) ? 14 : 13,
                      ),
                      Row(
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
                                'Bhopal Madhaya Pradesh',
                                style: styles.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                              // SizedBox(
                              //   width: Responsive.isMobile(context) ? 75 : 110,
                              // ),
                            ],
                          ),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'explore',
                                style: styles.copyWith(
                                    fontSize: 14, color: MyAppColor.orangedark),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: MyAppColor.orangedark,
                                size: Responsive.isMobile(context) ? 14 : 15,
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
