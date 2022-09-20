import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/routes/routes.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';

class Button extends StatelessWidget {
  final String? text;
  Function? func;

  Button({Key? key, @required this.text, this.func}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    return SizedBox(
      // width:
      //     Responsive.isDesktop(context) ? Sizeconfig.screenWidth! / 10 : null,
      child: OutlinedButton(
        onPressed: () {
          func!();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: !Responsive.isDesktop(context) ? 9.0 : 6),
          child: Text(
            text!,
            style: !Responsive.isDesktop(context)
                ? blackDarkR14()
                : blackDarkR12(),
            maxLines: 1,
            // overflow: ,
          ),
        ),
        style: OutlinedButton.styleFrom(
            side: BorderSide(color: MyAppColor.blackdark)),
      ),
    );
  }
}
