// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/constants/colors.dart';

class SubmitElevatedButton extends StatelessWidget {
  String? label;
  Function? onSubmit;
  SubmitElevatedButton({Key? key, this.label, this.onSubmit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Padding(
        padding: const EdgeInsets.only(left: 00, right: 00),
        child: Text(
          '$label',
          style: whiteSb12(),
        ),
      ),
      onPressed: () => onSubmit!(),
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(MyAppColor.orangelight),
      ),
    );
  }
}
