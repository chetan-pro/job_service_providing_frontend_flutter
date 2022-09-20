import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';

class TotalJobRegister extends StatelessWidget {
  String label;
  int count;
  TotalJobRegister({Key? key, required this.label, required this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(),
      child: Container(
        margin: Responsive.isMobile(context)
            ? EdgeInsets.symmetric(horizontal: 00)
            : EdgeInsets.symmetric(horizontal: 8),
        width:
            Responsive.isMobile(context) ? null : Sizeconfig.screenWidth! / 6.2,
        color: MyAppColor.grayplane,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  height: 40,

                  // width: 80,
                  // color: Colors.amber,
                  child: Image.asset(
                    'assets/side_logo.png',
                    // height: 35,
                    width: 80,
                  ),
                ),
                Container(
                  // alignment: Alignment.centerLeft,
                  height: 40,
                  // width: 50,
                  color: MyAppColor.blacklight,
                  child: Container(
                    margin: EdgeInsets.all(7),
                    child: Image.asset(
                      'assets/Mask_star.png',
                      // height: 50,
                      // width: 80,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Responsive.isMobile(context) ? 15 : 10,
            ),
            Text(
              '$count',
              style:
                  !Responsive.isDesktop(context) ? blackDarkR22 : blackDarkR16,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: Responsive.isMobile(context) ? 8 : 4,
            ),
            Text(
              '$label',
              style: !Responsive.isDesktop(context)
                  ? blackDarkM14()
                  : blackdarkM12,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: Responsive.isDesktop(context) ? 15 : 00,
            )
          ],
        ),
      ),
    );
  }
}
