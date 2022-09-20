import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';

class CardWorkEx extends StatelessWidget {
  String? text;

  String? description;
  CardWorkEx({Key? key, this.text, this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme.headline1!;
    Sizeconfig().init(context);

    return Container(
      margin: EdgeInsets.only(
        left: Responsive.isDesktop(context) ? 00 : 00,
      ),
      width: Responsive.isDesktop(context)
          ? MediaQuery.of(context).size.width / 5
          : double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: MyAppColor.greynormal,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: Sizeconfig.screenWidth! / 3,
                color: MyAppColor.backgray,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [],
                ),
              ),
            ],
          ),
          SizedBox(
            height: Responsive.isMobile(context) ? 10 : 6,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: Responsive.isMobile(context) ? 20 : 13,
              right: 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Responsive.isMobile(context) ? 10 : 8,
                    ),
                    if (!Responsive.isDesktop(context))
                      Text('Chief Motion Designer & Animation \nEngineer ',
                          style: styles.copyWith(
                              fontSize: 18, fontWeight: FontWeight.w700)),
                    if (Responsive.isDesktop(context))
                      Text(
                        text != null
                            ? "${text}"
                            : 'Chief Motion Designer &\nAnimation Engineer ',
                        style: !Responsive.isDesktop(context)
                            ? blackDarkSb16()
                            : blackDarkSb14(),
                      ),
                    SizedBox(
                      height: Responsive.isMobile(context) ? 2 : 2,
                    ),
                    !Responsive.isMobile(context)
                        ? Text(
                            description != null
                                ? "${description}"
                                : 'Lakshaya Corparation',
                            style: !Responsive.isDesktop(context)
                                ? companyNameM14()
                                : companyNameM11(),
                          )
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
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 10, top: 6),
                                child: Text('Lakshaya Corparation',
                                    style: companyNameM14()),
                              )
                            ],
                          ),
                    SizedBox(
                      height: Responsive.isMobile(context) ? 12 : 7,
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
                          height: Responsive.isMobile(context) ? 14 : 13,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Responsive.isMobile(context) ? 14 : 13,
                    ),
                  ]),
            ),
          )
        ],
      ),
    );
  }
}
