import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/constants/colors.dart';

class ElavatedButtons extends StatelessWidget {
  final String? text;
  final Color? myHexColor;
  Function func;

  ElavatedButtons({Key? key, this.text, this.myHexColor, required this.func});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        text!,
        style: !Responsive.isDesktop(context) ? whiteM14() : whiteM10(),
      ),
      style: ElevatedButton.styleFrom(
        primary: myHexColor,
      ),
      onPressed: () => func(),
    );
  }
}
