import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/widget/register_page_widget/text_field.dart';

class TextEditable extends StatelessWidget {
  TextEditingController controller;
  String label;
  String? hintText;
  TextInputType? type;

  TextEditable(
      {Key? key,
      required this.controller,
      this.hintText,
      required this.label,
      this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 15),
        child: SizedBox(
          width: Responsive.isDesktop(context)
              ? Sizeconfig.screenWidth! / 4
              : null,
          child: TextfieldWidget(
              styles: blackDarkOpacityM12(),
              text: label,
              hintText: hintText,
              inputType: type,
              control: controller,
              onChanged: (value) {}),
        ));
  }
}
