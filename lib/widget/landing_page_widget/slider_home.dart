import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/widget/buttons/elevated_button.dart';

class MyImageView extends StatelessWidget {
  String imgPath;
  String count;
  String label;
  String description;

  MyImageView(this.imgPath, this.count, this.label, this.description);

  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme;
    return Container(
      width: Responsive.isMobile(context)
          ? Sizeconfig.screenWidth!
          : Sizeconfig.screenWidth! / 5.5,
      height:
          Responsive.isMobile(context) ? 00 : Sizeconfig.screenHeight! / 1.4,
      margin: EdgeInsets.only(left: 5, right: 5),
      decoration: BoxDecoration(
        // color: MyAppColor.white,
        image: DecorationImage(
            colorFilter: new ColorFilter.mode(
                MyAppColor.blackplane.withOpacity(0.3), BlendMode.softLight),
            image: AssetImage(
              imgPath,
            ),
            fit: BoxFit.cover),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                label,
                style: !Responsive.isDesktop(context)
                    ? backgroundColorR18
                    : backgroundcolorR15desktop,
              ),
              Text(
                count,
                style: !Responsive.isDesktop(context)
                    ? backgroundColorR12()
                    : backgroundcolorR10desktop,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  description,
                  style: !Responsive.isDesktop(context)
                      ? backgroundColorSb18
                      : backgroundColorSb12desktop,
                ),
                if (Responsive.isDesktop(context))
                  SizedBox(
                    height: Sizeconfig.screenHeight! / 30,
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      child: ElavatedButtons(
                        func: () {},
                        text: 'GET STARTED',
                        myHexColor: MyAppColor.orangelight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ), //button get started
        ],
      ),
    );
  }
}
