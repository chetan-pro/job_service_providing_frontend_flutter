// ignore_for_file: import_of_legacy_library_into_null_safe, must_be_immutable

import 'package:clippy_flutter/paralellogram.dart';
import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/constants/colors.dart';

class HashTag extends StatelessWidget {
  String text;
  String? iconUrl;
  double? cutLength;
  bool showHide;
  HashTag(
      {Key? key,
      required this.text,
      this.showHide = false,
      this.iconUrl,
      this.cutLength})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Parallelogram(
      cutLength: cutLength ?? 0.0,
      edge: Edge.RIGHT,
      child: Container(
        padding:const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: MyAppColor.greylight,
        ),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (iconUrl != null)
              Image.asset(iconUrl!, color: Colors.white, width: 20, height: 20),
            Padding(
              padding: EdgeInsets.only(left: showHide ? 3.0 : 8.0, right: 8.0),
              child: Text(
                showHide ? text : '# $text',
                style: !Responsive.isDesktop(context) ? whiteM12() : whiteM10(),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
