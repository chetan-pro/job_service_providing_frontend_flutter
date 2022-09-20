// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';

class SkillTag extends StatelessWidget {
  String text;
  SkillTag({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: !Responsive.isDesktop(context)
          ? const EdgeInsets.all(4)
          : const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: const Color(0xff755F55),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: !Responsive.isDesktop(context) ? 10 : 6,
            child: Icon(
              Icons.edit,
              size: !Responsive.isDesktop(context) ? 12.0 : 9,
              color: const Color(0xff755F55),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Text(
              text,
              style: !Responsive.isDesktop(context) ? whiteM10() : whiteM8(),
            ),
          ),
        ],
      ),
    );
  }
}
