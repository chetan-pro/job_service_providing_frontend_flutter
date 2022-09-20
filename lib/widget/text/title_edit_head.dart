import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';

class TitleEditHead extends StatelessWidget {
  String title;
  TitleEditHead({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      width:
          Responsive.isDesktop(context) ? Sizeconfig.screenWidth! / 1.9 : null,
      alignment: Alignment.center,
      padding: !Responsive.isDesktop(context)
          ? EdgeInsets.all(15)
          : EdgeInsets.all(10),
      color: MyAppColor.greynormal,
      child: Text(
        '$title',
        style:
            !Responsive.isDesktop(context) ? titleHeadGrey16 : grayLightM12(),
      ),
    );
  }
}
