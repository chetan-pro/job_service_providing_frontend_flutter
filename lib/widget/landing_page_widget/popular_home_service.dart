// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/utility/function_utility.dart';

import '../../candidate/model/services_model.dart';
import '../../candidate/pages/login_page/login_page.dart';

class PopularHomeService extends StatelessWidget {
  Services service;
  PopularHomeService({Key? key, required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      margin: EdgeInsets.symmetric(horizontal: 8),
      width:
          !Responsive.isDesktop(context) ? null : Sizeconfig.screenWidth! / 5,
      color: MyAppColor.greynormal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  height: !Responsive.isDesktop(context)
                      ? Sizeconfig.screenHeight! / 8
                      : 80,
                  width: !Responsive.isDesktop(context)
                      ? Sizeconfig.screenWidth! / 4.5
                      : 80,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/box-image.png'),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding:
                      EdgeInsets.only(left: 15, bottom: 15, top: 15, right: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              // SizedBox(
                              //   width: 21,
                              // ),
                              SizedBox(
                                height: Responsive.isMobile(context) ? 18 : 15,
                                width: Responsive.isMobile(context) ? 18 : 15,
                                child: Image.asset(
                                  'assets/seetting-icon.png',
                                  fit: BoxFit.cover,
                                ),
                              )
                            ],
                          ),
                          // SizedBox(
                          //   width: Responsive.isMobile(context) ? 80 : 60,
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              for (var i = 0; i < 4; i++)
                                Icon(
                                  Icons.star,
                                  color: MyAppColor.yellowdark,
                                  size: 14,
                                ),
                              Icon(
                                Icons.star,
                                color: MyAppColor.white,
                                size: 16,
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.serviceName ?? '',
                            style: !Responsive.isDesktop(context)
                                ? blackDarkSb16()
                                : blackDarkSb12(),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            service.user!.name ?? '',
                            style: !Responsive.isDesktop(context)
                                ? companyNameM14()
                                : companyNameM11(),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (!Responsive.isDesktop(context))
            SizedBox(
              height: 10,
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: !Responsive.isDesktop(context)
                        ? EdgeInsets.all(5)
                        : EdgeInsets.all(5),
                    color: MyAppColor.greylight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: !Responsive.isDesktop(context) ? 12 : 12,
                          width: !Responsive.isDesktop(context) ? 12 : 12,
                          child: Image.asset('assets/box-setting.png'),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                            '',
                            style: !Responsive.isDesktop(context)
                                ? whiteM12()
                                : whiteM8()),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    color: MyAppColor.greylight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 12,
                          width: 12,
                          child: Image.asset('assets/box-setting.png'),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text('Electrician',
                            style: !Responsive.isDesktop(context)
                                ? whiteM12()
                                : whiteM8()),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5),
                    color: MyAppColor.greylight,
                    child: Text(
                      '... ',
                      style: !Responsive.isDesktop(context)
                          ? whiteM12()
                          : whiteM8(),
                    ),
                  )
                ],
              ),
              Text('₹${service.serviceCharge}',
                  style: !Responsive.isDesktop(context)
                      ? blackDarkM18()
                      : blackDarkM14())
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 15,
                      ),
                      Text('MP Nagar Zone ||,  ',
                          style: !Responsive.isDesktop(context)
                              ? blackDarkSb12()
                              : blackDarkSb9()),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 15),
                    // alignment: Alignment.topRight,
                    child: Text(
                        locationShow(
                            state: service.user!.state,
                            city: service.user!.city),
                        style: !Responsive.isDesktop(context)
                            ? blackDarkSb12()
                            : blackDarkSb9()),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  if (!Responsive.isDesktop(context)) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  } else {
                    showDialog(
                      context: context,
                      routeSettings: const RouteSettings(name: Login.route),
                      builder: (_) => Container(
                        constraints: BoxConstraints(
                            maxWidth: Sizeconfig.screenWidth! / 2.9),
                        child: Dialog(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          insetPadding: EdgeInsets.symmetric(
                              horizontal: Sizeconfig.screenWidth! / 2.9,
                              vertical: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(00),
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
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      height: 25,
                                      width: 25,
                                      padding: EdgeInsets.all(5),
                                      color: MyAppColor.backgroundColor,
                                      alignment: Alignment.topRight,
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
                  }
                },
                child: Row(
                  children: [
                    Text('explore',
                        style: !Responsive.isDesktop(context)
                            ? orangeDarkSb12()
                            : orangeDarkSb9()),
                    Icon(
                      Icons.arrow_forward,
                      color: MyAppColor.orangedark,
                      size: !Responsive.isDesktop(context) ? 24 : 20,
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
